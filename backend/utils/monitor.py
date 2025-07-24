import socket
import threading
import time
import logging
from datetime import datetime, timedelta
from backend.extensions import db
from backend.models import Server
from backend.models.userlog import UserLog
from backend.models.user import User
from backend.models.client import Client
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
    """服务器监控器，用于监控服务器状态和清理过期连接"""
    
    def __init__(self, app, check_interval=300):  # 改为5分钟检查一次
        self.app = app
        self.check_interval = check_interval  # 检查间隔（秒）
        self.running = True
        self.thread = None
        
    def start(self):
        """启动监控线程"""
        self.thread = threading.Thread(target=self._monitor_loop, daemon=True)
        self.thread.start()
        logging.info("服务器监控器已启动")
        
    def stop(self):
        """停止监控线程"""
        self.running = False
        if self.thread:
            self.thread.join()
        logging.info("服务器监控器已停止")
        
    def _monitor_loop(self):
        """监控循环"""
        while self.running:
            try:
                with self.app.app_context():
                    self._check_server_status()
                    self._cleanup_expired_clients()
            except Exception as e:
                logging.error(f"监控过程中发生错误: {e}")
            
            # 等待下一次检查
            time.sleep(self.check_interval)
            
    def _check_server_status(self):
        """检查服务器状态，清理长时间无活动的服务器占用标记"""
        try:
            # 查找所有被标记为使用中但超过30分钟无活动的服务器
            timeout = datetime.now() - timedelta(minutes=30)
            expired_servers = Server.query.filter(
                Server.in_use_by.isnot(None),
                Server.last_active < timeout
            ).all()
            
            # 清除这些服务器的占用标记
            for server in expired_servers:
                logging.info(f"清理长时间无活动的服务器占用: {server.name} (ID: {server.id})")
                server.in_use_by = None
                
            # 提交更改
            if expired_servers:
                db.session.commit()
                logging.info(f"已清理 {len(expired_servers)} 个过期的服务器占用")
        except Exception as e:
            logging.error(f"检查服务器状态时出错: {e}")
            db.session.rollback()

    def _cleanup_expired_clients(self):
        """清理过期的客户端连接"""
        try:
            # 清理内存中的过期客户端连接
            if hasattr(self.app, 'connected_clients'):
                # 获取当前时间
                now = datetime.now()
                expired_clients = []
                
                # 检查每个客户端的最后活跃时间
                for client_ip, client_info in list(self.app.connected_clients.items()):
                    # 如果客户端信息中没有last_seen字段，或者last_seen超过30分钟，则认为过期
                    if 'last_seen' not in client_info:
                        expired_clients.append(client_ip)
                        continue
                        
                    try:
                        # 解析last_seen时间
                        last_seen_str = client_info['last_seen']
                        if not last_seen_str:
                            expired_clients.append(client_ip)
                            continue
                            
                        # 将ISO格式的时间字符串转换为datetime对象
                        last_seen = datetime.fromisoformat(last_seen_str)
                        
                        # 如果超过30分钟未活动，则认为过期
                        if last_seen < now - timedelta(minutes=30):
                            expired_clients.append(client_ip)
                    except (ValueError, TypeError):
                        # 如果解析失败，也认为过期
                        expired_clients.append(client_ip)
                
                # 删除过期的客户端连接
                for client_ip in expired_clients:
                    del self.app.connected_clients[client_ip]
                    
                if expired_clients:
                    logging.info(f"已清理 {len(expired_clients)} 个过期的客户端连接")
                    
            # 清理数据库中的过期客户端记录（超过24小时未活动的）
            expired_time = datetime.now() - timedelta(hours=24)
            expired_db_clients = Client.query.filter(Client.last_seen < expired_time).all()
            
            if expired_db_clients:
                for client in expired_db_clients:
                    db.session.delete(client)
                    
                db.session.commit()
                logging.info(f"已从数据库中清理 {len(expired_db_clients)} 个过期的客户端记录")
                
        except Exception as e:
            logging.error(f"清理过期客户端连接时出错: {e}")
            db.session.rollback() 