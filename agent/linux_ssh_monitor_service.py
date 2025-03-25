#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import configparser
import argparse
import socket
import time
import requests
import json
import psutil
import re
import signal
import logging
from datetime import datetime
import subprocess

# 配置日志
log = logging.getLogger('ssh_monitor')
log.setLevel(logging.INFO)

# 创建控制台处理器
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
log.addHandler(console_handler)

# 创建文件处理器
try:
    log_dir = '/var/log/ssh-monitor'
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    file_handler = logging.FileHandler(os.path.join(log_dir, 'ssh-monitor.log'))
    file_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    log.addHandler(file_handler)
except Exception as e:
    print("无法创建日志文件: {}，将仅使用控制台日志".format(e))

class SSHMonitor:
    def __init__(self, config_path):
        self.config = self.load_config(config_path)
        
    def load_config(self, config_path):
        """加载配置文件"""
        config = configparser.ConfigParser()
        if not config.read(config_path):
            log.error("Cannot read config file: {}".format(config_path))
            raise Exception("Config file not found")
        return config['DEFAULT']
            
    def check_ssh_sessions(self):
        """检查SSH会话状态"""
        try:
            # 在Linux上查找SSH会话
            active_sessions = []
            
            # 方法1: 使用 netstat 查找 ESTABLISHED 状态的 SSH 连接
            try:
                # 使用 netstat 查找活跃的 SSH 连接 (端口 22)
                netstat_cmd = "netstat -tn | grep ':22' | grep 'ESTABLISHED'"
                netstat_output = subprocess.check_output(netstat_cmd, shell=True, universal_newlines=True)
                
                for line in netstat_output.splitlines():
                    parts = line.split()
                    if len(parts) >= 5:
                        # 解析远程地址和端口
                        remote = parts[4].rsplit(':', 1)
                        if len(remote) == 2:
                            host = remote[0]
                            port = int(remote[1])
                            
                            # 查找对应进程
                            pid = self.find_pid_for_connection(host, port)
                            username = self.get_username_for_pid(pid) if pid else "unknown"
                            
                            active_sessions.append({
                                'pid': pid or 0,
                                'process': 'sshd',
                                'username': username,
                                'host': host,
                                'port': port,
                                'state': 'active',
                                'type': 'direct_connection'
                            })
                            
                log.info("通过 netstat 检测到 {} 个活跃 SSH 连接".format(len(active_sessions)))
            except subprocess.SubprocessError as e:
                log.warning("netstat 命令执行失败: {}".format(e))
            
            # 方法2: 使用 psutil 查找 sshd 进程
            if not active_sessions:
                ssh_pids = []
                for proc in psutil.process_iter(['pid', 'name', 'cmdline', 'username']):
                    try:
                        if proc.info['name'] == 'sshd':
                            # 过滤掉主进程和非客户端连接进程
                            cmdline = ' '.join(proc.info['cmdline']) if proc.info['cmdline'] else ''
                            if '@' in cmdline or 'notty' in cmdline:
                                pid = proc.info['pid']
                                ssh_pids.append(pid)
                                conn = self.get_connection_info(pid)
                                if conn:
                                    active_sessions.append({
                                        'pid': pid,
                                        'process': proc.info['name'],
                                        'username': conn.get('username', proc.info['username']),
                                        'host': conn.get('host', 'unknown'),
                                        'port': conn.get('port', 22),
                                        'state': 'active',
                                        'type': 'sshd_process'
                                    })
                    except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                        continue
                
                log.info("通过 psutil 检测到 {} 个 SSHD 进程".format(len(ssh_pids)))
            
            # 方法3: 使用 'who' 命令查找活动会话
            if not active_sessions:
                try:
                    who_output = subprocess.check_output(['who'], universal_newlines=True)
                    for line in who_output.splitlines():
                        if 'pts' in line and ('sshd' in line or ':' in line):
                            parts = line.split()
                            if len(parts) >= 5:
                                username = parts[0]
                                host = parts[4].strip('()')
                                
                                # 尝试查找对应的 PID
                                pid = self.find_pid_for_user_session(username)
                                
                                active_sessions.append({
                                    'pid': pid or 0,
                                    'process': 'sshd',
                                    'username': username,
                                    'host': host,
                                    'port': 22,  # 默认端口
                                    'state': 'active',
                                    'type': 'who_command'
                                })
                    
                    log.info("通过 who 命令检测到 {} 个活跃会话".format(len(active_sessions)))
                except subprocess.SubprocessError as e:
                    log.warning("who 命令执行失败: {}".format(e))
            
            # 如果没有找到活跃会话，确认一下没有相关进程
            if not active_sessions:
                log.info("未检测到活跃 SSH 会话，确认系统状态...")
                
                # 检查是否有 sshd 子进程
                try:
                    ps_cmd = "ps -ef | grep sshd | grep -v grep | wc -l"
                    ps_output = subprocess.check_output(ps_cmd, shell=True, universal_newlines=True).strip()
                    sshd_count = int(ps_output)
                    
                    # 一般至少有一个 sshd 主进程
                    if sshd_count > 1:
                        log.warning("检测到 {} 个 SSHD 进程，但未能识别活跃会话".format(sshd_count))
                except:
                    pass
            
            return active_sessions
            
        except Exception as e:
            log.error("Error checking SSH sessions: {}".format(e))
            return []
    
    def find_pid_for_connection(self, host, port):
        """根据连接信息查找对应的进程 ID"""
        try:
            # 使用 netstat 或 ss 命令查找
            cmd = "netstat -tnp 2>/dev/null | grep '{}:{}'".format(host, port)
            output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
            
            for line in output.splitlines():
                if 'ESTABLISHED' in line:
                    # 尝试提取 PID
                    pid_match = re.search(r'(\d+)/\w+', line)
                    if pid_match:
                        return int(pid_match.group(1))
            return None
        except:
            return None
    
    def find_pid_for_user_session(self, username):
        """根据用户名查找对应的 SSHD 进程 ID"""
        try:
            cmd = "ps -u {} -o pid,args | grep sshd | grep -v grep".format(username)
            output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
            
            for line in output.splitlines():
                parts = line.strip().split()
                if parts and parts[0].isdigit():
                    return int(parts[0])
            return None
        except:
            return None
            
    def get_connection_info(self, pid):
        """获取SSH连接信息"""
        try:
            # 使用netstat获取连接信息
            netstat_cmd = "netstat -tnp 2>/dev/null | grep {}".format(pid)
            netstat_output = subprocess.check_output(netstat_cmd, shell=True, universal_newlines=True)
            
            # 解析netstat输出
            for line in netstat_output.splitlines():
                if 'ESTABLISHED' in line:
                    parts = line.split()
                    if len(parts) >= 7:
                        # 获取远程地址和端口
                        remote = parts[4].rsplit(':', 1)
                        if len(remote) == 2:
                            host = remote[0]
                            port = int(remote[1])
                            
                            # 获取用户名 (从/proc/pid/environ或ps)
                            username = self.get_username_for_pid(pid)
                            
                            return {
                                'host': host,
                                'port': port,
                                'username': username
                            }
            return None
        except Exception as e:
            log.warning("Error getting connection info: {}".format(e))
            return None
            
    def get_username_for_pid(self, pid):
        """获取进程对应的用户名"""
        try:
            ps_cmd = "ps -o user= -p {}".format(pid)
            username = subprocess.check_output(ps_cmd, shell=True, universal_newlines=True).strip()
            return username
        except:
            return "unknown"
            
    def report_status(self, has_active_session, session_info=None):
        """向堡垒机报告状态"""
        try:
            data = {
                'server_ip': self.config['server_ip'],
                'has_active_session': has_active_session,
                'session_info': session_info,
                'session_type': 'ssh',  # 指定为SSH会话
                'timestamp': datetime.now().isoformat()
            }
            
            response = requests.post(
                "{}/api/agent/status".format(self.config['bastion_url']),
                json=data,
                timeout=5
            )
            
            if response.status_code != 200:
                log.error("Failed to report status: {}".format(response.text))
                
        except Exception as e:
            log.error("Error reporting status: {}".format(e))
            
    def run(self):
        log.info("SSH Monitor started")
        last_status = False
        last_report_time = 0
        force_report_interval = 60  # 每60秒强制报告一次状态，即使状态未变化
        
        # 设置信号处理
        def signal_handler(sig, frame):
            log.info("Terminating SSH Monitor...")
            # 在退出前报告无活跃会话
            self.report_status(False, [])
            sys.exit(0)
            
        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        
        while True:
            try:
                # 检查SSH会话
                active_sessions = self.check_ssh_sessions()
                has_active_session = bool(active_sessions)
                current_time = time.time()
                
                # 如果状态发生变化或者达到强制报告间隔，则报告状态
                if has_active_session != last_status or (current_time - last_report_time) >= force_report_interval:
                    if has_active_session != last_status:
                        log.info("状态变化: 从 {} 变为 {}".format(last_status, has_active_session))
                    else:
                        log.info("状态未变化，强制报告当前状态: {}".format(has_active_session))
                        
                    self.report_status(has_active_session, active_sessions)
                    last_status = has_active_session
                    last_report_time = current_time
                
                # 如果有活跃会话，更频繁地检查（2秒一次）
                # 如果无活跃会话，可以降低检查频率（5秒一次）
                check_interval = 2 if has_active_session else 5
                time.sleep(check_interval)
                    
            except Exception as e:
                log.error("Error: {}".format(e))
                time.sleep(5)

# 为systemd服务创建守护进程
def setup_systemd_service():
    """
    设置Systemd服务
    这个函数会创建Systemd服务文件，并尝试安装它
    """
    try:
        service_path = '/etc/systemd/system/ssh-monitor.service'
        
        with open(service_path, 'w') as f:
            f.write('''[Unit]
Description=SSH Monitor Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 {0}/linux_ssh_monitor_service.py
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
'''.format(os.path.dirname(os.path.abspath(__file__))))
        
        subprocess.check_call(['systemctl', 'daemon-reload'])
        log.info("Systemd service created successfully at {}".format(service_path))
        return True
    except Exception as e:
        log.error("Failed to setup systemd service: {}".format(e))
        return False

def main():
    # 使用 argparse 解析命令行参数
    parser = argparse.ArgumentParser(description="SSH Monitor Service for Linux")
    parser.add_argument('-f', '--config', type=str, default=None, 
                        help="Path to the config file (default is './config.ini')")
    parser.add_argument('--install', action='store_true', help="Install as a systemd service")
    parser.add_argument('--start', action='store_true', help="Start the systemd service")
    parser.add_argument('--stop', action='store_true', help="Stop the systemd service")
    parser.add_argument('--status', action='store_true', help="Check service status")
    args = parser.parse_args()

    # Systemd服务管理
    if args.install:
        if os.geteuid() != 0:
            log.error("You need to have root privileges to install the service.")
            sys.exit(1)
        if setup_systemd_service():
            log.info("Service installed successfully. Use 'systemctl start ssh-monitor' to start it.")
        else:
            log.error("Failed to install service.")
        return

    if args.start:
        try:
            subprocess.check_call(['systemctl', 'start', 'ssh-monitor'])
            log.info("Service started.")
        except Exception as e:
            log.error("Failed to start service: {}".format(e))
        return

    if args.stop:
        try:
            subprocess.check_call(['systemctl', 'stop', 'ssh-monitor'])
            log.info("Service stopped.")
        except Exception as e:
            log.error("Failed to stop service: {}".format(e))
        return

    if args.status:
        try:
            subprocess.check_call(['systemctl', 'status', 'ssh-monitor'])
        except:
            pass
        return

    # 判断是否传入自定义配置文件路径
    if args.config:
        config_path = args.config
    else:
        # 默认情况下使用当前目录下的 config.ini
        script_dir = os.path.dirname(os.path.abspath(__file__))
        config_path = os.path.join(script_dir, 'config.ini')

    # 启动 SSH 监控
    try:
        monitor = SSHMonitor(config_path)
        monitor.run()
    except Exception as e:
        log.error("Error: {}".format(e))

if __name__ == '__main__':
    main() 