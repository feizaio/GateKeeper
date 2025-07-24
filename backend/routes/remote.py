from flask import Blueprint, request, jsonify, current_app, g, session
import socket
import logging
import requests
import ipaddress
from sqlalchemy import text
import time
from backend.models.server import Server
from backend.models.user import User
from backend.models.userlog import UserLog  # 修改导入路径
from backend.extensions import db
from datetime import datetime, timedelta
import win32gui
import win32con
import win32process
import secrets
import subprocess
from backend.models.client import Client

remote_bp = Blueprint('remote', __name__)
rdp_processes = {}

# 添加重试机制的配置
MAX_RETRIES = 3  # 最大重试次数
RETRY_DELAY = 1  # 重试间隔（秒）

# 添加客户端查找辅助函数
def find_client(client_ip):
    """
    查找客户端信息，优先从内存中查找，如果找不到则从数据库中查找
    
    Args:
        client_ip: 客户端IP地址
    
    Returns:
        client_info: 客户端信息字典，如果找不到则返回None
    """
    # 从内存中查找
    if hasattr(current_app, 'connected_clients'):
        client_info = current_app.connected_clients.get(client_ip)
        if client_info:
            return client_info
    
    # 从数据库中查找
    client = Client.query.filter_by(ip=client_ip).first()
    if client:
        # 检查客户端是否最近活跃（30分钟内）
        if client.last_seen and client.last_seen > datetime.now() - timedelta(minutes=30):
            # 将客户端信息添加到内存中
            client_info = {
                'ip': client.ip,
                'port': client.port,
                'version': client.version,
                'hostname': client.hostname,
                'os_version': client.os_version,
                'mac_address': client.mac_address,
                'last_seen': client.last_seen.isoformat()
            }
            
            # 确保内存字典存在
            if not hasattr(current_app, 'connected_clients'):
                current_app.connected_clients = {}
                
            # 更新内存中的客户端信息
            current_app.connected_clients[client_ip] = client_info
            
            return client_info
    
    # 如果找不到客户端，则返回None
    return None

# 添加一个新函数，通过MAC地址查找客户端
def find_client_by_mac(mac_address):
    """
    通过MAC地址查找客户端信息
    
    Args:
        mac_address: 客户端MAC地址
    
    Returns:
        client_info: 客户端信息字典，如果找不到则返回None
        client_ip: 客户端IP地址，用于更新内存中的映射
    """
    if not mac_address:
        return None, None
        
    # 从内存中查找
    if hasattr(current_app, 'connected_clients'):
        for ip, info in current_app.connected_clients.items():
            if info.get('mac_address') == mac_address:
                return info, ip
    
    # 从数据库中查找
    client = Client.query.filter_by(mac_address=mac_address).first()
    if client:
        # 检查客户端是否最近活跃（30分钟内）
        if client.last_seen and client.last_seen > datetime.now() - timedelta(minutes=30):
            return {
                'ip': client.ip,
                'port': client.port,
                'version': client.version,
                'hostname': client.hostname,
                'os_version': client.os_version,
                'mac_address': client.mac_address,
                'last_seen': client.last_seen.isoformat()
            }, client.ip
    
    return None, None

def connect_to_client(client_info, endpoint, data, timeout=5):
    """
    连接到客户端，并发送数据，包含重试机制
    
    Args:
        client_info: 客户端信息字典
        endpoint: 客户端API端点
        data: 要发送的数据
        timeout: 连接超时时间（秒）
        
    Returns:
        response: 客户端响应
        
    Raises:
        requests.exceptions.RequestException: 连接失败
    """
    client_url = f"http://{client_info['ip']}:{client_info['port']}/{endpoint}"
    logging.info(f"准备发送连接信息到客户端: {client_url}")
    
    # 实现重试机制
    last_error = None
    for retry in range(MAX_RETRIES):
        try:
            if retry > 0:
                logging.info(f"第 {retry} 次重试连接客户端...")
            
            response = requests.post(
                client_url,
                json=data,
                timeout=timeout
            )
            
            return response
        except requests.exceptions.RequestException as e:
            last_error = e
            logging.warning(f"连接客户端失败 (尝试 {retry+1}/{MAX_RETRIES}): {e}")
            
            # 最后一次尝试失败，不需要等待
            if retry < MAX_RETRIES - 1:
                import time
                time.sleep(RETRY_DELAY)
    
    # 如果所有重试都失败，则抛出最后一个错误
    raise last_error

def monitor_rdp_window(server_id, user_id, app):
    """监控 RDP 窗口是否存在，如果窗口关闭则更新服务器状态"""
    time.sleep(2)  # 等待 mstsc 窗口创建
    
    # 要搜索的服务器IP
    server_ip = None
    with app.app_context():
        server = Server.query.get(server_id)
        if server:
            server_ip = server.ip
    
    def find_rdp_window():
        """查找 RDP 窗口"""
        result = {'found': False}
        
        def callback(hwnd, _):
            if win32gui.IsWindowVisible(hwnd):
                try:
                    # 获取窗口标题和类名
                    title = win32gui.GetWindowText(hwnd)
                    class_name = win32gui.GetClassName(hwnd)
                    
                    # 通过类名检测RDP窗口 - 两种主要的RDP窗口类名
                    rdp_class_found = (
                        class_name == "TscShellContainerClass" or  # RDP连接后的窗口
                        class_name == "TSSHELLWND" or             # 远程桌面窗口
                        class_name == "TscAxRemoteDesktopHost"    # 嵌入式RDP控件
                    )
                    
                    # 通过窗口标题检测RDP窗口（增加匹配条件）
                    rdp_title_found = (
                        "远程桌面连接" in title or
                        "Remote Desktop Connection" in title or
                        "已连接到" in title or
                        "Connected to" in title or
                        "mstsc" in title.lower() or
                        (server_ip and server_ip in title)  # 标题中包含服务器IP
                    )
                    
                    # RDP会话主窗口通常也会包含TscShell
                    shell_found = (
                        "TscShell" in class_name
                    )
                    
                    if rdp_class_found or rdp_title_found or shell_found:
                        # 尝试获取进程ID，确认是mstsc进程
                        try:
                            _, process_id = win32process.GetWindowThreadProcessId(hwnd)
                            if process_id:
                                # 检查进程名称，进一步确认是RDP进程
                                import psutil
                                try:
                                    process = psutil.Process(process_id)
                                    process_name = process.name().lower()
                                    if "mstsc" in process_name or "rdpclip" in process_name:
                                        logging.info(f"找到RDP窗口: {title}, 类名: {class_name}, 进程: {process_name}")
                                        rdp_processes[server_id] = hwnd
                                        result['found'] = True
                                        return False
                                except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                                    pass
                        except:
                            # 如果无法获取进程ID，仍然通过窗口标题和类名判断
                            if rdp_class_found or rdp_title_found:
                                logging.info(f"找到可能的RDP窗口: {title}, 类名: {class_name}")
                                rdp_processes[server_id] = hwnd
                                result['found'] = True
                                return False
                except Exception as e:
                    logging.error(f"检查窗口信息出错: {e}")
            return True
        
        try:
            win32gui.EnumWindows(callback, None)
        except Exception as e:
            logging.error(f"枚举窗口时出错: {e}")
            
        return result['found']

    # 记录连接信息，用于日志记录
    connection_established = False
    max_attempts = 30  # 最大等待30秒
    
    # 首先等待连接建立
    for i in range(max_attempts):
        window_found = find_rdp_window()
        if window_found:
            connection_established = True
            logging.info(f"RDP连接已建立, 服务器ID: {server_id}")
            break
        time.sleep(1)
    
    # 如果未能建立连接，记录日志并退出
    if not connection_established:
        logging.warning(f"未检测到RDP窗口, 服务器ID: {server_id}")
        return
        
    # 连接已建立，开始监控窗口关闭
    try:
        while True:
            window_found = find_rdp_window()
            
            # 如果没有找到窗口，说明窗口已关闭
            if not window_found and server_id in rdp_processes:
                try:
                    with app.app_context():
                        server = Server.query.get(server_id)
                        if server and server.in_use_by == user_id:
                            logging.info(f"检测到RDP窗口关闭, 服务器ID: {server_id}, IP: {server.ip}")
                            
                            # 记录断开日志
                            user = User.query.get(user_id)
                            if user:
                                log = UserLog(
                                    user_id=user_id,
                                    username=user.username,
                                    action='disconnect',
                                    server_id=server_id,
                                    server_name=server.name,
                                    server_ip=server.ip,
                                    details=f"用户 {user.username} 断开RDP连接 {server.name}({server.ip})"
                                )
                                db.session.add(log)
                                
                                # 尝试向客户端发送清理凭据的请求
                                try:
                                    # 查找客户端连接信息
                                    client_ip = None
                                    # 尝试从日志中找到最后登录的客户端IP
                                    last_log = UserLog.query.filter_by(
                                        server_id=server_id, 
                                        action='connect'
                                    ).order_by(UserLog.id.desc()).first()
                                    
                                    if last_log and last_log.client_ip:
                                        client_ip = last_log.client_ip
                                        client_info = app.connected_clients.get(client_ip)
                                        if client_info:
                                            client_url = f"http://{client_info['ip']}:{client_info['port']}/rdp_disconnect"
                                            # 发送请求到客户端
                                            requests.post(
                                                client_url,
                                                json={'host': server.ip},
                                                timeout=2  # 短超时，不影响主流程
                                            )
                                except Exception as e:
                                    # 忽略错误，不影响主流程
                                    logging.error(f"清理凭据请求发送失败: {e}")
                            
                            server.in_use_by = None
                            server.last_active = None
                            db.session.commit()
                    del rdp_processes[server_id]
                    break
                except Exception as e:
                    logging.error(f"更新服务器状态时出错: {e}")
                    break
            
            time.sleep(1)  # 每秒检查一次
    except Exception as e:
        logging.error(f"监控RDP窗口时出错: {e}")
    finally:
        # 确保清理状态
        try:
            with app.app_context():
                server = Server.query.get(server_id)
                if server and server.in_use_by == user_id:
                    # 记录断开日志
                    user = User.query.get(user_id)
                    if user:
                        log = UserLog(
                            user_id=user_id,
                            username=user.username,
                            action='disconnect',
                            server_id=server_id,
                            server_name=server.name,
                            server_ip=server.ip,
                            details=f"用户 {user.username} 断开RDP连接 {server.name}({server.ip})"
                        )
                        db.session.add(log)
                        
                        # 尝试清理凭据
                        try:
                            # 查找客户端连接信息
                            client_ip = None
                            # 尝试从日志中找到最后登录的客户端IP
                            last_log = UserLog.query.filter_by(
                                server_id=server_id, 
                                action='connect'
                            ).order_by(UserLog.id.desc()).first()
                            
                            if last_log and last_log.client_ip:
                                client_ip = last_log.client_ip
                                client_info = app.connected_clients.get(client_ip)
                                if client_info:
                                    client_url = f"http://{client_info['ip']}:{client_info['port']}/rdp_disconnect"
                                    # 发送请求到客户端
                                    requests.post(
                                        client_url,
                                        json={'host': server.ip},
                                        timeout=2  # 短超时，不影响主流程
                                    )
                        except Exception as e:
                            logging.error(f"清理凭据失败: {e}")
                        
                    server.in_use_by = None
                    server.last_active = None
                    db.session.commit()
        except Exception as e:
            logging.error(f"清理服务器状态时出错: {e}")

def is_valid_ip(ip):
    """验证 IP 地址是否合法"""
    try:
        ipaddress.ip_address(ip)
        return True
    except ValueError:
        return False

def is_valid_port(port):
    """验证端口号是否合法"""
    return isinstance(port, int) and 0 < port <= 65535

@remote_bp.before_request
def load_user():
    """在每个请求之前加载当前用户"""
    user_id = session.get('user_id')
    if user_id:
        g.current_user = User.query.get(user_id)
    else:
        g.current_user = None

@remote_bp.route('/rdp/connect', methods=['POST'])
def connect_rdp():
    """处理RDP连接请求"""
    try:
        # 获取当前用户
        if g.current_user is None:
            logging.error("当前用户未登录，无法处理RDP连接请求")
            return jsonify({'error': 'Unauthorized'}), 401
        
        # 获取客户端IP
        client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
        
        logging.info(f"收到RDP连接请求，客户端IP: {client_ip}")
        
        data = request.get_json()
        server_id = data.get('server_id')
        encrypted_password = data.get('password')
        is_encrypted = data.get('is_encrypted', False)
        
        # 获取服务器信息
        server = Server.query.get_or_404(server_id)
        logging.info(f"目标服务器: {server.ip}")
        if server.in_use_by and server.in_use_by != session.get('user_id'):
            return jsonify({'error': 'Server is in use by another user'}), 409
            
        # 生成连接令牌
        token = secrets.token_urlsafe(32)
        
        # 更新服务器状态
        server.in_use_by = session.get('user_id')
        server.last_active = datetime.now()
        
        # 记录连接日志
        log = UserLog(
            user_id=g.current_user.id,
            username=g.current_user.username,
            action='connect',
            server_id=server_id,
            server_name=server.name,
            server_ip=server.ip,
            client_ip=client_ip,
            details=f"用户 {g.current_user.username} 连接RDP服务器 {server.name}({server.ip})"
        )
        db.session.add(log)
        db.session.commit()

        # 发送RDP连接信息到客户端
        # 先从内存中查找客户端信息
        client_info = current_app.connected_clients.get(client_ip)
        
        # 如果内存中没有找到，尝试从数据库查找
        if not client_info:
            client = Client.query.filter_by(ip=client_ip).first()
            if client and client.last_seen and client.last_seen > datetime.now() - timedelta(minutes=30):
                client_info = {
                    'ip': client.ip,
                    'port': client.port,
                    'version': client.version,
                    'hostname': client.hostname,
                    'os_version': client.os_version,
                    'mac_address': client.mac_address,
                    'last_seen': client.last_seen.isoformat()
                }
                
                # 更新内存中的客户端信息
                if not hasattr(current_app, 'connected_clients'):
                    current_app.connected_clients = {}
                current_app.connected_clients[client_ip] = client_info
        
        if not client_info:
            return jsonify({'error': '客户端未连接', 'client_download_url': '/static/fortress_client.exe'}), 503
            
        logging.info(f"找到客户端信息: {client_info}")
        
        try:
            client_url = f"http://{client_info['ip']}:{client_info['port']}/rdp_connect"
            logging.info(f"准备发送RDP连接信息到客户端: {client_url}")
            
            # 获取真实密码
            password = None
            if is_encrypted:
                # 解密从前端传来的加密密码
                import base64
                from backend.utils.crypto import cipher_suite
                try:
                    encrypted = base64.b64decode(encrypted_password)
                    password = cipher_suite.decrypt(encrypted).decode()
                except Exception as e:
                    logging.error(f"密码解密失败: {e}")
                    return jsonify({'error': '密码解密失败'}), 500
            else:
                # 如果不是加密密码，则直接从服务器获取
                password = server.get_password()
            
            # 添加简单的重试机制
            max_retries = 3
            retry_delay = 1  # 秒
            
            for retry in range(max_retries):
                try:
                    if retry > 0:
                        logging.info(f"第 {retry+1} 次尝试连接客户端...")
                    
                    # 发送连接信息到客户端
                    response = requests.post(
                        client_url,
                        json={
                            'host': server.ip,
                            'username': server.username,
                            'password': password,
                            'credential_id': server.name or f"server_{server_id}"  # 优先使用服务器名称，如果为空则使用ID
                        },
                        timeout=5
                    )
                    
                    if response.ok:
                        logging.info("RDP连接请求发送成功")
                        return jsonify({'success': True})
                    else:
                        if retry == max_retries - 1:  # 最后一次尝试
                            logging.error(f"RDP连接请求失败: {response.status_code} - {response.text}")
                            return jsonify({'error': '启动RDP连接失败'}), 500
                        else:
                            logging.warning(f"RDP连接请求失败 (尝试 {retry+1}/{max_retries}): {response.status_code}")
                            time.sleep(retry_delay)
                
                except requests.exceptions.RequestException as e:
                    if retry == max_retries - 1:  # 最后一次尝试
                        logging.error(f"连接客户端失败: {e}")
                        return jsonify({'error': '无法连接到客户端', 'client_download_url': '/static/fortress_client.exe'}), 503
                    else:
                        logging.warning(f"连接客户端失败 (尝试 {retry+1}/{max_retries}): {e}")
                        time.sleep(retry_delay)
                
        except Exception as e:
            logging.error(f"处理RDP连接请求失败: {e}")
            return jsonify({'error': str(e)}), 500
        
    except Exception as e:
        logging.error(f"处理RDP连接请求失败: {e}")
        return jsonify({'error': str(e)}), 500

@remote_bp.route('/ssh/connect', methods=['POST'])
def connect_ssh():
    """处理SSH连接请求"""
    try:
        # 获取当前用户
        if g.current_user is None:
            logging.error("当前用户未登录，无法处理SSH连接请求")
            return jsonify({'error': 'Unauthorized'}), 401
        
        # 获取客户端IP
        client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
        
        logging.info(f"收到SSH连接请求，客户端IP: {client_ip}")
        
        data = request.get_json()
        server_id = data.get('server_id')
        encrypted_password = data.get('password')
        is_encrypted = data.get('is_encrypted', False)
        
        # 获取服务器信息
        server = Server.query.get_or_404(server_id)
        logging.info(f"目标服务器: {server.ip}")
        if server.in_use_by and server.in_use_by != session.get('user_id'):
            return jsonify({'error': 'Server is in use by another user'}), 409
            
        # 更新服务器状态
        server.in_use_by = session.get('user_id')
        server.last_active = datetime.now()
        
        # 记录连接日志
        log = UserLog(
            user_id=g.current_user.id,
            username=g.current_user.username,
            action='connect',
            server_id=server_id,
            server_name=server.name,
            server_ip=server.ip,
            client_ip=client_ip,
            details=f"用户 {g.current_user.username} 连接SSH服务器 {server.name}({server.ip})"
        )
        db.session.add(log)
        db.session.commit()
        
        # 发送SSH连接信息到客户端
        # 先从内存中查找客户端信息
        client_info = current_app.connected_clients.get(client_ip)
        
        # 如果内存中没有找到，尝试从数据库查找
        if not client_info:
            client = Client.query.filter_by(ip=client_ip).first()
            if client and client.last_seen and client.last_seen > datetime.now() - timedelta(minutes=30):
                client_info = {
                    'ip': client.ip,
                    'port': client.port,
                    'version': client.version,
                    'hostname': client.hostname,
                    'os_version': client.os_version,
                    'mac_address': client.mac_address,
                    'last_seen': client.last_seen.isoformat()
                }
                
                # 更新内存中的客户端信息
                if not hasattr(current_app, 'connected_clients'):
                    current_app.connected_clients = {}
                current_app.connected_clients[client_ip] = client_info
            
        if not client_info:
            return jsonify({'error': '客户端未连接', 'client_download_url': '/static/fortress_client.exe'}), 503
            
        logging.info(f"找到客户端信息: {client_info}")
        
        try:
            client_url = f"http://{client_info['ip']}:{client_info['port']}/ssh_connect"
            logging.info(f"准备发送SSH连接信息到客户端: {client_url}")
            
            # 获取真实密码
            password = None
            if is_encrypted:
                # 解密从前端传来的加密密码
                import base64
                from backend.utils.crypto import cipher_suite
                try:
                    encrypted = base64.b64decode(encrypted_password)
                    password = cipher_suite.decrypt(encrypted).decode()
                except Exception as e:
                    logging.error(f"密码解密失败: {e}")
                    return jsonify({'error': '密码解密失败'}), 500
            else:
                # 如果不是加密密码，则直接从服务器获取
                password = server.get_password()
            
            # 添加简单的重试机制
            max_retries = 3
            retry_delay = 1  # 秒
            
            for retry in range(max_retries):
                try:
                    if retry > 0:
                        logging.info(f"第 {retry+1} 次尝试连接客户端...")
                    
                    # 发送连接信息到客户端
                    response = requests.post(
                        client_url,
                        json={
                            'host': server.ip,
                            'port': server.port,
                            'username': server.username,
                            'password': password,
                            'credential_id': server.name or f"server_{server_id}"  # 优先使用服务器名称，如果为空则使用ID
                        },
                        timeout=5
                    )
                    
                    if response.ok:
                        logging.info("SSH连接请求发送成功")
                        return jsonify({'success': True})
                    else:
                        if retry == max_retries - 1:  # 最后一次尝试
                            logging.error(f"SSH连接请求失败: {response.status_code} - {response.text}")
                            return jsonify({'error': '启动SSH连接失败'}), 500
                        else:
                            logging.warning(f"SSH连接请求失败 (尝试 {retry+1}/{max_retries}): {response.status_code}")
                            time.sleep(retry_delay)
                
                except requests.exceptions.RequestException as e:
                    if retry == max_retries - 1:  # 最后一次尝试
                        logging.error(f"连接客户端失败: {e}")
                        return jsonify({'error': '无法连接到客户端', 'client_download_url': '/static/fortress_client.exe'}), 503
                    else:
                        logging.warning(f"连接客户端失败 (尝试 {retry+1}/{max_retries}): {e}")
                        time.sleep(retry_delay)
                
        except Exception as e:
            logging.error(f"处理SSH连接请求失败: {e}")
            return jsonify({'error': str(e)}), 500
        
    except Exception as e:
        logging.error(f"处理SSH连接请求失败: {e}")
        return jsonify({'error': str(e)}), 500

@remote_bp.route('/client/status', methods=['POST'])
def client_status():
    """接收客户端状态报告"""
    data = request.get_json()
    # 存储客户端状态
    client_status = {
        'status': data.get('status'),
        'version': data.get('version'),
        'last_update': data.get('last_update'),
        'ip': request.remote_addr
    }
    
    # 可以将状态存储在数据库或缓存中
    # 这里简单使用全局变量
    if not hasattr(current_app, 'client_statuses'):
        current_app.client_statuses = {}
    current_app.client_statuses[request.remote_addr] = client_status
    
    return jsonify({'success': True})

@remote_bp.route('/client/verify', methods=['POST'])
def verify_client():
    """验证客户端连接"""
    try:
        data = request.get_json()
        client_ip = data.get('client_ip')
        client_port = data.get('client_port')
        version = data.get('version')
        hostname = data.get('hostname')
        os_version = data.get('os_version')
        mac_address = data.get('mac_address')
        
        # 记录详细日志
        logging.info(f"收到客户端注册请求: IP={client_ip}, Port={client_port}, Version={version}, MAC={mac_address}")
        
        if not all([client_ip, client_port]):
            logging.error("缺少必要的客户端信息")
            return jsonify({'error': 'Missing required fields'}), 400
            
        # 验证客户端是否可访问
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            result = sock.connect_ex((client_ip, client_port))
            sock.close()
            
            if result != 0:
                logging.error(f"无法连接到客户端端口: {client_ip}:{client_port}")
                return jsonify({'error': 'Client port not accessible'}), 503
                
            logging.info(f"客户端端口可访问: {client_ip}:{client_port}")
        except Exception as e:
            logging.error(f"验证客户端连接失败: {e}")
            return jsonify({'error': 'Failed to verify client connection'}), 503
            
        # 存储客户端信息到内存中
        client_info = {
            'ip': client_ip,
            'port': client_port,
            'version': version,
            'hostname': hostname,
            'os_version': os_version,
            'mac_address': mac_address,
            'last_seen': datetime.now().isoformat()
        }
        
        if not hasattr(current_app, 'connected_clients'):
            current_app.connected_clients = {}
        
        # 检查是否存在相同MAC地址的客户端记录
        old_client_info, old_ip = find_client_by_mac(mac_address) if mac_address else (None, None)
        if old_client_info and old_ip != client_ip:
            # 如果MAC地址相同但IP不同，说明客户端IP发生了变化
            logging.info(f"检测到客户端IP变化: {old_ip} -> {client_ip}, MAC: {mac_address}")
            
            # 从旧IP中删除客户端信息
            if old_ip in current_app.connected_clients:
                del current_app.connected_clients[old_ip]
                
        # 更新客户端信息
        current_app.connected_clients[client_ip] = client_info
        
        # 将客户端信息保存到数据库
        try:
            # 如果有MAC地址，先尝试通过MAC地址查找
            existing_client = None
            if mac_address:
                existing_client = Client.query.filter_by(mac_address=mac_address).first()
            
            # 如果没有找到，再通过IP查找
            if not existing_client:
                existing_client = Client.query.filter_by(ip=client_ip).first()
            
            if existing_client:
                # 更新现有记录
                existing_client.ip = client_ip  # 确保IP是最新的
                existing_client.port = client_port
                existing_client.version = version
                existing_client.hostname = hostname
                existing_client.os_version = os_version
                if mac_address:  # 只有在提供MAC地址时才更新
                    existing_client.mac_address = mac_address
                existing_client.last_seen = datetime.now()
            else:
                # 创建新记录
                new_client = Client(
                    ip=client_ip,
                    port=client_port,
                    version=version,
                    hostname=hostname,
                    os_version=os_version,
                    mac_address=mac_address
                )
                db.session.add(new_client)
                
            db.session.commit()
            logging.info(f"客户端信息已保存到数据库: {client_ip}:{client_port}")
        except Exception as e:
            logging.error(f"保存客户端信息到数据库失败: {e}")
            # 继续执行，即使数据库保存失败也不影响客户端使用
        
        logging.info(f"客户端注册成功: {client_info}")
        return jsonify({'success': True})
        
    except Exception as e:
        logging.error(f"处理客户端注册请求失败: {e}")
        return jsonify({'error': str(e)}), 500

@remote_bp.route('/client/status', methods=['GET'])
def get_client_status():
    """获取客户端状态"""
    try:
        # 获取当前浏览器IP
        browser_ip = request.remote_addr
        logging.info(f"检查客户端状态，浏览器IP: {browser_ip}")
        
        # 使用增强的客户端查找函数
        client_info = find_client(browser_ip)
        if client_info:
            # 验证客户端是否仍然可访问
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(1)
                result = sock.connect_ex((browser_ip, client_info['port']))
                sock.close()
                
                if result == 0:
                    return jsonify({
                        'is_connected': True,
                        'client_info': client_info
                    })
            except:
                pass
                    
        return jsonify({
            'is_connected': False,
            'client_download_url': '/static/fortress_client.exe'
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@remote_bp.route('/client/heartbeat', methods=['POST'])
def client_heartbeat():
    """处理客户端心跳请求，更新客户端活跃状态"""
    try:
        data = request.get_json()
        client_ip = data.get('client_ip')
        client_port = data.get('client_port')
        mac_address = data.get('mac_address')
        timestamp = data.get('timestamp')
        
        if not all([client_ip, client_port]):
            return jsonify({'error': 'Missing required fields'}), 400
            
        logging.debug(f"收到客户端心跳: IP={client_ip}, MAC={mac_address}")
        
        # 更新内存中的客户端信息
        updated = False
        
        # 首先尝试通过IP查找
        if hasattr(current_app, 'connected_clients') and client_ip in current_app.connected_clients:
            client_info = current_app.connected_clients[client_ip]
            client_info['last_seen'] = timestamp or datetime.now().isoformat()
            updated = True
        
        # 如果通过IP未找到，但有MAC地址，则尝试通过MAC地址查找
        if not updated and mac_address:
            client_info, old_ip = find_client_by_mac(mac_address)
            if client_info and old_ip:
                # 如果IP发生变化，更新映射
                if old_ip != client_ip:
                    logging.info(f"客户端IP已变更: {old_ip} -> {client_ip}, MAC: {mac_address}")
                    
                    # 删除旧映射
                    if old_ip in current_app.connected_clients:
                        del current_app.connected_clients[old_ip]
                    
                    # 创建新映射
                    client_info['ip'] = client_ip
                    client_info['port'] = client_port
                    client_info['last_seen'] = timestamp or datetime.now().isoformat()
                    current_app.connected_clients[client_ip] = client_info
                else:
                    # IP未变化，只更新时间戳
                    client_info['last_seen'] = timestamp or datetime.now().isoformat()
                    current_app.connected_clients[old_ip] = client_info
                    
                updated = True
        
        # 如果内存中没有找到客户端信息，尝试从数据库更新
        if not updated:
            # 首先尝试通过MAC地址查找
            if mac_address:
                client = Client.query.filter_by(mac_address=mac_address).first()
            else:
                client = None
                
            # 如果通过MAC地址未找到，则通过IP查找
            if not client:
                client = Client.query.filter_by(ip=client_ip).first()
                
            if client:
                # 更新数据库中的客户端信息
                client.ip = client_ip
                client.port = client_port
                client.last_seen = datetime.now()
                
                # 更新内存中的客户端信息
                if not hasattr(current_app, 'connected_clients'):
                    current_app.connected_clients = {}
                    
                current_app.connected_clients[client_ip] = {
                    'ip': client_ip,
                    'port': client_port,
                    'version': client.version,
                    'hostname': client.hostname,
                    'os_version': client.os_version,
                    'mac_address': client.mac_address,
                    'last_seen': datetime.now().isoformat()
                }
                
                db.session.commit()
                updated = True
        
        # 如果客户端信息不存在，则返回错误
        if not updated:
            return jsonify({'error': 'Client not registered'}), 404
            
        return jsonify({'success': True})
        
    except Exception as e:
        logging.error(f"处理客户端心跳请求失败: {e}")
        return jsonify({'error': str(e)}), 500

@remote_bp.route('/health', methods=['GET'])
def health_check():
    """健康检查接口"""
    try:
        return jsonify({
            'status': 'ok',
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        logging.error(f"健康检查失败: {e}")
        return jsonify({'error': str(e)}), 500



