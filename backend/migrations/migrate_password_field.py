from backend.models import Server
from backend.extensions import db
from backend.app import create_app

def migrate_password_field():
    app = create_app()
    with app.app_context():
        servers = Server.query.all()
        for server in servers:
            # 从旧字段迁移到新字段
            if hasattr(server, 'password') and server.password:
                server.password_encrypted = server.password
            # 或者从新字段迁移到旧字段
            if hasattr(server, 'password_encrypted') and server.password_encrypted:
                server.password = server.password_encrypted
        db.session.commit()

if __name__ == "__main__":
    migrate_password_field() 