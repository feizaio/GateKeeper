import sys
from pathlib import Path
from flask import Flask, jsonify
from flask_cors import CORS
from flask_migrate import Migrate
import os
import time
import psutil
import logging

# 将项目根目录添加到 sys.path
sys.path.append(str(Path(__file__).parent.parent))

# 初始化扩展
from backend.extensions import db, socketio
from backend.utils.monitor import ServerMonitor
from backend.routes.auth import auth_bp  # 导入 auth_bp

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    # 使用绝对路径
    db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fortress.db')
    key_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'encryption.key')
    
    # 如果数据库文件不存在，则创建新的数据库
    need_init_db = not os.path.exists(db_path)
    
    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{db_path}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = 'your-secret-key'

    # 初始化扩展
    db.init_app(app)
    socketio.init_app(app, cors_allowed_origins="*")

    from backend.models import User, Server
    
    # 注册蓝图
    from backend.routes.auth import auth_bp
    from backend.routes.servers import servers_bp
    from backend.routes.remote import remote_bp
    from backend.routes.users import users_bp
    from backend.routes.agent import agent_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(servers_bp, url_prefix='/api')
    app.register_blueprint(remote_bp, url_prefix='/api')
    app.register_blueprint(users_bp, url_prefix='/api')
    app.register_blueprint(agent_bp, url_prefix='/api')

    # 注册 before_request 钩子
    #app.before_request(auth_bp.before_request)

    # 创建数据库表
    with app.app_context():
        if need_init_db:
            db.create_all()
            # 创建初始管理员账号
            admin = User.query.filter_by(username='admin').first()
            if not admin:
                admin = User(username='admin', is_admin=True)
                admin.set_password('admin')
                db.session.add(admin)
                db.session.commit()

    # 初始化客户端连接存储
    app.connected_clients = {}

    @app.route('/', defaults={'path': ''})
    @app.route('/<path:path>')
    def catch_all(path):
        return app.send_static_file('index.html')

    @app.errorhandler(Exception)
    def handle_exception(e):
        """全局错误处理"""
        logging.error(f"发生错误: {str(e)}")
        return jsonify({"error": str(e)}), 500

    return app

# 创建应用实例
app = create_app()

# 创建并启动监控器
monitor = ServerMonitor(app)
monitor.start()

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)