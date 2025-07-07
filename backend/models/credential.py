from backend.extensions import db
from backend.utils.crypto import cipher_suite
import base64

class Credential(db.Model):
    """凭据管理模型，用于存储预设的账号密码"""
    __tablename__ = 'credentials'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)  # 凭据名称
    username = db.Column(db.String(100), nullable=False)  # 用户名
    password = db.Column(db.String(500), nullable=False)  # 加密后的密码
    description = db.Column(db.Text, nullable=True)  # 描述信息
    
    # 与此凭据相关联的服务器
    servers = db.relationship('Server', backref='credential', lazy='dynamic')
    
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