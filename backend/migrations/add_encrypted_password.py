from flask import current_app
from backend import db
from alembic import op
import sqlalchemy as sa

def upgrade():
    # 添加新列
    op.add_column('server', sa.Column('encrypted_password', sa.String(500), nullable=True))
    
    # 如果需要，可以在这里添加数据迁移逻辑
    
def downgrade():
    op.drop_column('server', 'encrypted_password') 