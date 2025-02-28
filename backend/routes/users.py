from flask import Blueprint, request, jsonify, session, g
from backend.models.user import User
from backend.models.server import Server
from backend.extensions import db
from functools import wraps

users_bp = Blueprint('users', __name__)

def get_current_user():
    """从 session 中获取当前用户"""
    user_id = session.get('user_id')
    if not user_id:
        return None
    return User.query.get(user_id)

def admin_required(f):
    """管理员权限装饰器"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        user = get_current_user()
        if not user or not user.is_admin:
            return jsonify({'error': 'Admin privileges required'}), 403
        return f(*args, **kwargs)
    return decorated_function

@users_bp.route('/login', methods=['POST'])
def login():
    """用户登录"""
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # 验证用户
    user = User.query.filter_by(username=username).first()
    if user and user.check_password(password):
        session['user_id'] = user.id  # 设置 session
        g.current_user = user  # 设置 g.current_user
        return jsonify({'message': 'Login successful'})
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

@users_bp.route('/logout', methods=['POST'])
def logout():
    """用户注销"""
    session.pop('user_id', None)  # 清除 session
    g.current_user = None  # 清除 g.current_user
    return jsonify({'message': 'Logout successful'})

@users_bp.route('/users', methods=['GET'])
@admin_required
def get_users():
    """获取所有用户"""
    users = User.query.all()
    return jsonify([{
        'id': user.id,
        'username': user.username,
        'is_admin': user.is_admin
    } for user in users])

@users_bp.route('/users', methods=['POST'])
@admin_required
def create_user():
    """创建用户"""
    data = request.get_json()
    
    # 验证必需的字段
    required_fields = ['username', 'password']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
            
    # 检查用户名是否已存在
    if User.query.filter_by(username=data['username']).first():
        return jsonify({'error': 'Username already exists'}), 400
        
    user = User(
        username=data['username'],
        is_admin=data.get('is_admin', False)
    )
    user.set_password(data['password'])
    
    try:
        db.session.add(user)
        db.session.commit()
        return jsonify({'message': 'User created successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@users_bp.route('/users/<int:user_id>', methods=['DELETE'])
@admin_required
def delete_user(user_id):
    """删除用户"""
    # 不允许删除自己
    if user_id == session.get('user_id'):
        return jsonify({'error': 'Cannot delete yourself'}), 400
        
    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'})

@users_bp.route('/users/<int:user_id>', methods=['PUT'])
@admin_required
def update_user(user_id):
    """更新用户信息"""
    user = User.query.get_or_404(user_id)
    data = request.get_json()
    
    # 不允许修改自己的管理员状态
    if user_id == session.get('user_id') and 'is_admin' in data:
        return jsonify({'error': 'Cannot modify your own admin status'}), 400
    
    if 'username' in data:
        # 检查新用户名是否已存在
        existing_user = User.query.filter_by(username=data['username']).first()
        if existing_user and existing_user.id != user_id:
            return jsonify({'error': 'Username already exists'}), 400
        user.username = data['username']
        
    if 'password' in data:
        user.set_password(data['password'])
        
    if 'is_admin' in data:
        user.is_admin = data['is_admin']
    
    try:
        db.session.commit()
        return jsonify({'message': 'User updated successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@users_bp.route('/users/<int:user_id>/servers', methods=['GET'])
@admin_required
def get_user_servers(user_id):
    """获取用户的服务器列表"""
    user = User.query.get_or_404(user_id)
    return jsonify([{
        'id': server.id,
        'name': server.name,
        'ip': server.ip,
        'type': server.type,
        'username': server.username
    } for server in user.servers])

@users_bp.route('/users/<int:user_id>/servers', methods=['POST'])
@admin_required
def update_user_servers(user_id):
    """更新用户的服务器列表"""
    user = User.query.get_or_404(user_id)
    data = request.get_json()
    server_ids = data.get('server_ids', [])
    
    # 更新用户的服务器列表
    user.servers = Server.query.filter(Server.id.in_(server_ids)).all()
    db.session.commit()
    
    return jsonify({'message': 'User servers updated successfully'})

@users_bp.route('/users/current', methods=['GET'])
def get_current_user_info():
    """获取当前用户信息"""
    user = get_current_user()
    if not user:
        return jsonify({'error': 'Not logged in'}), 401
        
    return jsonify({
        'id': user.id,
        'username': user.username,
        'is_admin': user.is_admin
    })