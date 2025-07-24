from flask import Blueprint, request, jsonify, g, session
from backend.models.task import TaskView, Task
from backend.models.user import User
from backend.extensions import db
from functools import wraps
import logging

task_view_bp = Blueprint('task_view', __name__)

def login_required(f):
    """登录验证装饰器"""
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

def admin_required(f):
    """管理员权限验证装饰器"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not hasattr(g, 'current_user') or not g.current_user.is_admin:
            return jsonify({'error': 'Admin privileges required'}), 403
        return f(*args, **kwargs)
    return decorated_function

@task_view_bp.route('/task-views', methods=['GET'])
@login_required
def get_task_views():
    """获取任务视图列表"""
    try:
        user = g.current_user
        
        # 管理员可以看到所有视图
        if user.is_admin:
            views = TaskView.query.all()
        else:
            # 普通用户只能看到自己创建的视图
            views = TaskView.query.filter_by(user_id=user.id).all()
        
        return jsonify([view.to_dict() for view in views])
    except Exception as e:
        logging.error(f"获取任务视图列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_view_bp.route('/task-views', methods=['POST'])
@login_required
def create_task_view():
    """创建新的任务视图"""
    try:
        data = request.get_json()
        
        if not data or not data.get('name'):
            return jsonify({'error': '视图名称为必填项'}), 400
            
        new_view = TaskView(
            name=data.get('name'),
            description=data.get('description', ''),
            user_id=g.current_user.id
        )
        
        db.session.add(new_view)
        db.session.commit()
        
        return jsonify(new_view.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        logging.error(f"创建任务视图失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_view_bp.route('/task-views/<int:view_id>', methods=['GET'])
@login_required
def get_task_view(view_id):
    """获取单个任务视图详情"""
    try:
        view = TaskView.query.get(view_id)
        
        if not view:
            return jsonify({'error': '任务视图不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != view.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        return jsonify(view.to_dict())
    except Exception as e:
        logging.error(f"获取任务视图详情失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_view_bp.route('/task-views/<int:view_id>', methods=['PUT'])
@login_required
def update_task_view(view_id):
    """更新任务视图"""
    try:
        view = TaskView.query.get(view_id)
        
        if not view:
            return jsonify({'error': '任务视图不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != view.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        data = request.get_json()
        
        if 'name' in data:
            view.name = data['name']
        if 'description' in data:
            view.description = data['description']
        
        db.session.commit()
        
        return jsonify(view.to_dict())
    except Exception as e:
        db.session.rollback()
        logging.error(f"更新任务视图失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_view_bp.route('/task-views/<int:view_id>', methods=['DELETE'])
@login_required
def delete_task_view(view_id):
    """删除任务视图"""
    try:
        view = TaskView.query.get(view_id)
        
        if not view:
            return jsonify({'error': '任务视图不存在'}), 404
            
        # 检查删除权限
        user = g.current_user
        if not user.is_admin and user.id != view.user_id:
            return jsonify({'error': '权限不足'}), 403
        
        # 将属于该视图的任务的view_id设为NULL
        Task.query.filter_by(view_id=view_id).update({'view_id': None})
            
        db.session.delete(view)
        db.session.commit()
        
        return jsonify({'message': '任务视图删除成功'}), 200
    except Exception as e:
        db.session.rollback()
        logging.error(f"删除任务视图失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_view_bp.route('/task-views/<int:view_id>/tasks', methods=['GET'])
@login_required
def get_tasks_by_view(view_id):
    """获取视图下的所有任务"""
    try:
        view = TaskView.query.get(view_id)
        
        if not view:
            return jsonify({'error': '任务视图不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != view.user_id:
            return jsonify({'error': '权限不足'}), 403
        
        tasks = view.tasks.all()
        
        return jsonify([task.to_dict() for task in tasks])
    except Exception as e:
        logging.error(f"获取视图任务列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500 