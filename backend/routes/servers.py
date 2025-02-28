from flask import Blueprint, request, jsonify, session
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from functools import wraps
from datetime import datetime, timedelta

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
        servers = user.servers
        
    return jsonify([{
        'id': server.id,
        'name': server.name,
        'ip': server.ip,
        'type': server.type,
        'username': server.username,
        'in_use': bool(server.in_use_by),
        'in_use_by_me': server.in_use_by == user.id,
        'in_use_by_username': (
            '我' if server.in_use_by == user.id 
            else (server.current_user.username if server.in_use_by 
            else None)
        )
    } for server in servers])

@servers_bp.route('/servers/<int:server_id>/status', methods=['POST'])
@login_required
def update_server_status(server_id):
    user = get_current_user()
    server = Server.query.get_or_404(server_id)
    
    # 检查用户是否有权限访问此服务器
    if not user.is_admin and server not in user.servers:
        return jsonify({'error': 'Access denied'}), 403
    
    data = request.get_json()
    action = data.get('action')
    
    if action == 'connect':
        # 如果服务器已被其他用户使用
        if server.in_use_by and server.in_use_by != user.id:
            return jsonify({
                'error': 'Server is in use',
                'in_use_by': server.current_user.username
            }), 409
        server.in_use_by = user.id
        server.last_active = datetime.now()
    elif action == 'disconnect':
        if server.in_use_by == user.id:
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
    if not user.is_admin and server not in user.servers:
        return jsonify({'error': 'Access denied'}), 403
        
    # 检查服务器是否被其他用户使用
    if server.in_use_by and server.in_use_by != user.id:
        return jsonify({'error': f'Server is in use by {server.current_user.username}'}), 409
        
    password = server.get_password()
    if password is None:
        return jsonify({'error': 'Password not available'}), 404
    return jsonify({'password': password})

@servers_bp.route('/servers', methods=['POST'])
@admin_required
def add_server():
    data = request.get_json()
    
    # 验证必需的字段
    required_fields = ['name', 'ip', 'type', 'username', 'password']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
            
    # 验证系统类型
    if data['type'] not in ['Windows', 'Linux']:
        return jsonify({'error': 'Invalid system type. Must be either Windows or Linux'}), 400
    
    server = Server(
        name=data['name'],
        ip=data['ip'],
        type=data['type'],
        username=data['username']
    )
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