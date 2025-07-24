from backend.extensions import db

# 定义用户和服务器的多对多关系表
server_users = db.Table('server_users',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'), primary_key=True),
    db.Column('server_id', db.Integer, db.ForeignKey('servers.id', ondelete='CASCADE'), primary_key=True)
)

# 导入模型类
from backend.models.user import User
from backend.models.server import Server
from backend.models.client import Client
from backend.models.credential import Credential
from backend.models.category import Category
from backend.models.userlog import UserLog
from backend.models.service import Service