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
from datetime import datetime, timedelta

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

    from backend.models import User, Server, Client
    from backend.models.userlog import UserLog  # 添加UserLog模型导入
    
    # 注册蓝图
    from backend.routes.auth import auth_bp
    from backend.routes.servers import servers_bp
    from backend.routes.remote import remote_bp
    from backend.routes.users import users_bp
    from backend.routes.agent import agent_bp
    from backend.routes.category import category_bp
    from backend.routes.server import server_bp
    from backend.routes.credential import credential_bp
    from backend.routes.dashboard import dashboard_bp
    from backend.routes.service import service_bp
    from backend.routes.task import task_bp
    from backend.routes.task_view import task_view_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(servers_bp, url_prefix='/api')
    app.register_blueprint(remote_bp, url_prefix='/api')
    app.register_blueprint(users_bp, url_prefix='/api')
    app.register_blueprint(agent_bp, url_prefix='/api')
    app.register_blueprint(category_bp, url_prefix='/api/categories')
    app.register_blueprint(server_bp, url_prefix='/api/servers')
    app.register_blueprint(credential_bp, url_prefix='/api')
    app.register_blueprint(dashboard_bp, url_prefix='/api/dashboard')
    app.register_blueprint(service_bp, url_prefix='/api')
    app.register_blueprint(task_bp, url_prefix='/api')
    app.register_blueprint(task_view_bp, url_prefix='/api')

    # 注册请求前处理函数
    @app.before_request
    def before_request():
        # 设置全局用户对象
        from flask import g, session
        if 'user_id' in session:
            g.current_user = User.query.get(session['user_id'])
        else:
            g.current_user = None

    # 注册请求后处理函数
    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db_session.remove()

    # 全局错误处理
    @app.errorhandler(Exception)
    def handle_exception(e):
        app.logger.error(f"发生错误: {str(e)}")
        return jsonify({"error": str(e)}), 500

    return app

# 创建应用实例
app = create_app()

# 创建并启动监控器
monitor = ServerMonitor(app)
monitor.start()

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)