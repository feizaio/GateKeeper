from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime
import base64
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

# 创建一个简单的加密密钥
def get_encryption_key():
    # 在实际应用中，应该从安全的地方获取密钥
    # 这里使用一个固定的密钥仅作为示例
    password = b"your-secure-password"
    salt = b"your-salt-value"
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
    )
    key = base64.urlsafe_b64encode(kdf.derive(password))
    return key

# 加密函数
def encrypt_password(password):
    if not password:
        return None
    key = get_encryption_key()
    f = Fernet(key)
    encrypted_password = f.encrypt(password.encode())
    return encrypted_password.decode()

# 解密函数
def decrypt_password(encrypted_password):
    if not encrypted_password:
        return None
    key = get_encryption_key()
    f = Fernet(key)
    try:
        decrypted_password = f.decrypt(encrypted_password.encode())
        return decrypted_password.decode()
    except Exception as e:
        print(f"解密失败: {e}")
        return None

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    username = Column(String(64), unique=True, nullable=False)
    # 使用 Text 类型，不限制长度
    password_hash = Column(Text, nullable=False)
    # 如果之前是 Text，可能需要指定长度
    email = Column(String(120), unique=True, nullable=False)
    # ... 现有代码 ...

class Server(Base):
    __tablename__ = 'servers'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    ip = Column(String(64), nullable=False)
    port = Column(Integer, default=22)
    type = Column(String(32), nullable=False)  # Windows 或 Linux
    username = Column(String(64), nullable=False)
    # 使用 password 作为字段名，而不是 password_encrypted
    password = Column(Text)
    category_id = Column(Integer, ForeignKey('categories.id'))
    in_use_by = Column(Integer, ForeignKey('users.id'), nullable=True)
    last_active = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, onupdate=datetime.utcnow)
    
    # 关系
    category = relationship('Category', back_populates='servers')
    
    # 密码加密和解密方法
    def set_password(self, password):
        # 加密密码
        self.password = encrypt_password(password)
    
    def get_password(self):
        # 解密密码
        if self.password:
            return decrypt_password(self.password)
        return None

class Category(Base):
    __tablename__ = 'categories'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(64), nullable=False, unique=True)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, onupdate=datetime.utcnow)
    
    # 关系
    servers = relationship('Server', back_populates='category')

# ... 其他模型 ... 