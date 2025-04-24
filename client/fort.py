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
import shutil
import traceback
import platform
import uuid

# 定义 Windows 特定的进程创建标志
if sys.platform == 'win32':
    # Windows 平台才定义这个常量
    CREATE_NO_WINDOW = 0x08000000
else:
    # 其他平台设为0，不起作用
    CREATE_NO_WINDOW = 0

# 重定向标准输出和错误到日志文件
def setup_logging():
    """设置日志系统，重定向标准输出和错误"""
    log_dir = os.path.dirname(os.path.join(os.getenv('APPDATA'), 'fortress_client.log'))
    os.makedirs(log_dir, exist_ok=True)
    
    log_file = os.path.join(os.getenv('APPDATA'), 'fortress_client.log')
    handler = RotatingFileHandler(log_file, maxBytes=1024 * 1024, backupCount=5)
    handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    
    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    
    # 添加一个自定义异常处理器，将未捕获的异常写入日志
    def handle_exception(exc_type, exc_value, exc_traceback):
        if issubclass(exc_type, KeyboardInterrupt):
            # 正常退出，不是错误
            sys.__excepthook__(exc_type, exc_value, exc_traceback)
            return
            
        logger.error("未捕获的异常", exc_info=(exc_type, exc_value, exc_traceback))
        # 显示错误消息框
        try:
            error_msg = f"程序发生未处理的错误:\n{exc_type.__name__}: {exc_value}\n\n详细信息已记录到日志文件。"
            ctypes.windll.user32.MessageBoxW(0, error_msg, "堡垒机客户端错误", 0x10)
        except:
            pass
    
    sys.excepthook = handle_exception

# 设置日志系统
setup_logging()

# 获取应用程序运行时路径
def get_app_path():
    """获取应用程序运行时路径"""
    if getattr(sys, 'frozen', False):
        # PyInstaller 打包后的路径
        return os.path.dirname(sys.executable)
    else:
        # 开发环境下的路径
        return os.path.dirname(os.path.abspath(__file__))

# 定义资源路径
APP_PATH = get_app_path()
XSHELL_PATH = os.path.join(APP_PATH, 'resources', 'xshell')
XFTP_PATH = os.path.join(APP_PATH, 'resources', 'xftp')
TEMP_DIR = os.path.join(os.getenv('TEMP'), 'fortress_client')

# 确保临时目录存在
os.makedirs(TEMP_DIR, exist_ok=True)

# 如果是打包的应用程序，提取资源文件
def extract_resources():
    """从打包的应用程序中提取资源文件"""
    try:
        if getattr(sys, 'frozen', False):
            # 如果是打包环境，需要从 _MEIPASS 中获取资源
            logging.info("正在从打包应用提取资源...")
            
            # 记录关键路径信息
            logging.info(f"当前 APP_PATH: {APP_PATH}")
            logging.info(f"当前 XSHELL_PATH: {XSHELL_PATH}")
            logging.info(f"当前 XFTP_PATH: {XFTP_PATH}")
            if hasattr(sys, '_MEIPASS'):
                logging.info(f"_MEIPASS 路径: {sys._MEIPASS}")
                meipass_resources = os.path.join(sys._MEIPASS, 'resources')
                if os.path.exists(meipass_resources):
                    logging.info(f"_MEIPASS resources 目录存在: {os.listdir(meipass_resources)}")
                else:
                    logging.warning(f"_MEIPASS resources 目录不存在: {meipass_resources}")
            else:
                logging.warning("sys._MEIPASS 不存在，可能不是 PyInstaller 打包的应用")
            
            # 确保资源目录存在
            os.makedirs(XSHELL_PATH, exist_ok=True)
            os.makedirs(XFTP_PATH, exist_ok=True)
            
            # 提取 Xshell 资源
            source_xshell = None
            if hasattr(sys, '_MEIPASS'):
                source_xshell = os.path.join(sys._MEIPASS, 'resources', 'xshell')
                
            if source_xshell and os.path.exists(source_xshell):
                logging.info(f"提取 Xshell 资源从 {source_xshell} 到 {XSHELL_PATH}")
                logging.info(f"源目录内容: {os.listdir(source_xshell)}")
                
                # 直接复制整个目录
                for item in os.listdir(source_xshell):
                    s_item = os.path.join(source_xshell, item)
                    d_item = os.path.join(XSHELL_PATH, item)
                    
                    if os.path.isdir(s_item):
                        if not os.path.exists(d_item):
                            logging.info(f"复制目录: {s_item} -> {d_item}")
                            shutil.copytree(s_item, d_item)
                    else:
                        logging.info(f"复制文件: {s_item} -> {d_item}")
                        shutil.copy2(s_item, d_item)
                
                # 验证复制结果
                if os.path.exists(XSHELL_PATH):
                    logging.info(f"提取后的 XSHELL_PATH 内容: {os.listdir(XSHELL_PATH)}")
                    
                    # 递归列出所有文件
                    for root, dirs, files in os.walk(XSHELL_PATH):
                        rel_path = os.path.relpath(root, XSHELL_PATH)
                        if rel_path == '.':
                            rel_path = ''
                        else:
                            rel_path = rel_path + '/'
                        logging.info(f"目录: {rel_path}")
                        for file in files:
                            logging.info(f"  - 文件: {rel_path}{file}")
            else:
                logging.warning(f"打包中未找到 Xshell 资源或路径不存在")
                if hasattr(sys, '_MEIPASS'):
                    logging.info(f"_MEIPASS 目录内容: {os.listdir(sys._MEIPASS)}")
                    if os.path.exists(os.path.join(sys._MEIPASS, 'resources')):
                        logging.info(f"_MEIPASS resources 目录内容: {os.listdir(os.path.join(sys._MEIPASS, 'resources'))}")

            # 提取 Xftp 资源
            source_xftp = None
            if hasattr(sys, '_MEIPASS'):
                source_xftp = os.path.join(sys._MEIPASS, 'resources', 'xftp')
                
            if source_xftp and os.path.exists(source_xftp):
                logging.info(f"提取 Xftp 资源从 {source_xftp} 到 {XFTP_PATH}")
                logging.info(f"源目录内容: {os.listdir(source_xftp)}")
                
                # 直接复制整个目录
                for item in os.listdir(source_xftp):
                    s_item = os.path.join(source_xftp, item)
                    d_item = os.path.join(XFTP_PATH, item)
                    
                    if os.path.isdir(s_item):
                        if not os.path.exists(d_item):
                            logging.info(f"复制目录: {s_item} -> {d_item}")
                            shutil.copytree(s_item, d_item)
                    else:
                        logging.info(f"复制文件: {s_item} -> {d_item}")
                        shutil.copy2(s_item, d_item)
                
                # 验证复制结果
                if os.path.exists(XFTP_PATH):
                    logging.info(f"提取后的 XFTP_PATH 内容: {os.listdir(XFTP_PATH)}")
                    
                    # 递归列出所有文件
                    for root, dirs, files in os.walk(XFTP_PATH):
                        rel_path = os.path.relpath(root, XFTP_PATH)
                        if rel_path == '.':
                            rel_path = ''
                        else:
                            rel_path = rel_path + '/'
                        logging.info(f"目录: {rel_path}")
                        for file in files:
                            logging.info(f"  - 文件: {rel_path}{file}")
            else:
                logging.warning(f"打包中未找到 Xftp 资源或路径不存在")
                if hasattr(sys, '_MEIPASS'):
                    logging.info(f"_MEIPASS 目录内容: {os.listdir(sys._MEIPASS)}")
                    if os.path.exists(os.path.join(sys._MEIPASS, 'resources')):
                        logging.info(f"_MEIPASS resources 目录内容: {os.listdir(os.path.join(sys._MEIPASS, 'resources'))}")
                        
            # 尝试在其他位置查找
            logging.info("尝试在其他位置查找可能的资源...")
            if hasattr(sys, '_MEIPASS'):
                for root, dirs, files in os.walk(sys._MEIPASS):
                    for file in files:
                        if 'xshell.exe' in file.lower() or 'xftp.exe' in file.lower():
                            logging.info(f"找到可能的可执行文件: {os.path.join(root, file)}")
            
            # 检查当前 APP_PATH 是否包含资源
            if os.path.exists(os.path.join(APP_PATH, 'resources')):
                logging.info(f"APP_PATH resources 目录内容: {os.listdir(os.path.join(APP_PATH, 'resources'))}")
            
            logging.info("资源提取完成")
        else:
            logging.info("非打包环境，无需提取资源")
    except Exception as e:
        logging.error(f"提取资源时出错: {e}")
        import traceback
        logging.error(traceback.format_exc())

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
        
        # 提取并初始化Xshell和Xftp
        extract_resources()
        
        self.xshell_path = self._init_xshell()
        self.xftp_path = self._init_xftp()
        logging.info(f"客户端启动，服务器地址: {self.server_url}, 本地端口: {self.local_port}")
        logging.info(f"Xshell 路径: {self.xshell_path}")
        logging.info(f"Xftp 路径: {self.xftp_path}")

    def _init_xshell(self):
        """初始化 Xshell 路径和资源"""
        try:
            # 检查内置 Xshell 是否存在
            if os.path.exists(XSHELL_PATH):
                logging.info(f"XSHELL_PATH 存在: {XSHELL_PATH}")
                # 记录目录内容
                logging.info(f"目录内容: {os.listdir(XSHELL_PATH)}")
                
                # 查找 Xshell.exe (递归查找)
                xshell_exe = None
                for root, dirs, files in os.walk(XSHELL_PATH):
                    for file in files:
                        if file.lower() == 'xshell.exe':
                            xshell_exe = os.path.join(root, file)
                            logging.info(f"找到 Xshell.exe: {xshell_exe}")
                            return xshell_exe
                
                if not xshell_exe:
                    logging.warning("内置 Xshell.exe 未找到，尝试在子目录中查找")
                    # 检查一级子目录
                    for item in os.listdir(XSHELL_PATH):
                        item_path = os.path.join(XSHELL_PATH, item)
                        if os.path.isdir(item_path):
                            logging.info(f"检查子目录: {item_path}")
                            for subitem in os.listdir(item_path):
                                logging.info(f"  - 子目录内容: {subitem}")
                                if subitem.lower() == 'xshell.exe':
                                    xshell_exe = os.path.join(item_path, subitem)
                                    logging.info(f"在子目录中找到 Xshell.exe: {xshell_exe}")
                                    return xshell_exe
                
                logging.warning("内置 Xshell.exe 未找到，尝试直接在资源目录内查找")
                xshell_candidates = []
                for root, dirs, files in os.walk(XSHELL_PATH):
                    for file in files:
                        if file.lower().endswith('.exe'):
                            xshell_candidates.append(os.path.join(root, file))
                            logging.info(f"找到可能的执行文件: {os.path.join(root, file)}")
                
                if xshell_candidates:
                    # 优先选择名称包含 xshell 的
                    for exe in xshell_candidates:
                        if 'xshell' in os.path.basename(exe).lower():
                            logging.info(f"选择的 Xshell 执行文件: {exe}")
                            return exe
                    # 没有找到包含 xshell 的，返回第一个
                    logging.info(f"未找到 Xshell 相关执行文件，使用第一个: {xshell_candidates[0]}")
                    return xshell_candidates[0]
                
                logging.warning("内置 Xshell.exe 未找到，使用默认路径")
            else:
                logging.warning(f"内置 Xshell 目录不存在: {XSHELL_PATH}")
                logging.info(f"APP_PATH: {APP_PATH}")
                logging.info(f"查看 resources 目录是否存在: {os.path.exists(os.path.join(APP_PATH, 'resources'))}")
                if os.path.exists(os.path.join(APP_PATH, 'resources')):
                    logging.info(f"resources 目录内容: {os.listdir(os.path.join(APP_PATH, 'resources'))}")
            
            # 回退到默认路径
            default_path = r'D:\xshell\Xshell\Xshell.exe'
            logging.info(f"使用默认 Xshell 路径: {default_path}")
            return default_path
        except Exception as e:
            logging.error(f"初始化 Xshell 失败: {e}")
            return r'D:\xshell\Xshell\Xshell.exe'
    
    def _init_xftp(self):
        """初始化 Xftp 路径和资源"""
        try:
            # 检查内置 Xftp 是否存在
            if os.path.exists(XFTP_PATH):
                logging.info(f"XFTP_PATH 存在: {XFTP_PATH}")
                # 记录目录内容
                logging.info(f"目录内容: {os.listdir(XFTP_PATH)}")
                
                # 查找 Xftp.exe (递归查找)
                xftp_exe = None
                for root, dirs, files in os.walk(XFTP_PATH):
                    for file in files:
                        if file.lower() == 'xftp.exe':
                            xftp_exe = os.path.join(root, file)
                            logging.info(f"找到 Xftp.exe: {xftp_exe}")
                            return xftp_exe
                
                if not xftp_exe:
                    logging.warning("内置 Xftp.exe 未找到，尝试在子目录中查找")
                    # 检查一级子目录
                    for item in os.listdir(XFTP_PATH):
                        item_path = os.path.join(XFTP_PATH, item)
                        if os.path.isdir(item_path):
                            logging.info(f"检查子目录: {item_path}")
                            for subitem in os.listdir(item_path):
                                logging.info(f"  - 子目录内容: {subitem}")
                                if subitem.lower() == 'xftp.exe':
                                    xftp_exe = os.path.join(item_path, subitem)
                                    logging.info(f"在子目录中找到 Xftp.exe: {xftp_exe}")
                                    return xftp_exe
                
                logging.warning("内置 Xftp.exe 未找到，尝试直接在资源目录内查找")
                xftp_candidates = []
                for root, dirs, files in os.walk(XFTP_PATH):
                    for file in files:
                        if file.lower().endswith('.exe'):
                            xftp_candidates.append(os.path.join(root, file))
                            logging.info(f"找到可能的执行文件: {os.path.join(root, file)}")
                
                if xftp_candidates:
                    # 优先选择名称包含 xftp 的
                    for exe in xftp_candidates:
                        if 'xftp' in os.path.basename(exe).lower():
                            logging.info(f"选择的 Xftp 执行文件: {exe}")
                            return exe
                    # 没有找到包含 xftp 的，返回第一个
                    logging.info(f"未找到 Xftp 相关执行文件，使用第一个: {xftp_candidates[0]}")
                    return xftp_candidates[0]
                
                logging.warning("内置 Xftp.exe 未找到，使用默认路径")
            else:
                logging.warning(f"内置 Xftp 目录不存在: {XFTP_PATH}")
                logging.info(f"APP_PATH: {APP_PATH}")
                logging.info(f"查看 resources 目录是否存在: {os.path.exists(os.path.join(APP_PATH, 'resources'))}")
                if os.path.exists(os.path.join(APP_PATH, 'resources')):
                    logging.info(f"resources 目录内容: {os.listdir(os.path.join(APP_PATH, 'resources'))}")
            
            # 回退到默认路径
            default_path = r'D:\xshell\Xftp\Xftp.exe'
            logging.info(f"使用默认 Xftp 路径: {default_path}")
            return default_path
        except Exception as e:
            logging.error(f"初始化 Xftp 失败: {e}")
            return r'D:\xshell\Xftp\Xftp.exe'

    def _run_xftp_green_script(self):
        """运行Xftp绿化处理脚本"""
        try:
            green_script_path = os.path.join(XFTP_PATH, '!)绿化处理.bat')
            if os.path.exists(green_script_path):
                logging.info(f"开始运行Xftp绿化处理脚本: {green_script_path}")
                
                # 检查是否具有管理员权限
                if not is_admin():
                    logging.warning("当前进程没有管理员权限，尝试以管理员身份运行绿化脚本")
                    # 尝试以管理员身份运行脚本
                    try:
                        # 使用ShellExecute以管理员身份运行
                        result = ctypes.windll.shell32.ShellExecuteW(
                            None, 
                            "runas", 
                            "cmd.exe", 
                            f"/c cd /d \"{XFTP_PATH}\" && \"!)绿化处理.bat\"", 
                            None, 
                            1  # SW_SHOWNORMAL
                        )
                        
                        if result > 32:  # 如果返回值大于32，表示成功启动
                            logging.info("成功以管理员身份启动绿化脚本")
                            # 稍微等待一下批处理执行
                            time.sleep(5)
                            return True
                        else:
                            logging.error(f"以管理员身份启动绿化脚本失败，返回值: {result}")
                            return False
                    except Exception as e:
                        logging.error(f"以管理员身份启动绿化脚本时出错: {e}")
                        return False
                
                # 如果已经有管理员权限，直接运行
                try:
                    # 使用subprocess运行批处理文件，使用当前目录作为工作目录
                    process = subprocess.Popen(
                        green_script_path,
                        shell=True,
                        cwd=XFTP_PATH,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        creationflags=CREATE_NO_WINDOW  # 不显示命令窗口
                    )
                    
                    # 等待进程完成
                    stdout, stderr = process.communicate(timeout=30)  # 30秒超时
                    
                    if process.returncode == 0:
                        logging.info("Xftp绿化处理脚本运行成功")
                    else:
                        logging.warning(f"Xftp绿化处理脚本运行异常，返回码: {process.returncode}")
                        if stdout:
                            logging.debug(f"脚本输出: {stdout.decode('gbk', errors='ignore')}")
                        if stderr:
                            logging.warning(f"脚本错误: {stderr.decode('gbk', errors='ignore')}")
                    
                    return True
                except subprocess.TimeoutExpired:
                    logging.warning("绿化脚本执行超时，可能仍在后台运行")
                    return True
                except Exception as e:
                    logging.error(f"运行绿化处理脚本失败: {e}")
                    return False
            else:
                logging.warning(f"绿化处理脚本不存在: {green_script_path}")
                return False
        except Exception as e:
            logging.error(f"运行绿化处理脚本失败: {e}")
            return False

    def start(self):
        """启动客户端"""
        try:
            # 检查是否已运行
            if not self._check_single_instance():
                raise Exception("客户端已在运行")
                
            # 运行Xftp绿化处理脚本
            self._run_xftp_green_script()

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
            # 获取本地IP
            local_ip = self._get_local_ip()
            if not local_ip:
                self.state['last_error'] = "无法获取本地IP地址"
                self.state['server_connected'] = False
                return False
            
            self.state['local_ip'] = local_ip
            
            # 获取计算机名
            hostname = socket.gethostname()
            
            # 获取操作系统版本
            os_version = platform.platform()
            
            # 获取MAC地址
            mac_address = ':'.join(['{:02x}'.format((uuid.getnode() >> elements) & 0xff) 
                                    for elements in range(0, 8*6, 8)][::-1])
            
            # 尝试向服务器验证客户端
            try:
                response = requests.post(
                    f"{self.server_url}/api/client/verify",
                    json={
                        'client_ip': local_ip,
                        'client_port': self.local_port,
                        'version': self.state['version'],
                        'hostname': hostname,
                        'os_version': os_version,
                        'mac_address': mac_address
                    },
                    timeout=5
                )
                
                if response.ok:
                    self.state['server_connected'] = True
                    self.state['last_error'] = None
                    return True
                else:
                    self.state['server_connected'] = False
                    self.state['last_error'] = f"服务器拒绝连接: {response.text}"
                    return False
                
            except requests.exceptions.RequestException as e:
                self.state['server_connected'] = False
                self.state['last_error'] = f"无法连接到服务器: {e}"
                return False
            
        except Exception as e:
            self.state['server_connected'] = False
            self.state['last_error'] = f"检查服务器连接时出错: {e}"
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
            logging.info(f"准备启动SSH连接: {host}:{port}, 用户名: {username}")
            
            # 确保 Xshell 可执行文件存在
            if not os.path.exists(self.xshell_path):
                logging.error(f"Xshell 可执行文件不存在: {self.xshell_path}")
                # 重新尝试查找 Xshell
                self.xshell_path = self._init_xshell()
                if not os.path.exists(self.xshell_path):
                    raise Exception(f"无法找到 Xshell 可执行文件")
            
            # 构建连接URL (不包含密码的日志版本)
            logging.info(f"准备启动SSH连接: {host}:{port}, 用户名: {username}")
            
            # 构建实际URL (包含凭据)
            url = f"ssh://{username}:{password}@{host}:{port}/"
            
            # 尝试多种启动方式
            try_methods = [
                # 方式1: 直接使用URL作为参数
                {"cmd": f'"{self.xshell_path}" {url}', "desc": "URL参数方式"},
                # 方式2: 使用 -url 参数 (某些版本支持)
                #{"cmd": f'"{self.xshell_path}" -url {url}', "desc": "-url参数方式"},
                # 方式3: 使用Xshell专用参数 (最可靠的方式)
                #{"cmd": f'"{self.xshell_path}" -newtab -protocol ssh -host {host} -port {port} -username {username} -password {password}', "desc": "Xshell专用参数方式"},
                # 方式4: 使用Windows URL协议处理机制
                #{"cmd": f'start {url}', "desc": "Windows URL协议方式"}
            ]
            
            success = False
            last_error = None
            
            for method in try_methods:
                try:
                    logging.info(f"尝试使用{method['desc']}启动Xshell")
                    process = subprocess.Popen(method["cmd"], shell=True)
                    logging.info(f"使用{method['desc']}启动Xshell，进程ID: {process.pid}")
                    
                    # 等待一小段时间，检查进程是否还存在
                    time.sleep(1)
                    process.poll()
                    if process.returncode is not None:
                        logging.warning(f"进程已退出，返回码: {process.returncode}")
                    else:
                        logging.info("进程仍在运行，启动成功")
                        success = True
                        break
                except Exception as e:
                    logging.warning(f"{method['desc']}启动失败: {e}")
                    last_error = e
            
            if not success:
                # 如果所有方式都失败，尝试创建会话文件方式
                try:
                    session_file = os.path.join(TEMP_DIR, f"ssh_session_{host}_{port}.xsh")
                    logging.info(f"尝试使用会话文件方式: {session_file}")
                    
                    with open(session_file, 'w', encoding='utf-8') as f:
                        f.write(f"[SESSION]\n")
                        f.write(f"Protocol=SSH\n")
                        f.write(f"Host={host}\n")
                        f.write(f"Port={port}\n")
                        f.write(f"UserName={username}\n")
                        f.write(f"Password={base64.b64encode(password.encode()).decode()}\n")
                        f.write(f"PasswordType=Base64\n")
                        f.write(f"PasswordSave=1\n")
                    
                    cmd = f'"{self.xshell_path}" "{session_file}"'
                    process = subprocess.Popen(cmd, shell=True)
                    time.sleep(1)
                    
                    # 删除临时会话文件
                    try:
                        os.remove(session_file)
                    except:
                        pass
                    
                    success = True
                except Exception as e:
                    logging.error(f"会话文件方式启动失败: {e}")
                    last_error = e
            
            if not success:
                raise Exception(f"所有启动方式均失败，最后错误: {last_error}")
            
            return True
        except Exception as e:
            logging.error(f"启动SSH连接失败: {e}")
            # 显示错误消息框
            try:
                ctypes.windll.user32.MessageBoxW(0, f"启动SSH连接失败: {e}", "连接错误", 0x10)
            except:
                pass
            return False

    def launch_sftp(self, host, username, password, port=22):
        """使用Xftp URL Scheme启动SFTP连接"""
        try:
            logging.info(f"准备启动SFTP连接: {host}:{port}, 用户名: {username}")
            
            # 确保 Xftp 可执行文件存在
            if not os.path.exists(self.xftp_path):
                logging.error(f"Xftp 可执行文件不存在: {self.xftp_path}")
                # 重新尝试查找 Xftp
                self.xftp_path = self._init_xftp()
                if not os.path.exists(self.xftp_path):
                    raise Exception(f"无法找到 Xftp 可执行文件")
            
            # 构建连接URL (不包含密码的日志版本)
            logging.info(f"准备启动SFTP连接: {host}:{port}, 用户名: {username}")
            
            # 构建实际URL (包含凭据)
            url = f"sftp://{username}:{password}@{host}:{port}/"
            
            # 尝试多种启动方式
            try_methods = [
                # 方式1: 直接使用URL作为参数
                {"cmd": f'"{self.xftp_path}" {url}', "desc": "URL参数方式"},
                # 方式2: 使用 -url 参数 (某些版本支持)
                {"cmd": f'"{self.xftp_path}" -url {url}', "desc": "-url参数方式"},
                # 方式3: 使用Xftp专用参数 (最可靠的方式)
                {"cmd": f'"{self.xftp_path}" -newtab -protocol sftp -host {host} -port {port} -username {username} -password {password}', "desc": "Xftp专用参数方式"},
                # 方式4: 使用Windows URL协议处理机制
                {"cmd": f'start {url}', "desc": "Windows URL协议方式"}
            ]
            
            success = False
            last_error = None
            
            for method in try_methods:
                try:
                    logging.info(f"尝试使用{method['desc']}启动Xftp")
                    process = subprocess.Popen(method["cmd"], shell=True)
                    logging.info(f"使用{method['desc']}启动Xftp，进程ID: {process.pid}")
                    
                    # 等待一小段时间，检查进程是否还存在
                    time.sleep(1)
                    process.poll()
                    if process.returncode is not None:
                        logging.warning(f"进程已退出，返回码: {process.returncode}")
                    else:
                        logging.info("进程仍在运行，启动成功")
                        success = True
                        break
                except Exception as e:
                    logging.warning(f"{method['desc']}启动失败: {e}")
                    last_error = e
            
            if not success:
                # 如果所有方式都失败，尝试创建会话文件方式
                try:
                    session_file = os.path.join(TEMP_DIR, f"sftp_session_{host}_{port}.xfp")
                    logging.info(f"尝试使用会话文件方式: {session_file}")
                    
                    with open(session_file, 'w', encoding='utf-8') as f:
                        f.write(f"[SESSION]\n")
                        f.write(f"Protocol=SFTP\n")
                        f.write(f"Host={host}\n")
                        f.write(f"Port={port}\n")
                        f.write(f"UserName={username}\n")
                        f.write(f"Password={base64.b64encode(password.encode()).decode()}\n")
                        f.write(f"PasswordType=Base64\n")
                        f.write(f"PasswordSave=1\n")
                    
                    cmd = f'"{self.xftp_path}" "{session_file}"'
                    process = subprocess.Popen(cmd, shell=True)
                    time.sleep(1)
                    
                    # 删除临时会话文件
                    try:
                        os.remove(session_file)
                    except:
                        pass
                    
                    success = True
                except Exception as e:
                    logging.error(f"会话文件方式启动失败: {e}")
                    last_error = e
            
            if not success:
                raise Exception(f"所有启动方式均失败，最后错误: {last_error}")
            
            return True
        except Exception as e:
            logging.error(f"启动SFTP连接失败: {e}")
            # 显示错误消息框
            try:
                ctypes.windll.user32.MessageBoxW(0, f"启动SFTP连接失败: {e}", "连接错误", 0x10)
            except:
                pass
            return False

class RequestHandler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        """处理OPTIONS预检请求，支持CORS跨域访问"""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Accept')
        self.send_header('Access-Control-Max-Age', '86400')  # 24小时内不再发送预检请求
        self.end_headers()
        self.wfile.write(b'')
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
        try:
            # 添加CORS头，允许跨域请求
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)
            
            if self.path == '/rdp_connect':
                self._handle_rdp_connect(data)
            elif self.path == '/ssh_connect':
                self._handle_ssh_connect(data)
            elif self.path == '/sftp_connect':
                self._handle_sftp_connect(data)
            else:
                self._send_error(404, "Not Found")
        except Exception as e:
            logging.error(f"处理POST请求失败: {e}")
            self._send_error(500, str(e))

    def _handle_status(self):
        """处理状态请求"""
        client = self.server.client
        self._send_json_response(client.state)

    def _handle_rdp_connect(self, data):
        """处理RDP连接请求"""
        try:

            host = data.get('host')
            username = data.get('username')
            password = data.get('password')
            credential_id = data.get('credential_id', host)  # 获取 credential_id

            # 调起 mstsc.exe
            success = self.server.client.launch_rdp(host, username, password, credential_id)

            self._send_json_response({'success': success})
        except Exception as e:
            logging.error(f"处理RDP连接请求失败: {e}")
            self._send_error(500, str(e))

    def _handle_ssh_connect(self, data):
        """处理SSH连接请求"""
        try:


            host = data.get('host')
            username = data.get('username')
            password = data.get('password')
            port = data.get('port', 22)  # 默认SSH端口22

            # 调起内置的 Xshell
            success = self.server.client.launch_ssh(host, username, password, port)

            self._send_json_response({'success': success})
        except Exception as e:
            logging.error(f"处理SSH连接请求失败: {e}")
            self._send_error(500, str(e))

    def _handle_sftp_connect(self, data):
        """处理SFTP连接请求"""
        try:


            host = data.get('host')
            username = data.get('username')
            password = data.get('password')
            port = data.get('port', 22)  # 默认SFTP端口22

            # 调起内置的 Xftp
            success = self.server.client.launch_sftp(host, username, password, port)

            self._send_json_response({'success': success})
        except Exception as e:
            logging.error(f"处理SFTP连接请求失败: {e}")
            self._send_error(500, str(e))

    def _send_json_response(self, data, code=200):
        """发送JSON响应"""
        try:
            self.send_response(code)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            self.send_header('Access-Control-Allow-Headers', 'Content-Type, Accept')
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            logging.info(f"发送响应: {data}")  # 添加日志
            response = json.dumps(data).encode()
            self.wfile.write(response)
        except Exception as e:
            logging.error(f"发送响应失败: {e}")

    def _send_error(self, code, message):
        """发送错误响应"""
        try:
            self.send_response(code)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_data = {'error': message}
            self.wfile.write(json.dumps(error_data).encode())
        except Exception as e:
            logging.error(f"发送错误响应失败: {e}")

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

def prepare_resources():
    """准备资源，创建必要的目录结构"""
    try:
        # 创建资源目录
        os.makedirs(os.path.join(APP_PATH, 'resources', 'xshell'), exist_ok=True)
        os.makedirs(os.path.join(APP_PATH, 'resources', 'xftp'), exist_ok=True)
        
        logging.info("资源目录创建成功")
    except Exception as e:
        logging.error(f"创建资源目录失败: {e}")

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
            logging.info("需要管理员权限，正在重新启动...")
            ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
            sys.exit(0)

        # 准备资源
        prepare_resources()
            
        # 检查防火墙
        check_firewall()
        
        # 检查是否已经运行
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('127.0.0.1', 45654))
        if result == 0:
            logging.warning("堡垒机客户端已经在运行中")
            ctypes.windll.user32.MessageBoxW(0, "堡垒机客户端已经在运行中", "提示", 0x40)
            sys.exit(1)
        
        sock.close()
        
        # 创建客户端实例
        client = FortressClient('10.16.30.133', 8080)
        
        # 启动客户端
        if not client.start():
            error_msg = client.state.get('last_error', "未知错误")
            logging.error(f"客户端启动失败: {error_msg}")
            ctypes.windll.user32.MessageBoxW(0, f"客户端启动失败: {error_msg}", "错误", 0x10)
            sys.exit(1)
            
    except Exception as e:
        # 记录详细的错误堆栈
        error_details = traceback.format_exc()
        logging.error(f"程序启动失败: {e}\n{error_details}")
        
        # 显示错误对话框
        try:
            error_msg = f"程序启动失败: {e}\n\n请查看日志文件获取详细信息。"
            ctypes.windll.user32.MessageBoxW(0, error_msg, "错误", 0x10)
        except:
            pass
        
        sys.exit(1)

if __name__ == '__main__':
    main()