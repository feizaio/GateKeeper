from backend.extensions import db
from datetime import datetime

# 定义用户和服务的多对多关系表
service_permissions = db.Table('service_permissions',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'), primary_key=True),
    db.Column('service_id', db.Integer, db.ForeignKey('services.id', ondelete='CASCADE'), primary_key=True),
    db.Column('can_view', db.Boolean, default=True),
    db.Column('can_edit', db.Boolean, default=False),
    db.Column('can_delete', db.Boolean, default=False),
    db.Column('created_at', db.DateTime, default=datetime.utcnow)
)

class Service(db.Model):
    """服务页面模型，用于存储服务管理中的页面信息"""
    __tablename__ = 'services'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=True)
    url = db.Column(db.String(255), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    is_public = db.Column(db.Boolean, default=False)  # 是否为公共服务，所有用户可见
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 与用户的关系
    user = db.relationship('User', backref=db.backref('services', lazy='dynamic'))
    
    # 有权限访问此服务的用户
    authorized_users = db.relationship(
        'User',
        secondary=service_permissions,
        lazy='dynamic',
        backref=db.backref('authorized_services', lazy='dynamic')
    )
    
    def __repr__(self):
        return f'<Service {self.title or self.url}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'title': self.title,
            'url': self.url,
            'user_id': self.user_id,
            'is_public': self.is_public,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        } 