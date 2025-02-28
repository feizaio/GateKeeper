import os
import sys
import configparser
import argparse
import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
import time
import requests
import win32ts
import json
from datetime import datetime

class RDPMonitor:
    def __init__(self, config_path):
        self.config = self.load_config(config_path)
        
    def load_config(self, config_path):
        """加载配置文件"""
        config = configparser.ConfigParser()
        if not config.read(config_path):
            print(f"Cannot read config file: {config_path}")
            raise Exception("Config file not found")
        return config['DEFAULT']
            
    def check_rdp_sessions(self):
        """检查RDP会话状态"""
        try:
            server = win32ts.WTS_CURRENT_SERVER_HANDLE
            sessions = win32ts.WTSEnumerateSessions(server)
            
            active_sessions = []
            for session in sessions:
                if session['State'] == win32ts.WTSActive:
                    try:
                        username = win32ts.WTSQuerySessionInformation(
                            server,
                            session['SessionId'],
                            win32ts.WTSUserName
                        )
                        
                        active_sessions.append({
                            'session_id': session['SessionId'],
                            'username': username,
                            'state': 'active'
                        })
                    except:
                        continue
                        
            return active_sessions
            
        except Exception as e:
            print(f"Error checking RDP sessions: {e}")
            return []
            
    def report_status(self, has_active_session, session_info=None):
        """向堡垒机报告状态"""
        try:
            data = {
                'server_ip': self.config['server_ip'],
                'has_active_session': has_active_session,
                'session_info': session_info,
                'timestamp': datetime.now().isoformat()
            }
            
            response = requests.post(
                f"{self.config['bastion_url']}/api/agent/status",
                json=data,
                timeout=5
            )
            
            if response.status_code != 200:
                print(f"Failed to report status: {response.text}")
                
        except Exception as e:
            print(f"Error reporting status: {e}")
            
    def run(self):
        print("RDP Monitor started")
        last_status = False
        
        while True:
            try:
                # 检查RDP会话
                active_sessions = self.check_rdp_sessions()
                has_active_session = bool(active_sessions)
                
                # 如果状态发生变化，立即报告
                if has_active_session != last_status:
                    print(f"Status changed: {has_active_session}")
                    self.report_status(has_active_session, active_sessions)
                    last_status = has_active_session
                time.sleep(5)  # 每5秒检查一次
                    
            except Exception as e:
                print(f"Error: {e}")
                time.sleep(5)

def main():
    # 使用 argparse 解析命令行参数
    parser = argparse.ArgumentParser(description="RDP Monitor Service")
    parser.add_argument('-f', '--config', type=str, default=None, 
                        help="Path to the config file (default is './config.ini')")
    args = parser.parse_args()

    # 判断是否传入自定义配置文件路径
    if args.config:
        config_path = args.config
    else:
        # 默认情况下使用当前目录下的 config.ini
        if getattr(sys, 'frozen', False):  # 如果是 EXE
            script_dir = sys._MEIPASS
        else:
            script_dir = os.path.dirname(os.path.abspath(__file__))
        config_path = os.path.join(script_dir, 'config.ini')

    # 启动 RDP 监控
    try:
        monitor = RDPMonitor(config_path)
        monitor.run()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    main()
