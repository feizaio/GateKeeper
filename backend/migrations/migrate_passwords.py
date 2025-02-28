from backend import app, db
from backend.models import Server
from backend.utils.crypto import cipher_suite

def migrate_passwords():
    """迁移现有密码到新的加密系统"""
    with app.app_context():
        servers = Server.query.all()
        for server in servers:
            if server.encrypted_password:
                try:
                    # 尝试解密
                    password = server.get_password()
                    # 重新加密
                    server.set_password(password)
                except:
                    print(f"Failed to migrate password for server {server.name}")
        db.session.commit()

if __name__ == '__main__':
    migrate_passwords() 