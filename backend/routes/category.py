from flask import Blueprint, request, jsonify, g, session
from backend.models.category import Category
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from datetime import datetime
from functools import wraps
import logging

category_bp = Blueprint('category', __name__)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return jsonify({'error': 'Unauthorized'}), 401
        user = User.query.get(session['user_id'])
        if not user:
            return jsonify({'error': 'User not found'}), 401
        g.current_user = user
        return f(*args, **kwargs)
    return decorated_function

@category_bp.route('/')
@login_required
def get_categories():
    """获取分类列表"""
    try:
        categories = Category.query.all()
        return jsonify([category.to_dict() for category in categories])
    except Exception as e:
        logging.error(f"获取分类列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@category_bp.route('/', methods=['POST'])
@login_required
def add_category():
    """添加分类"""
    try:
        data = request.get_json()
        category = Category(
            name=data['name'],
            description=data.get('description', '')
        )
        db.session.add(category)
        db.session.commit()
        return jsonify(category.to_dict())
    except Exception as e:
        logging.error(f"添加分类失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@category_bp.route('/<int:category_id>', methods=['PUT'])
@login_required
def update_category(category_id):
    """更新分类"""
    try:
        category = Category.query.get_or_404(category_id)
        data = request.get_json()
        
        if 'name' in data:
            category.name = data['name']
        if 'description' in data:
            category.description = data['description']
            
        db.session.commit()
        return jsonify(category.to_dict())
    except Exception as e:
        logging.error(f"更新分类失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@category_bp.route('/<int:category_id>', methods=['DELETE'])
@login_required
def delete_category(category_id):
    """删除分类"""
    try:
        category = Category.query.get_or_404(category_id)
        db.session.delete(category)
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        logging.error(f"删除分类失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@category_bp.route('/<int:category_id>/servers', methods=['PUT'])
@login_required
def update_category_servers(category_id):
    """更新分类下的服务器"""
    try:
        category = Category.query.get_or_404(category_id)
        data = request.get_json()
        server_ids = data.get('server_ids', [])
        
        # 更新所有相关服务器的 category_id
        # 先清除所有属于该分类的服务器
        Server.query.filter_by(category_id=category_id).update({'category_id': None})
        
        # 设置新的分类关系
        for server_id in server_ids:
            server = Server.query.get(server_id)
            if server:
                server.category_id = category_id
                
        db.session.commit()
        return jsonify({'message': '更新成功'})
    except Exception as e:
        logging.error(f"更新分类服务器失败: {str(e)}")
        db.session.rollback()
        return jsonify({'error': str(e)}), 500 