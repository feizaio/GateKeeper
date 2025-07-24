from sqlalchemy import create_engine, Table, Column, Integer, Boolean, DateTime, ForeignKey, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects.mysql import TIMESTAMP
import os
import sys

# 添加项目根目录到系统路径
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from backend.config import DATABASE_URI

def migrate():
    """
    为服务管理添加权限功能：
    1. 添加服务表中的is_public字段
    2. 创建服务权限关联表
    """
    print("开始服务权限数据迁移...")
    
    engine = create_engine(DATABASE_URI)
    
    with engine.begin() as conn:
        # 检查 services 表是否存在
        result = conn.execute(text("SHOW TABLES LIKE 'services'"))
        if result.rowcount == 0:
            print("服务表不存在，跳过迁移")
            return
        
        # 检查 is_public 字段是否存在
        result = conn.execute(text("SHOW COLUMNS FROM services LIKE 'is_public'"))
        if result.rowcount == 0:
            print("添加 is_public 字段到 services 表...")
            conn.execute(text("ALTER TABLE services ADD COLUMN is_public TINYINT(1) NOT NULL DEFAULT 0"))
        
        # 检查 service_permissions 表是否存在
        result = conn.execute(text("SHOW TABLES LIKE 'service_permissions'"))
        if result.rowcount == 0:
            print("创建 service_permissions 表...")
            conn.execute(text("""
                CREATE TABLE service_permissions (
                    user_id INT NOT NULL,
                    service_id INT NOT NULL,
                    can_view TINYINT(1) NOT NULL DEFAULT 1,
                    can_edit TINYINT(1) NOT NULL DEFAULT 0,
                    can_delete TINYINT(1) NOT NULL DEFAULT 0,
                    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY (user_id, service_id),
                    CONSTRAINT service_permissions_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
                    CONSTRAINT service_permissions_ibfk_2 FOREIGN KEY (service_id) REFERENCES services (id) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            """))
    
    print("服务权限数据迁移完成")

if __name__ == "__main__":
    migrate() 