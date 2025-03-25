"""
添加用户日志表的迁移脚本
"""
from sqlalchemy import create_engine, text, MetaData
from backend.config import DATABASE_URI
import logging
from backend.models.userlog import UserLog
from sqlalchemy.schema import CreateTable

def migrate():
    try:
        # 连接到数据库
        engine = create_engine(DATABASE_URI)
        conn = engine.connect()
        
        # 检查表是否已存在
        result = conn.execute(text("SHOW TABLES LIKE 'user_logs'"))
        if result.fetchone():
            logging.info("用户日志表已存在，跳过创建")
            conn.close()
            return
        
        # 创建用户日志表
        metadata = MetaData()
        metadata.reflect(bind=engine)
        
        if 'user_logs' not in metadata.tables:
            # 使用模型的__table__属性获取表定义
            create_table_stmt = CreateTable(UserLog.__table__)
            conn.execute(create_table_stmt)
            logging.info("成功创建用户日志表")
        
        # 关闭连接
        conn.close()
        
    except Exception as e:
        logging.error(f"创建用户日志表时出错: {str(e)}")
        raise

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    migrate() 