from backend.extensions import db
from werkzeug.security import generate_password_hash, check_password_hash
from flask import current_app
import jwt  # 标准的 PyJWT 导入
from datetime import datetime, timedelta

class User(db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    is_admin = db.Column(db.Boolean, default=False)
    
    # 服务器关系 - 多对多
    managed_servers = db.relationship(
        'Server',
        secondary='server_users',
        lazy='dynamic'
    )
    
    # 当前使用的服务器 - 一对多
    active_servers = db.relationship(
        'Server',
        primaryjoin='User.id == Server.in_use_by',
        lazy='dynamic'
    )
    
    # 服务关系通过 service.py 中的 service_permissions 定义
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
        
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    # 新增的权限判断方法
    def can_manage_services(self):
        """判断用户是否可以管理服务页面，管理员或有服务管理权限的用户返回True"""
        return self.is_admin or self.has_service_permission()
    
    def has_service_permission(self):
        """判断用户是否有任何服务页面权限"""
        # 由于这是多对多关系，使用count()判断是否至少有一个关联
        return self.authorized_services.count() > 0
    
    def can_access_service(self, service):
        """判断用户是否有权限访问某个服务页面"""
        # 管理员、服务创建者、公共服务或被授权用户可以访问
        return (self.is_admin or 
                self.id == service.user_id or 
                service.is_public or 
                service.authorized_users.filter_by(id=self.id).first() is not None)
    
    def can_edit_service(self, service):
        """判断用户是否有权限编辑某个服务页面"""
        # 管理员、服务创建者或有编辑权限的用户可以编辑
        if self.is_admin or self.id == service.user_id:
            return True
        
        # 检查是否有编辑权限
        from backend.models.service import service_permissions
        permission = db.session.query(service_permissions).filter(
            service_permissions.c.user_id == self.id,
            service_permissions.c.service_id == service.id,
            service_permissions.c.can_edit == True
        ).first()
        
        return permission is not None
    
    def can_delete_service(self, service):
        """判断用户是否有权限删除某个服务页面"""
        # 管理员、服务创建者或有删除权限的用户可以删除
        if self.is_admin or self.id == service.user_id:
            return True
        
        # 检查是否有删除权限
        from backend.models.service import service_permissions
        permission = db.session.query(service_permissions).filter(
            service_permissions.c.user_id == self.id,
            service_permissions.c.service_id == service.id,
            service_permissions.c.can_delete == True
        ).first()
        
        return permission is not None
