import socket
import threading
import select
from datetime import datetime
import logging
import struct

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class RDPProxy:
    def __init__(self):
        self.active_connections = {}
        self.proxy_port = 3389  # 使用标准RDP端口
        self.server_socket = None
        self.proxy_host = '0.0.0.0'
        self.local_ip = self._get_host_ip()
        
    def _get_host_ip(self):
        """获取堡垒机的实际IP地址"""
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(('8.8.8.8', 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except:
            return socket.gethostbyname(socket.gethostname())

    def start(self):
        """启动代理服务器"""
        try:
            self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server_socket.bind((self.proxy_host, self.proxy_port))
            self.server_socket.listen(5)
            logger.info(f"RDP proxy started on {self.local_ip}:{self.proxy_port}")
            
            accept_thread = threading.Thread(target=self._accept_connections)
            accept_thread.daemon = True
            accept_thread.start()
        except Exception as e:
            logger.error(f"Failed to start proxy: {e}")
            raise

    def create_proxy(self, target_host, target_port=3389):
        """创建新的代理连接"""
        try:
            connection_id = f"{target_host}:{target_port}"
            
            # 检查目标服务器是否可达
            test_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            test_socket.settimeout(5)
            test_socket.connect((target_host, target_port))
            test_socket.close()
            
            self.active_connections[connection_id] = {
                'target_host': target_host,
                'target_port': target_port,
                'created_at': datetime.now(),
                'last_activity': datetime.now(),
                'is_active': True,
                'client_info': None,
                'server_info': None
            }
            
            return {
                'proxy_host': self.local_ip,
                'proxy_port': self.proxy_port,
                'connection_id': connection_id
            }
        except Exception as e:
            logger.error(f"Failed to create proxy: {e}")
            raise

    def _handle_connection(self, client_socket, client_address):
        """处理单个连接"""
        server_socket = None
        connection_id = None
        
        try:
            # 等待接收RDP协议数据
            initial_data = client_socket.recv(1024)
            if not initial_data:
                return

            # 查找目标连接信息
            target_info = None
            for conn_id, conn_info in self.active_connections.items():
                if not conn_info['client_info']:
                    target_info = conn_info
                    connection_id = conn_id
                    break

            if not target_info:
                logger.error("No available connection found")
                return

            # 连接目标服务器
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.settimeout(30)
            server_socket.connect((target_info['target_host'], target_info['target_port']))
            
            # 更新连接信息
            self.active_connections[connection_id].update({
                'client_info': client_address,
                'server_info': server_socket.getpeername(),
                'last_activity': datetime.now()
            })

            # 转发初始RDP数据
            server_socket.sendall(initial_data)
            
            # 开始双向数据转发
            self._forward_data(client_socket, server_socket, connection_id)
            
        except Exception as e:
            logger.error(f"Connection handling error: {e}")
            if connection_id:
                self._close_connection(connection_id)
        finally:
            if server_socket:
                server_socket.close()
            client_socket.close()

    def _forward_data(self, client_socket, server_socket, connection_id):
        """转发数据并监控连接状态"""
        try:
            while True:
                readable, _, _ = select.select([client_socket, server_socket], [], [], 1.0)
                
                if client_socket in readable:
                    data = client_socket.recv(8192)
                    if not data:
                        break
                    server_socket.sendall(data)
                    self._update_connection_status(connection_id)
                    
                if server_socket in readable:
                    data = server_socket.recv(8192)
                    if not data:
                        break
                    client_socket.sendall(data)
                    self._update_connection_status(connection_id)
                    
        except Exception as e:
            logger.error(f"Data forwarding error: {e}")
        finally:
            self._close_connection(connection_id)

    def _accept_connections(self):
        """接受新的连接"""
        while True:
            try:
                client_socket, addr = self.server_socket.accept()
                thread = threading.Thread(
                    target=self._handle_connection,
                    args=(client_socket, addr)
                )
                thread.daemon = True
                thread.start()
            except Exception as e:
                logger.error(f"Error accepting connection: {e}")
                
    def _update_connection_status(self, connection_id):
        """更新连接状态"""
        if connection_id in self.active_connections:
            self.active_connections[connection_id]['last_activity'] = datetime.now()
            
    def _close_connection(self, connection_id):
        """关闭连接"""
        if connection_id in self.active_connections:
            self.active_connections[connection_id]['is_active'] = False
            
    def get_connection_status(self, connection_id):
        """获取连接状态"""
        if connection_id in self.active_connections:
            conn_info = self.active_connections[connection_id]
            return {
                'is_active': conn_info['is_active'],
                'last_activity': conn_info['last_activity'],
                'client_info': conn_info['client_info'],
                'server_info': conn_info['server_info']
            }
        return None
        
    def _get_available_port(self):
        """获取可用端口"""
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.bind(('', 0))
        port = sock.getsockname()[1]
        sock.close()
        return port 