import os
from cryptography.fernet import Fernet

# 使用绝对路径
KEY_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'encryption.key')

def get_or_create_key():
    """获取或创建加密密钥"""
    if os.path.exists(KEY_FILE):
        with open(KEY_FILE, 'rb') as f:
            return f.read()
    else:
        key = Fernet.generate_key()
        with open(KEY_FILE, 'wb') as f:
            f.write(key)
        return key

# 创建全局加密套件实例
cipher_suite = Fernet(get_or_create_key()) 