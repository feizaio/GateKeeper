from backend.extensions import db
from datetime import datetime
from backend.database import Base
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
def local_now():
    return datetime.now()
# 使用Base.metadata作为元数据
class UserLog(db.Model):
    __tablename__ = 'user_logs'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    username = db.Column(db.String(64), nullable=True)
    action = db.Column(db.String(32), nullable=False)  # login, logout, connect, disconnect
    server_id = db.Column(db.Integer, db.ForeignKey('servers.id'), nullable=True)
    server_name = db.Column(db.String(128), nullable=True)
    server_ip = db.Column(db.String(64), nullable=True)
    client_ip = db.Column(db.String(64), nullable=True)
    details = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=local_now)
    
    # 关系
    user = db.relationship('User', backref=db.backref('logs', lazy='dynamic'))
    server = db.relationship('Server', backref=db.backref('logs', lazy='dynamic')) 