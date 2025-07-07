from flask import Blueprint, request, jsonify, session
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from functools import wraps
from datetime import datetime, timedelta
from backend.models.userlog import UserLog
import time
import base64
from backend.utils.crypto import cipher_suite

servers_bp = Blueprint('servers', __name__)

def get_current_user():
    user_id = session.get('user_id')
    if not user_id:
        return None
    return User.query.get(user_id)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('user_id'):
            return jsonify({'error': 'Not logged in'}), 401
        return f(*args, **kwargs)
    return decorated_function

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        user = get_current_user()
        if not user or not user.is_admin:
            return jsonify({'error': 'Admin privileges required'}), 403
        return f(*args, **kwargs)
    return decorated_function

@servers_bp.route('/servers', methods=['GET'])
@login_required
def get_servers():
    user = get_current_user()
    # 清理所有过期的使用状态
    try:
        current_time = datetime.now()
        servers = Server.query.filter(
            Server.last_active.isnot(None),
            Server.last_active < current_time - timedelta(minutes=15)
        ).all()
        
        for server in servers:
            server.in_use_by = None
            server.last_active = None
        
        db.session.commit()
    except Exception as e:
        print(f"Error cleaning up server states: {e}")
    
    # 获取服务器列表
    if user.is_admin:
        servers = Server.query.all()
    else:
        servers = user.managed_servers.all()
        
    return jsonify([{
        'id': server.id,
        'name': server.name,
        'ip': server.ip,
        'type': server.type,
        'username': server.username,
        'category_id': server.category_id,
        'category_name': server.category.name if server.category else None,
        'in_use': bool(server.in_use_by),
        'in_use_by_me': server.in_use_by == user.id,
        'in_use_by_username': (
            '我' if server.in_use_by == user.id 
            else (User.query.get(server.in_use_by).username if server.in_use_by 
            else None)
        ),
        'remark': server.remark
    } for server in servers])

@servers_bp.route('/servers/<int:server_id>/status', methods=['POST'])
@login_required
def update_server_status(server_id):
    user = get_current_user()
    server = Server.query.get_or_404(server_id)
    
    # 检查用户是否有权限访问此服务器
    if not user.is_admin and server not in user.managed_servers:
        return jsonify({'error': 'Access denied'}), 403
    
    data = request.get_json()
    action = data.get('action')
    
    if action == 'connect':
        # 如果服务器已被其他用户使用
        if server.in_use_by and server.in_use_by != user.id:
            in_use_by_user = User.query.get(server.in_use_by)
            return jsonify({
                'error': 'Server is in use',
                'in_use_by': in_use_by_user.username if in_use_by_user else 'Unknown user'
            }), 409
        server.in_use_by = user.id
        server.last_active = datetime.now()
    elif action == 'disconnect':
        if server.in_use_by == user.id:
            # 记录断开日志
            client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
            log = UserLog(
                user_id=user.id,
                username=user.username,
                action='disconnect',
                server_id=server.id,
                server_name=server.name,
                server_ip=server.ip,
                client_ip=client_ip,
                details=f"用户 {user.username} 主动断开{server.type}连接 {server.name}({server.ip})"
            )
            db.session.add(log)
            
            server.in_use_by = None
            server.last_active = None
    elif action == 'heartbeat':
        if server.in_use_by == user.id:
            server.last_active = datetime.now()
    
    db.session.commit()
    return jsonify({'message': 'Status updated successfully'})

@servers_bp.route('/servers/<int:server_id>/password', methods=['GET'])
@login_required
def get_server_password(server_id):
    user = get_current_user()
    server = Server.query.get_or_404(server_id)
    
    # 检查用户是否有权限访问此服务器
    if not user.is_admin and server not in user.managed_servers:
        return jsonify({'error': 'Access denied'}), 403
        
    # 检查服务器是否被其他用户使用
    if server.in_use_by and server.in_use_by != user.id:
        in_use_by_user = User.query.get(server.in_use_by)
        return jsonify({'error': f'Server is in use by {in_use_by_user.username if in_use_by_user else "Unknown user"}'}), 409
        
    password = server.get_password()
    if password is None:
        return jsonify({'error': 'Password not available'}), 404
        
    # 使用当前用户的ID和时间戳作为临时加密密钥
    temp_key = f"{user.id}_{int(time.time())}"
    session['temp_password_key'] = temp_key
    
    # 加密密码
    encrypted = cipher_suite.encrypt(password.encode())
    encrypted_password = base64.b64encode(encrypted).decode()
    
    return jsonify({'password': encrypted_password, 'encrypted': True})

@servers_bp.route('/servers', methods=['POST'])
@admin_required
def add_server():
    data = request.get_json()
    
    # 基本字段验证
    if 'name' not in data or not data['name']:
        return jsonify({'error': 'Missing required field: name'}), 400
    
    if 'ip' not in data or not data['ip']:
        return jsonify({'error': 'Missing required field: ip'}), 400
    
    if 'type' not in data or data['type'] not in ['Windows', 'Linux']:
        return jsonify({'error': 'Invalid system type. Must be either Windows or Linux'}), 400
    
    # 创建服务器对象
    server = Server(
        name=data['name'],
        ip=data['ip'],
        type=data['type'],
        port=data.get('port', 22 if data['type'] == 'Linux' else 3389),
        remark=data.get('remark')
    )
    
    # 设置分类
    if 'category_id' in data and data['category_id']:
        server.category_id = data['category_id']
    
    # 处理凭据
    if 'credential_id' in data and data['credential_id']:
        # 使用预设凭据
        from backend.models.credential import Credential
        credential = Credential.query.get(data['credential_id'])
        if not credential:
            return jsonify({'error': 'Invalid credential ID'}), 400
        
        server.credential_id = credential.id
        server.username = credential.username
        server.set_password(credential.get_password())
    else:
        # 使用传入的用户名和密码
        if 'username' not in data or not data['username']:
            return jsonify({'error': 'Missing required field: username'}), 400
        
        if 'password' not in data or not data['password']:
            return jsonify({'error': 'Missing required field: password'}), 400
        
        server.username = data['username']
        server.set_password(data['password'])
    
    try:
        db.session.add(server)
        db.session.commit()
        return jsonify({'message': 'Server added successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@servers_bp.route('/servers/<int:server_id>', methods=['DELETE'])
@admin_required
def delete_server(server_id):
    server = Server.query.get_or_404(server_id)
    db.session.delete(server)
    db.session.commit()
    return jsonify({'message': 'Server deleted successfully'})

@servers_bp.route('/servers/<int:server_id>', methods=['PUT'])
@admin_required
def update_server(server_id):
    server = Server.query.get_or_404(server_id)
    data = request.get_json()
    
    # 更新基本信息
    if 'name' in data:
        server.name = data['name']
    if 'ip' in data:
        server.ip = data['ip']
    if 'port' in data:
        server.port = data['port']
    if 'type' in data and data['type'] in ['Windows', 'Linux']:
        server.type = data['type']
    if 'category_id' in data:
        server.category_id = data['category_id'] if data['category_id'] else None
    if 'remark' in data:
        server.remark = data['remark']
    
    # 处理凭据更新
    if 'credential_id' in data:
        if data['credential_id']:
            # 更新为新的预设凭据
            from backend.models.credential import Credential
            credential = Credential.query.get(data['credential_id'])
            if not credential:
                return jsonify({'error': 'Invalid credential ID'}), 400
            
            server.credential_id = credential.id
            server.username = credential.username
            server.set_password(credential.get_password())
        else:
            # 清除凭据关联，使用传入的用户名和密码
            server.credential_id = None
            
            if 'username' in data:
                server.username = data['username']
            
            if 'password' in data and data['password']:
                server.set_password(data['password'])
    else:
        # 不修改凭据关联，但可能更新用户名密码
        if 'username' in data:
            server.username = data['username']
        
        if 'password' in data and data['password']:
            server.set_password(data['password'])
    
    try:
        db.session.commit()
        return jsonify({'message': 'Server updated successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500 