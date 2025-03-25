import sys
from pathlib import Path
from flask import Flask, jsonify
from flask_cors import CORS
from flask_migrate import Migrate
import os
import time
import psutil
import logging
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import inspect

# 将项目根目录添加到 sys.path
sys.path.append(str(Path(__file__).parent.parent))

# 初始化扩展
from backend.extensions import db, socketio
from backend.utils.monitor import ServerMonitor
from backend.routes.auth import auth_bp  # 导入 auth_bp
from backend.database import init_db, db_session

# 从配置文件导入数据库 URI
from backend.config import DATABASE_URI

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def create_app():
    app = Flask(__name__)
    CORS(app, supports_credentials=True)
    
    # 从配置文件导入数据库 URI
    from backend.config import DATABASE_URI
    
    # 设置数据库配置
    app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URI
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
        'pool_recycle': 3600,
        'pool_pre_ping': True
    }
    app.config['SECRET_KEY'] = 'your-secret-key'
    app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
    app.config['SESSION_COOKIE_SECURE'] = False

    # 初始化扩展
    db.init_app(app)
    socketio.init_app(app, cors_allowed_origins="*")

    from backend.models import User, Server
    from backend.models.userlog import UserLog  # 添加UserLog模型导入
    
    # 注册蓝图
    from backend.routes.auth import auth_bp
    from backend.routes.servers import servers_bp
    from backend.routes.remote import remote_bp
    from backend.routes.users import users_bp
    from backend.routes.agent import agent_bp
    from backend.routes.category import category_bp
    from backend.routes.server import server_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(servers_bp, url_prefix='/api')
    app.register_blueprint(remote_bp, url_prefix='/api')
    app.register_blueprint(users_bp, url_prefix='/api')
    app.register_blueprint(agent_bp, url_prefix='/api')
    app.register_blueprint(category_bp, url_prefix='/api/categories')
    app.register_blueprint(server_bp, url_prefix='/api/servers')

    # 注册 before_request 钩子
    #app.before_request(auth_bp.before_request)

    # 创建数据库表
    with app.app_context():
        # 只创建不存在的表，不删除现有表
        db.create_all()
        
        # 创建初始管理员账号（如果不存在）
        admin = User.query.filter_by(username='admin').first()
        if not admin:
            admin = User(username='admin', is_admin=True)
            admin.set_password('admin')
            db.session.add(admin)
            db.session.commit()

    # 初始化客户端连接存储
    app.connected_clients = {}

    # 初始化数据库
    init_db()
    
    # 执行迁移脚本
    try:
        from backend.migrations.add_user_logs_table import migrate as migrate_user_logs
        migrate_user_logs()
        logging.info("用户日志表迁移完成")
    except Exception as e:
        logging.error(f"执行用户日志表迁移脚本时出错: {str(e)}")

    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db_session.remove()

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