from flask import Flask, request, jsonify, g, session
from flask_migrate import Migrate
from flask_cors import CORS  # 添加 CORS 支持
from .extensions import db
from .models import server_users  # 导入关联表
from .models.user import User
from .models.server import Server

from .routes.server import server_bp
from .routes.auth import auth_bp


def create_app(config=None):
    app = Flask(__name__)
    
    # 配置数据库
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///fortress.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = 'your-secret-key'  # 确保设置了 SECRET_KEY
    
    # 启用 CORS
    CORS(app)
    
    # 初始化扩展
    db.init_app(app)
    migrate = Migrate(app, db)
    
    # 注册蓝图
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(server_bp, url_prefix='/api/servers')

    # 添加调试日志
    @app.before_request
    def log_request():
        app.logger.info(f"请求: {request.method} {request.path}")


    
    # 全局错误处理
    @app.errorhandler(Exception)
    def handle_exception(e):
        app.logger.error(f"发生错误: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
    # 创建数据库表
    with app.app_context():
        db.create_all()
    
    # 初始化客户端连接存储
    app.connected_clients = {}
    
    return app