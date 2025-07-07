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
            'category_id': server.category_id,
            'category_name': server.category.name if server.category else None,
            'in_use': bool(server.in_use_by),
            'last_active': server.last_active.isoformat() if server.last_active else None,
            'in_use_by_me': server.in_use_by == g.current_user.id,
            'in_use_by_username': (
                '我' if server.in_use_by == g.current_user.id 
                else (User.query.get(server.in_use_by).username if server.in_use_by 
                else None)
            ),
            'remark': server.remark  # 确保包含remark字段
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
        logging.info(f"备注字段: {data.get('remark')}")  # 添加备注字段的日志
        
        # 根据服务器类型设置默认端口
        if 'port' not in data or data['port'] is None:
            if data['type'] == 'Windows':
                default_port = 3389  # Windows默认RDP端口
            else:
                default_port = 22    # Linux默认SSH端口
            data['port'] = default_port
        
        server = Server(
            name=data['name'],
            ip=data['ip'],
            type=data['type'],
            username=data['username'],
            port=data['port'],  # 使用根据类型设置的端口
            category_id=data.get('category_id'),  # 添加分类ID
            remark=data.get('remark')  # 添加备注字段
        )
        logging.info(f"创建的服务器对象: name={server.name}, ip={server.ip}, remark={server.remark}")  # 添加服务器对象的日志
        server.set_password(data['password'])
        
        db.session.add(server)
        db.session.commit()
        logging.info(f"服务器添加成功，ID: {server.id}, 备注: {server.remark}")  # 添加成功后的日志
        
        return jsonify({
            'id': server.id,
            'name': server.name,
            'ip': server.ip,
            'type': server.type,
            'port': server.port,  # 添加端口到返回结果
            'category_id': server.category_id,
            'category_name': server.category.name if server.category else None,
            'remark': server.remark  # 添加备注字段
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
@login_required
def update_server(server_id):
    """更新服务器信息"""
    try:
        logging.info(f"开始更新服务器 ID: {server_id}")
        server = Server.query.get_or_404(server_id)
        data = request.get_json()
        logging.info(f"更新数据: {data}")
        logging.info(f"备注字段: {data.get('remark')}")  # 添加备注字段的日志
        
        # 检查是否有权限更新
        if not g.current_user.is_admin:
            logging.warning(f"用户 {g.current_user.username} 尝试更新服务器但没有管理员权限")
            return jsonify({'error': '没有权限更新服务器信息'}), 403
            
        # 验证必需字段
        required_fields = ['name', 'ip', 'type', 'username']
        for field in required_fields:
            if field not in data:
                logging.error(f"缺少必需字段: {field}")
                return jsonify({'error': f'缺少必需字段: {field}'}), 400
        
        try:
            # 更新服务器信息
            server.name = data['name']
            server.ip = data['ip']
            server.type = data['type']
            server.username = data['username']
            
            # 处理端口字段
            if 'port' in data and data['port'] is not None:
                server.port = data['port']
            elif server.port is None or (data['type'] != server.type):
                # 如果服务器类型改变或原先没有端口，根据新类型设置默认端口
                if data['type'] == 'Windows':
                    server.port = 3389  # Windows 默认RDP端口
                else:
                    server.port = 22    # Linux 默认SSH端口
            
            # 如果提供了新密码，则更新密码
            if data.get('password'):
                server.set_password(data['password'])
            
            # 更新备注字段
            server.remark = data.get('remark')
            logging.info(f"更新备注字段: {data['remark']}")  # 添加更新备注字段的日志
            
            db.session.commit()
            logging.info(f"服务器 {server_id} 更新成功，备注: {server.remark}")  # 添加更新成功后的日志
            
            return jsonify({
                'id': server.id,
                'name': server.name,
                'ip': server.ip,
                'type': server.type,
                'port': server.port,  # 返回端口值
                'username': server.username,
                'remark': server.remark  # 返回备注字段
            })
        except Exception as e:
            logging.error(f"数据库更新失败: {str(e)}")
            db.session.rollback()
            return jsonify({'error': f'数据库更新失败: {str(e)}'}), 500
            
    except Exception as e:
        logging.error(f"更新服务器失败: {str(e)}")
        if 'server' in locals() and db.session.is_active:
            db.session.rollback()
        return jsonify({'error': str(e)}), 500 