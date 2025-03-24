from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base
from backend.config import DATABASE_URI

engine = create_engine(
    DATABASE_URI,
    pool_size=10,  # 连接池大小
    max_overflow=20,  # 最大溢出连接数
    pool_recycle=3600,  # 连接回收时间（秒）
    pool_pre_ping=True  # 连接前ping测试
)

db_session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))
Base = declarative_base()
Base.query = db_session.query_property()

def init_db():
    # 导入所有模型，确保它们已注册到Base
    from backend import models
    Base.metadata.create_all(bind=engine) 