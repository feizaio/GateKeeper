# 替换 SQLite 配置
# DATABASE_URI = 'sqlite:///bastion.db'

# MySQL 8 配置
DATABASE_URI = 'mysql+pymysql://root:TxOZxIjO6tqavTw8@10.16.30.200:13306/gatekeeper'

class Config:
    """应用配置类"""
    SQLALCHEMY_DATABASE_URI = DATABASE_URI
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'your-secret-key'
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_recycle': 3600,
        'pool_pre_ping': True
    }
    SESSION_COOKIE_SAMESITE = 'Lax'
    SESSION_COOKIE_SECURE = False 