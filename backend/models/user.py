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
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
        
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
