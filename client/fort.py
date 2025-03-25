import sys
import os
import subprocess
import json
import logging
import threading
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
import pystray
from PIL import Image, ImageDraw
import requests
from datetime import datetime
import ctypes
import tempfile
import win32crypt
import base64
import socket
from pywinauto import Application
import win32gui
import win32con
import win32api
import win32cred
from logging.handlers import RotatingFileHandler

# 配置日志
log_file = os.path.join(os.getenv('APPDATA'), 'fortress_client.log')
handler = RotatingFileHandler(log_file, maxBytes=1024 * 1024, backupCount=5)
handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().addHandler(handler)
logging.getLogger().setLevel(logging.INFO)

class FortressClient:
    def __init__(self, server_host, server_port):
        self.server_url = f"http://{server_host}:{server_port}"
        self.local_port = 45654
        self.running = True
        self.state = {
            'status': 'disconnected',  # disconnected, connecting, connected
            'local_ip': None,
            'server_connected': False,
            'last_error': None,
            'version': '1.0.0'
        }
        self.server = None
        self.icon = None
        logging.info(f"客户端启动，服务器地址: {self.server_url}, 本地端口: {self.local_port}")

    def start(self):
        """启动客户端"""
        try:
            # 检查是否已运行
            if not self._check_single_instance():
                raise Exception("客户端已在运行")

            # 初始化本地服务器
            self._init_local_server()
            
            # 创建托盘图标
            self._create_tray_icon()
            
            # 启动状态检查线程
            self._start_state_monitor()
            
            # 启动本地服务器
            self._start_local_server()
            
            # 运行托盘图标(主线程)
            self.icon.run()
            
            return True
        except Exception as e:
            self.state['last_error'] = str(e)
            logging.error(f"启动客户端失败: {e}")
            return False

    def _check_single_instance(self):
        """检查是否已有实例运行"""
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('localhost', self.local_port))
        sock.close()
        return result != 0

    def _init_local_server(self):
        """初始化本地HTTP服务器"""
        self.server = HTTPServer(('0.0.0.0', self.local_port), RequestHandler)
        self.server.client = self
        self._configure_firewall()

    def _configure_firewall(self):
        """配置防火墙规则"""
        try:
            rule_name = "FortressClient"
            subprocess.run([
                'netsh', 'advfirewall', 'firewall', 'add', 'rule',
                f'name="{rule_name}"', 'dir=in', 'action=allow',
                'protocol=TCP', f'localport={self.local_port}'
            ], check=True)
        except Exception as e:
            logging.warning(f"配置防火墙失败: {e}")

    def _create_tray_icon(self):
        """创建系统托盘图标"""
        try:
            icon_path = self._get_icon_path()
            self.icon = pystray.Icon(
                'FortressClient',
                Image.open(icon_path),
                '堡垒机客户端',
                menu=self._create_tray_menu()
            )
        except Exception as e:
            raise Exception(f"创建托盘图标失败: {e}")

    def _get_icon_path(self):
        """获取或创建图标文件"""
        icon_path = os.path.join(os.path.dirname(__file__), 'fortress.ico')
        if not os.path.exists(icon_path):
            img = Image.new('RGB', (64, 64), color='white')
            draw = ImageDraw.Draw(img)
            draw.text((20, 10), 'F', fill='blue', size=40)
            img.save(icon_path)
        return icon_path

    def _create_tray_menu(self):
        """创建托盘菜单"""
        return pystray.Menu(
            pystray.MenuItem('状态', lambda: None, enabled=False),
            pystray.MenuItem('显示日志', self.show_log),
            pystray.MenuItem('退出', self.quit)
        )

    def _start_state_monitor(self):
        """启动状态监控线程"""
        threading.Thread(
            target=self._monitor_state,
            daemon=True
        ).start()

    def _start_local_server(self):
        """启动本地HTTP服务器"""
        threading.Thread(
            target=self.server.serve_forever,
            daemon=True
        ).start()

    def _monitor_state(self):
        """监控客户端状态"""
        while self.running:
            try:
                self.state['status'] = 'connecting'
                self._update_tray_status()

                # 获取本机IP
                local_ip = self._get_local_ip()
                if not local_ip:
                    raise Exception("无法获取有效的IP地址")
                self.state['local_ip'] = local_ip

                # 检查服务器连接并注册客户端
                if self._check_server_connection():
                    # 注册客户端
                    verify_url = f"{self.server_url}/api/client/verify"
                    data = {
                        'client_port': self.local_port,
                        'client_ip': local_ip,
                        'version': self.state['version']
                    }
                    
                    try:
                        logging.info(f"正在注册客户端: {data}")
                        response = requests.post(verify_url, json=data, timeout=5)
                        response.raise_for_status()  # 抛出HTTP错误
                        
                        if response.ok:
                            self.state['status'] = 'connected'
                            self.state['last_error'] = None
                            logging.info(f"客户端注册成功: {local_ip}:{self.local_port}")
                        else:
                            raise Exception(f"服务器返回错误: {response.status_code}")
                    except Exception as e:
                        self.state['status'] = 'disconnected'
                        self.state['last_error'] = f"客户端注册失败: {e}"
                        logging.error(f"客户端注册失败: {e}")
                else:
                    self.state['status'] = 'disconnected'
                    self.state['last_error'] = "无法连接到堡垒机"

                self._update_tray_status()
                
            except Exception as e:
                self.state['status'] = 'disconnected'
                self.state['last_error'] = str(e)
                self._update_tray_status()
                logging.error(f"状态检查失败: {e}")

            time.sleep(5)

    def _check_server_connection(self):
        """检查与服务器的连接"""
        try:
            # 先检查健康状态
            health_response = requests.get(
                f"{self.server_url}/api/health",
                timeout=2
            )
            if not health_response.ok:
                logging.error(f"堡垒机健康检查失败: {health_response.status_code}")
                return False

            self.state['server_connected'] = True
            logging.info("堡垒机连接正常")
            return True
            
        except Exception as e:
            self.state['server_connected'] = False
            logging.error(f"堡垒机连接检查失败: {e}")
            return False

    def _update_tray_status(self):
        """更新托盘图标状态"""
        if self.icon:
            status_text = {
                'connected': '已连接',
                'connecting': '正在连接...',
                'disconnected': '未连接'
            }.get(self.state['status'], '未知状态')
            
            if self.state['local_ip']:
                status_text += f" ({self.state['local_ip']})"
            
            if self.state['last_error']:
                status_text += f" - {self.state['last_error']}"
                
            self.icon.title = f'堡垒机客户端 - {status_text}'
            logging.info(f"状态更新: {status_text}")

    def _get_local_ip(self):
        """获取本机IP"""
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(('10.16.30.133', 8080))
            ip = s.getsockname()[0]
            s.close()
            return ip if ip.startswith('10.16.') else None
        except:
            return None

    def launch_rdp(self, host, username, password, credential_id):
        """生成RDP文件并调起mstsc进行RDP连接"""
        try:
            # 保存凭据到凭据管理器
            self._save_credential(host, username, password)

            # 创建RDP文件内容
            rdp_content = [
                'screen mode id:i:1',
                'use multimon:i:0',
                'desktopwidth:i:1920',
                'desktopheight:i:1080',
                'session bpp:i:32',
                f'full address:s:{host}',
                f'username:s:{username}',
                'authentication level:i:2',
                'enablecredsspsupport:i:1',
                'promptcredentialonce:i:1',
            ]

            # 写入RDP文件
            rdp_file_path = f'connect_{credential_id}.rdp'
            with open(rdp_file_path, 'w') as rdp_file:
                rdp_file.write('\n'.join(rdp_content))

            # 启动mstsc
            subprocess.Popen(f'mstsc "{rdp_file_path}"', shell=True)
            return True
        except Exception as e:
            logging.error(f"启动RDP连接失败: {e}")
            return False

    def _save_credential(self, host, username, password):
        """保存凭据到Windows凭据管理器"""
        try:
            credential = {
                'TargetName': f'TERMSRV/{host}',
                'Type': win32cred.CRED_TYPE_GENERIC,
                'UserName': username,
                'CredentialBlob': password,
                'Persist': win32cred.CRED_PERSIST_LOCAL_MACHINE
            }
            win32cred.CredWrite(credential, 0)
            logging.info(f"凭据已保存: {host}")
        except Exception as e:
            logging.error(f"保存凭据失败: {e}")

    def __del__(self):
        """清理凭据"""
        try:
            # 清理保存的凭据
            credentials = win32cred.CredEnumerate(None, 0)
            for cred in credentials:
                if cred['TargetName'].startswith('TERMSRV/'):
                    win32cred.CredDelete(cred['TargetName'], win32cred.CRED_TYPE_GENERIC, 0)
        except:
            pass

    def show_log(self):
        """显示日志文件"""
        log_file = os.path.join(os.getenv('APPDATA'), 'fortress_client.log')
        os.startfile(log_file)

    def quit(self):
        """退出程序"""
        self.running = False
        if self.icon:
            self.icon.stop()
        if self.server:
            self.server.shutdown()
        os._exit(0)

    def launch_ssh(self, host, username, password, port=22):
        """使用Xshell URL Scheme启动SSH连接"""
        try:
            # Xshell路径
            xshell_path = r'D:\xshell\Xshell\Xshell.exe'
            
            # 检查Xshell可执行文件是否存在
            if not os.path.exists(xshell_path):
                raise Exception(f"Xshell可执行文件不存在: {xshell_path}")
                
            # 构建连接URL (不包含密码的日志版本)
            logging.info(f"准备启动SSH连接: {host}:{port}, 用户名: {username}")
            
            # 构建实际URL (包含凭据)
            url = f"ssh://{username}:{password}@{host}:{port}/"
            
            # 尝试多种启动方式
            try_methods = [
                # 方式1: 直接使用URL作为参数
                {"cmd": f'"{xshell_path}" {url}', "desc": "URL参数方式"},
                # 方式2: 使用 -url 参数 (某些版本支持)
                {"cmd": f'"{xshell_path}" -url {url}', "desc": "-url参数方式"},
                # 方式3: 使用Xshell专用参数 (最可靠的方式)
                {"cmd": f'"{xshell_path}" -newtab -protocol ssh -host {host} -port {port} -username {username} -password {password}', "desc": "Xshell专用参数方式"},
                # 方式4: 使用Windows URL协议处理机制
                {"cmd": f'start {url}', "desc": "Windows URL协议方式"}
            ]
            
            success = False
            last_error = None
            
            for method in try_methods:
                try:
                    logging.info(f"尝试使用{method['desc']}启动Xshell")
                    subprocess.Popen(method["cmd"], shell=True)
                    logging.info(f"使用{method['desc']}启动Xshell成功")
                    success = True
                    break
                except Exception as e:
                    logging.warning(f"{method['desc']}启动失败: {e}")
                    last_error = e
            
            if not success:
                raise Exception(f"所有启动方式均失败，最后错误: {last_error}")
            
            return True
        except Exception as e:
            logging.error(f"启动SSH连接失败: {e}")
            return False

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            if self.path == '/status':
                self._handle_status()
            else:
                self._send_error(404, "Not Found")
        except Exception as e:
            self._send_error(500, str(e))

    def do_POST(self):
        """处理POST请求"""
        if self.path == '/rdp_connect':
            self._handle_rdp_connect()
        elif self.path == '/ssh_connect':
            self._handle_ssh_connect()
        else:
            self.send_error(404, "Not Found")

    def _handle_status(self):
        """处理状态请求"""
        client = self.server.client
        self._send_json_response(client.state)

    def _handle_rdp_connect(self):
        """处理RDP连接请求"""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)

            host = data.get('host')
            username = data.get('username')
            password = data.get('password')
            credential_id = data.get('credential_id')  # 获取 credential_id

            # 调起 mstsc.exe
            success = self.server.client.launch_rdp(host, username, password, credential_id)

            self._send_json_response({'success': success})
        except Exception as e:
            logging.error(f"处理RDP连接请求失败: {e}")
            self._send_error(500, str(e))

    def _handle_ssh_connect(self):
        """处理SSH连接请求"""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)

            host = data.get('host')
            username = data.get('username')
            password = data.get('password')
            port = data.get('port', 22)  # 默认SSH端口22

            # 调起 Xshell
            success = self.server.client.launch_ssh(host, username, password, port)

            self._send_json_response({'success': success})
        except Exception as e:
            logging.error(f"处理SSH连接请求失败: {e}")
            self._send_error(500, str(e))

    def _send_json_response(self, data, code=200):
        """发送JSON响应"""
        try:
            self.send_response(code)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            logging.info(f"发送响应: {data}")  # 添加日志
            self.wfile.write(json.dumps(data).encode())
        except Exception as e:
            logging.error(f"发送响应失败: {e}")

    def _send_error(self, code, message):
        """发送错误响应"""
        self._send_json_response({'error': message}, code)

def check_firewall():
    """检查防火墙设置"""
    try:
        import subprocess
        # 添加防火墙规则
        rule_name = "FortressClient"
        cmd = f'netsh advfirewall firewall show rule name="{rule_name}"'
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if "No rules match the specified criteria" in result.stdout:
            # 规则不存在，添加新规则
            add_cmd = f'netsh advfirewall firewall add rule name="{rule_name}" dir=in action=allow protocol=TCP localport=45654'
            subprocess.run(add_cmd, check=True)
            logging.info("已添加防火墙规则")
    except Exception as e:
        logging.error(f"防火墙配置失败: {e}")

def is_admin():
    """检查是否以管理员身份运行"""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def main():
    try:
        # 检查管理员权限
        if not is_admin():
            ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
            sys.exit(0)

        # 检查防火墙
        check_firewall()
        
        # 检查是否已经运行
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('localhost', 45654))
        if result == 0:
            ctypes.windll.user32.MessageBoxW(0, "堡垒机客户端已经在运行中", "提示", 0x40)
            sys.exit(1)
        
        sock.close()
        
        # 创建客户端实例
        client = FortressClient('10.16.30.133', 8080)
        
        # 启动客户端
        if not client.start():
            raise Exception("客户端启动失败")
            
    except Exception as e:
        logging.error(f"程序启动失败: {e}")
        ctypes.windll.user32.MessageBoxW(0, f"程序启动失败: {e}", "错误", 0x10)
        sys.exit(1)

if __name__ == '__main__':
    main()