import sqlite3
import pymysql
from backend.config import DATABASE_URI

def migrate_data():
    # 连接SQLite数据库
    sqlite_conn = sqlite3.connect('bastion.db')
    sqlite_cursor = sqlite_conn.cursor()
    
    # 解析MySQL连接信息
    # 格式: mysql+pymysql://username:password@localhost:3306/bastion
    db_uri = DATABASE_URI.replace('mysql+pymysql://', '')
    db_info = db_uri.split('@')
    
    username = 'root'
    password = 'TxOZxIjO6tqavTw8'
    host = '10.16.30.200'
    port = 13306
    database = 'gatekeeper'
    
    # 连接MySQL数据库
    mysql_conn = pymysql.connect(
        host=host,
        port=port,
        user=username,
        password=password,
        database=database
    )
    mysql_cursor = mysql_conn.cursor()
    
    # 获取所有表
    sqlite_cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = sqlite_cursor.fetchall()
    
    for table in tables:
        table_name = table[0]
        print(f"迁移表: {table_name}")
        
        # 获取表结构
        sqlite_cursor.execute(f"PRAGMA table_info({table_name})")
        columns = sqlite_cursor.fetchall()
        column_names = [column[1] for column in columns]
        
        # 获取数据
        sqlite_cursor.execute(f"SELECT * FROM {table_name}")
        rows = sqlite_cursor.fetchall()
        
        # 插入数据到MySQL
        for row in rows:
            placeholders = ', '.join(['%s'] * len(row))
            columns_str = ', '.join(column_names)
            sql = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders})"
            mysql_cursor.execute(sql, row)
    
    # 提交更改
    mysql_conn.commit()
    
    # 关闭连接
    sqlite_cursor.close()
    sqlite_conn.close()
    mysql_cursor.close()
    mysql_conn.close()
    
    print("数据迁移完成")

if __name__ == "__main__":
    migrate_data() 