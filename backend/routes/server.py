from flask import Blueprint, request, jsonify, g
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from datetime import datetime
from functools import wraps
import logging
from flask import session

server_bp = Blueprint('server', __name__)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not g.current_user:
            return jsonify({'error': 'Unauthorized'}), 401
        return f(*args, **kwargs)
    return decorated_function

@server_bp.before_request
def get_current_user():
    user_id = session.get('user_id')
    logging.info(f"Session User ID: {user_id}")
    if user_id:
        g.current_user = User.query.get(user_id)
        logging.info(f"当前用户: {g.current_user.username if g.current_user else '未找到用户'}")
    else:
        g.current_user = None

@server_bp.route('/', methods=['GET'])
@login_required
def get_servers():
    """获取服务器列表"""
    try:
        logging.info("获取服务器列表")
        
        # 根据用户权限获取服务器列表
        if g.current_user.is_admin:
            servers = Server.query.all()  # 管理员可以看到所有服务器
        else:
            servers = g.current_user.managed_servers.all()  # 普通用户只能看到分配给他们的服务器
            
        return jsonify([{
            'id': server.id,
            'name': server.name,
            'ip': server.ip,
            'type': server.type,
            'username': server.username,
            'in_use': bool(server.in_use_by),
            'last_active': server.last_active.isoformat() if server.last_active else None,
            'in_use_by_me': server.in_use_by == g.current_user.id,
            'in_use_by_username': (
                '我' if server.in_use_by == g.current_user.id 
                else (User.query.get(server.in_use_by).username if server.in_use_by 
                else None)
            )
        } for server in servers])
    except Exception as e:
        logging.error(f"获取服务器列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@server_bp.route('/', methods=['POST'])
@login_required
def add_server():
    """添加服务器"""
    try:
        data = request.get_json()
        logging.info(f"添加服务器: {data}")
        
        server = Server(
            name=data['name'],
            ip=data['ip'],
            type=data['type'],
            username=data['username']
        )
        server.set_password(data['password'])
        
        db.session.add(server)
        db.session.commit()
        
        return jsonify({
            'id': server.id,
            'name': server.name,
            'ip': server.ip,
            'type': server.type
        })
    except Exception as e:
        logging.error(f"添加服务器失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@server_bp.route('/<int:server_id>', methods=['DELETE'])
def delete_server(server_id):
    """删除服务器"""
    try:
        server = Server.query.get_or_404(server_id)
        
        # 检查服务器是否正在使用
        if server.in_use_by:
            return jsonify({'error': '服务器正在使用中，无法删除'}), 400
            
        db.session.delete(server)
        db.session.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@server_bp.route('/<int:server_id>', methods=['PUT'])
def update_server(server_id):
    """更新服务器信息"""
    try:
        server = Server.query.get_or_404(server_id)
        data = request.get_json()
        
        if 'name' in data:
            server.name = data['name']
        if 'ip' in data:
            server.ip = data['ip']
        if 'type' in data:
            server.type = data['type']
        if 'username' in data:
            server.username = data['username']
        if 'password' in data:
            server.set_password(data['password'])
            
        db.session.commit()
        
        return jsonify({
            'id': server.id,
            'name': server.name,
            'ip': server.ip,
            'type': server.type
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500 