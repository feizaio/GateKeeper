from backend.extensions import db
from backend.models import server_users
from werkzeug.security import generate_password_hash, check_password_hash
from backend.utils.crypto import cipher_suite
from datetime import datetime
from cryptography.fernet import Fernet
import base64
import os

class Server(db.Model):
    __tablename__ = 'servers'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    ip = db.Column(db.String(100), nullable=False)
    port = db.Column(db.Integer, default=22)  # 添加端口字段，默认值为22
    type = db.Column(db.String(50), nullable=False)  # Windows/Linux
    username = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(500), nullable=False)
    in_use_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    last_active = db.Column(db.DateTime, nullable=True)
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id'), nullable=True)
    
    # 管理此服务器的用户 - 多对多
    managers = db.relationship(
        'User',
        secondary='server_users',
        lazy='dynamic',
        overlaps="managed_servers"
    )
    
    # 服务器所属分类
    category = db.relationship('Category', back_populates='servers')
    
    def set_password(self, password):
        """设置加密密码"""
        encrypted = cipher_suite.encrypt(password.encode())
        self.password = base64.b64encode(encrypted).decode()
    
    def get_password(self):
        """获取解密后的密码"""
        try:
            encrypted = base64.b64decode(self.password)
            return cipher_suite.decrypt(encrypted).decode()
        except:
            return None
        
    def check_password(self, password):
        return check_password_hash(self.password_hash, password) 