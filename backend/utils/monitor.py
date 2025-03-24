import socket
import threading
import time
from datetime import datetime
from backend.extensions import db
from backend.models import Server
from flask import current_app

def check_port(host, port, timeout=3):
    """检查指定主机的端口是否可访问"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        return result == 0
    except:
        return False

class ServerMonitor:
    def __init__(self, app):
        self.app = app
        self.thread = None
        self.running = False

    def monitor_server_status(self):
        """监控服务器状态的后台线程"""
        while self.running:
            try:
                with self.app.app_context():
                    # 使用 Server.query.all() 获取完整的 Server 对象
                    servers = Server.query.all()
                    for server in servers:
                        # 只检查通过堡垒机登录的用户连接
                        if server.in_use_by:
                            port = 3389 if server.type == 'Windows' else 22
                            is_alive = check_port(server.ip, port)
                            
                            if not is_alive:
                                # 如果端口不可访问，说明连接已断开
                                server.in_use_by = None
                                server.last_active = None
                                db.session.commit()
                            elif server.last_active and (datetime.now() - server.last_active).total_seconds() > 900:  # 15分钟
                                # 如果超过15分钟没有心跳，释放服务器
                                server.in_use_by = None
                                server.last_active = None
                                db.session.commit()
                
            except Exception as e:
                print(f"Monitor error: {e}")
                
            time.sleep(5)  # 每5秒检查一次

    def start(self):
        """启动监控线程"""
        if not self.thread:
            self.running = True
            self.thread = threading.Thread(target=self.monitor_server_status, daemon=True)
            self.thread.start()

    def stop(self):
        """停止监控线程"""
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
            self.thread = None 