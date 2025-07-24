from sqlalchemy import Table, Column, Integer, String, Text, Boolean, DateTime, ForeignKey, MetaData
from datetime import datetime

# 定义元数据
metadata = MetaData()

# 定义任务视图表
task_views = Table(
    'task_views',
    metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String(100), nullable=False),
    Column('description', Text, nullable=True),
    Column('user_id', Integer, ForeignKey('users.id'), nullable=False),
    Column('created_at', DateTime, default=datetime.utcnow),
    Column('updated_at', DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
)

def upgrade(migrate_engine):
    """升级数据库"""
    metadata.bind = migrate_engine
    
    # 创建任务视图表
    task_views.create()
    
    # 添加view_id列到tasks表
    migrate_engine.execute('ALTER TABLE tasks ADD COLUMN view_id INTEGER')
    migrate_engine.execute('ALTER TABLE tasks ADD FOREIGN KEY (view_id) REFERENCES task_views(id)')
    
    print("成功创建任务视图表并更新任务表")

def downgrade(migrate_engine):
    """降级数据库"""
    metadata.bind = migrate_engine
    
    # 删除tasks表中的view_id列
    migrate_engine.execute('ALTER TABLE tasks DROP FOREIGN KEY tasks_ibfk_3')  # 假设这是外键约束的名称
    migrate_engine.execute('ALTER TABLE tasks DROP COLUMN view_id')
    
    # 删除任务视图表
    task_views.drop()
    
    print("成功删除任务视图表并恢复任务表") 