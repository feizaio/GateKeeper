from flask import Blueprint, request, jsonify, session, g
from backend.models.user import User
from backend import db
from werkzeug.security import check_password_hash
from datetime import timedelta, datetime
import logging
from functools import wraps
from backend.models.userlog import UserLog  # 修改导入路径
import hashlib

auth_bp = Blueprint('auth', __name__)

# 添加登录验证装饰器
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not g.current_user:
            return jsonify({'error': 'Unauthorized'}), 401
        return f(*args, **kwargs)
    return decorated_function

# 添加管理员权限验证装饰器
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not g.current_user or not g.current_user.is_admin:
            return jsonify({'error': '需要管理员权限'}), 403
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

# 用于存储最近登录的请求信息
login_requests = {}

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        user = User.query.filter_by(username=data.get('username')).first()
        
        # 生成请求的唯一标识
        request_data = f"{data.get('username')}:{request.remote_addr}"
        request_hash = hashlib.md5(request_data.encode()).hexdigest()
        current_time = datetime.now()
        
        # 检查最近5秒内是否有相同的登录请求
        if request_hash in login_requests:
            last_request_time = login_requests[request_hash]
            time_diff = (current_time - last_request_time).total_seconds()
            if time_diff < 5:  # 5秒内的重复请求将被忽略
                logging.warning(f"检测到重复登录请求: {data.get('username')} 来自 {request.remote_addr}, 间隔 {time_diff}秒")
                return jsonify({
                    'id': user.id if user else None,
                    'username': user.username if user else None,
                    'is_admin': user.is_admin if user else None
                })
        
        # 记录本次请求时间
        login_requests[request_hash] = current_time
        
        # 清理旧的请求记录（超过10分钟的）
        for key in list(login_requests.keys()):
            if (current_time - login_requests[key]).total_seconds() > 600:
                del login_requests[key]
                
        if user and user.check_password(data.get('password')):
            session.permanent = True
            session['user_id'] = user.id
            # 确保 session 被保存
            session.modified = True
            
            # 记录登录日志
            client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
            log = UserLog(
                user_id=user.id,
                username=user.username,
                action='login',
                client_ip=client_ip,
                details=f"用户 {user.username} 登录系统"
            )
            db.session.add(log)
            db.session.commit()
            
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
    user_id = session.get('user_id')
    if user_id:
        user = User.query.get(user_id)
        if user:
            # 记录注销日志
            client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
            log = UserLog(
                user_id=user.id,
                username=user.username,
                action='logout',
                client_ip=client_ip,
                details=f"用户 {user.username} 注销系统"
            )
            db.session.add(log)
            db.session.commit()
    
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

@auth_bp.route('/logs', methods=['GET'])
@login_required
@admin_required
def get_logs():
    """获取用户日志记录（需要管理员权限）"""
    try:
        # 获取分页参数
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 20))
        
        # 获取筛选参数
        user_id = request.args.get('user_id')
        action = request.args.get('action')
        server_id = request.args.get('server_id')
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        # 构建查询
        query = UserLog.query
        
        if user_id:
            query = query.filter(UserLog.user_id == user_id)
        if action:
            query = query.filter(UserLog.action == action)
        if server_id:
            query = query.filter(UserLog.server_id == server_id)
        if start_date:
            query = query.filter(UserLog.created_at >= start_date)
        if end_date:
            query = query.filter(UserLog.created_at <= end_date)
        
        # 按时间倒序排序
        query = query.order_by(UserLog.created_at.desc())
        
        # 分页
        paginated_logs = query.paginate(page=page, per_page=per_page)
        
        # 格式化结果
        logs = [{
            'id': log.id,
            'user_id': log.user_id,
            'username': log.username,
            'action': log.action,
            'server_id': log.server_id,
            'server_name': log.server_name,
            'server_ip': log.server_ip,
            'client_ip': log.client_ip,
            'details': log.details,
            'created_at': log.created_at.strftime('%Y-%m-%d %H:%M:%S')
        } for log in paginated_logs.items]
        
        return jsonify({
            'logs': logs,
            'total': paginated_logs.total,
            'pages': paginated_logs.pages,
            'page': page,
            'per_page': per_page
        })
        
    except Exception as e:
        logging.error(f"获取日志失败: {str(e)}")
        return jsonify({'error': str(e)}), 500
