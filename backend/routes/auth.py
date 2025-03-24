from flask import Blueprint, request, jsonify, session, g
from backend.models.user import User
from backend import db
from werkzeug.security import check_password_hash
from datetime import timedelta
import logging
from functools import wraps

auth_bp = Blueprint('auth', __name__)

# 添加登录验证装饰器
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not g.current_user:
            return jsonify({'error': 'Unauthorized'}), 401
        return f(*args, **kwargs)
    return decorated_function

# 添加请求前处理，设置当前用户
@auth_bp.before_request
def get_current_user():
    user_id = session.get('user_id')
    if user_id:
        g.current_user = User.query.get(user_id)
    else:
        g.current_user = None

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        user = User.query.filter_by(username=data.get('username')).first()
        
        if user and user.check_password(data.get('password')):
            session.permanent = True
            session['user_id'] = user.id
            # 确保 session 被保存
            session.modified = True
            
            return jsonify({
                'id': user.id,
                'username': user.username,
                'is_admin': user.is_admin
            })
        
        return jsonify({'error': 'Invalid username or password'}), 401
        
    except Exception as e:
        print(f"Login error: {e}")  # 添加日志
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/logout', methods=['POST'])
def logout():
    """用户注销"""
    session.pop('user_id', None)  # 清除 session
    g.current_user = None  # 清除 g.current_user
    return jsonify({'message': 'Logged out successfully'})

@auth_bp.route('/check', methods=['GET'])
def check_auth():
    user_id = session.get('user_id')
    if user_id:
        user = User.query.get(user_id)
        if user:
            return jsonify({
                'id': user.id,
                'username': user.username,
                'is_admin': user.is_admin
            })
    return jsonify({'error': 'Not logged in'}), 401

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    print("Received data:", data)  # 添加日志
    if not data:
        return jsonify({'message': 'No data received'}), 400  # 确保 data 不是 None

    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'message': 'Username and password are required'}), 400

    if User.query.filter_by(username=username).first():
        return jsonify({'message': 'User already exists'}), 400

    user = User(username=username)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

@auth_bp.route('/change-password', methods=['POST'])
@login_required
def change_password():
    """修改用户密码"""
    try:
        data = request.get_json()
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        
        if not old_password or not new_password:
            return jsonify({'error': '请提供原密码和新密码'}), 400
            
        # 验证原密码
        if not g.current_user.check_password(old_password):
            return jsonify({'error': '原密码错误'}), 400
            
        # 设置新密码
        g.current_user.set_password(new_password)
        db.session.commit()
        
        return jsonify({'success': True, 'message': '密码修改成功'})
        
    except Exception as e:
        logging.error(f"修改密码失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
