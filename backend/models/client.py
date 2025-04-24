from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime
from backend.extensions import db

class Client(db.Model):
    """客户端信息模型，用于存储已注册的堡垒机客户端信息"""
    __tablename__ = 'clients'
    
    id = Column(Integer, primary_key=True)
    ip = Column(String(64), nullable=False, index=True)
    port = Column(Integer, nullable=False)
    version = Column(String(32), nullable=True)
    hostname = Column(String(128), nullable=True)
    os_version = Column(String(64), nullable=True)
    mac_address = Column(String(64), nullable=True)
    last_seen = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f'<Client {self.ip}:{self.port}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'ip': self.ip,
            'port': self.port,
            'version': self.version,
            'hostname': self.hostname,
            'os_version': self.os_version,
            'mac_address': self.mac_address,
            'last_seen': self.last_seen.isoformat() if self.last_seen else None,
            'created_at': self.created_at.isoformat() if self.created_at else None
        } 