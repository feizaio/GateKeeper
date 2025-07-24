from flask import Blueprint, request, jsonify, g, session
from backend.models.service import Service, service_permissions
from backend.models.user import User
from backend.extensions import db
from functools import wraps

service_bp = Blueprint('service', __name__)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return jsonify({'error': 'Unauthorized'}), 401
        user = User.query.get(session['user_id'])
        if not user:
            return jsonify({'error': 'User not found'}), 401
        g.current_user = user
        return f(*args, **kwargs)
    return decorated_function

@service_bp.route('/services', methods=['GET'])
@login_required
def get_services():
    """获取当前用户可访问的服务页面列表"""
    try:
        user = g.current_user
        
        # 管理员可以看到所有服务
        if user.is_admin:
            services = Service.query.all()
        else:
            # 获取用户创建的服务
            own_services = Service.query.filter_by(user_id=user.id).all()
            
            # 获取公共服务
            public_services = Service.query.filter_by(is_public=True).all()
            
            # 获取被授权的服务
            authorized_services = user.authorized_services.all()
            
            # 合并结果并去重
            service_ids = set()
            services = []
            
            for service in own_services + public_services + authorized_services:
                if service.id not in service_ids:
                    service_ids.add(service.id)
                    services.append(service)
                    
        return jsonify([service.to_dict() for service in services])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services', methods=['POST'])
@login_required
def create_service():
    """创建新的服务页面"""
    try:
        data = request.get_json()
        
        if not data or not data.get('url'):
            return jsonify({'error': 'URL is required'}), 400
            
        new_service = Service(
            title=data.get('title', ''),
            url=data.get('url'),
            user_id=g.current_user.id,
            is_public=data.get('is_public', False)
        )
        
        db.session.add(new_service)
        db.session.commit()
        
        return jsonify(new_service.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services/<int:service_id>', methods=['GET'])
@login_required
def get_service(service_id):
    """获取单个服务页面详情"""
    try:
        service = Service.query.get(service_id)
        
        if not service:
            return jsonify({'error': 'Service not found'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.can_access_service(service):
            return jsonify({'error': 'Permission denied'}), 403
            
        return jsonify(service.to_dict())
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services/<int:service_id>', methods=['PUT'])
@login_required
def update_service(service_id):
    """更新服务页面"""
    try:
        service = Service.query.get(service_id)
        
        if not service:
            return jsonify({'error': 'Service not found'}), 404
            
        # 检查编辑权限
        user = g.current_user
        if not user.can_edit_service(service):
            return jsonify({'error': 'Permission denied'}), 403
            
        data = request.get_json()
        
        if 'title' in data:
            service.title = data['title']
        if 'url' in data:
            service.url = data['url']
        if 'is_public' in data and (user.is_admin or user.id == service.user_id):
            service.is_public = data['is_public']
            
        db.session.commit()
        
        return jsonify(service.to_dict())
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services/<int:service_id>', methods=['DELETE'])
@login_required
def delete_service(service_id):
    """删除服务页面"""
    try:
        service = Service.query.get(service_id)
        
        if not service:
            return jsonify({'error': 'Service not found'}), 404
            
        # 检查删除权限
        user = g.current_user
        if not user.can_delete_service(service):
            return jsonify({'error': 'Permission denied'}), 403
            
        db.session.delete(service)
        db.session.commit()
        
        return jsonify({'message': 'Service deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services/<int:service_id>/permissions', methods=['GET'])
@login_required
def get_service_permissions(service_id):
    """获取服务的权限设置"""
    try:
        service = Service.query.get(service_id)
        
        if not service:
            return jsonify({'error': 'Service not found'}), 404
            
        # 只有管理员和服务创建者可以查看权限
        user = g.current_user
        if not user.is_admin and user.id != service.user_id:
            return jsonify({'error': 'Permission denied'}), 403
            
        # 查询拥有此服务权限的用户
        result = db.session.query(
            User, 
            service_permissions.c.can_view,
            service_permissions.c.can_edit,
            service_permissions.c.can_delete
        ).join(
            service_permissions, 
            User.id == service_permissions.c.user_id
        ).filter(
            service_permissions.c.service_id == service_id
        ).all()
        
        permissions = []
        for user, can_view, can_edit, can_delete in result:
            permissions.append({
                'user_id': user.id,
                'username': user.username,
                'can_view': can_view,
                'can_edit': can_edit,
                'can_delete': can_delete
            })
            
        return jsonify({
            'is_public': service.is_public,
            'permissions': permissions
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@service_bp.route('/services/<int:service_id>/permissions', methods=['POST'])
@login_required
def update_service_permissions(service_id):
    """更新服务的权限设置"""
    try:
        service = Service.query.get(service_id)
        
        if not service:
            return jsonify({'error': 'Service not found'}), 404
            
        # 只有管理员和服务创建者可以设置权限
        user = g.current_user
        if not user.is_admin and user.id != service.user_id:
            return jsonify({'error': 'Permission denied'}), 403
            
        data = request.get_json()
        
        # 更新公共访问设置
        if 'is_public' in data:
            service.is_public = data['is_public']
            
        # 更新用户权限
        if 'permissions' in data:
            for perm in data['permissions']:
                user_id = perm.get('user_id')
                if not user_id:
                    continue
                    
                # 检查用户是否存在
                target_user = User.query.get(user_id)
                if not target_user:
                    continue
                    
                # 先删除现有权限
                db.session.execute(
                    service_permissions.delete().where(
                        (service_permissions.c.user_id == user_id) & 
                        (service_permissions.c.service_id == service_id)
                    )
                )
                
                # 如果至少有一个权限为True，则添加新权限
                if perm.get('can_view') or perm.get('can_edit') or perm.get('can_delete'):
                    db.session.execute(
                        service_permissions.insert().values(
                            user_id=user_id,
                            service_id=service_id,
                            can_view=perm.get('can_view', True),
                            can_edit=perm.get('can_edit', False),
                            can_delete=perm.get('can_delete', False)
                        )
                    )
            
        db.session.commit()
        return jsonify({'message': 'Permissions updated successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@service_bp.route('/users', methods=['GET'])
@login_required
def get_users_for_permissions():
    """获取用户列表，用于设置权限"""
    try:
        # 只有管理员可以查看所有用户，普通用户只能看到自己
        user = g.current_user
        if user.is_admin:
            users = User.query.all()
        else:
            users = [user]
            
        return jsonify([{
            'id': u.id,
            'username': u.username,
            'is_admin': u.is_admin
        } for u in users])
    except Exception as e:
        return jsonify({'error': str(e)}), 500 