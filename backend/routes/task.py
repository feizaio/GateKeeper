from flask import Blueprint, request, jsonify, g, session, copy_current_request_context
from backend.models.task import Task, TaskExecution, task_permissions
from backend.models.user import User
from backend.utils.jenkins_client import JenkinsClient
from backend.extensions import db, socketio
from backend.database import engine
from sqlalchemy.orm import sessionmaker, scoped_session
from datetime import datetime
import threading
import time
import logging
from functools import wraps
import urllib.parse
import json
import requests

task_bp = Blueprint('task', __name__)

# 创建独立的会话工厂，用于后台线程
Session = scoped_session(sessionmaker(bind=engine))

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

@task_bp.route('/tasks', methods=['GET'])
@login_required
def get_tasks():
    """获取任务列表"""
    try:
        user = g.current_user
        
        # 管理员可以看到所有任务
        if user.is_admin:
            tasks = Task.query.all()
        else:
            # 获取用户创建的任务
            own_tasks = Task.query.filter_by(user_id=user.id).all()
            
            # 获取被授权的任务
            authorized_tasks = user.authorized_tasks.all()
            
            # 合并结果并去重
            task_ids = set()
            tasks = []
            
            for task in own_tasks + authorized_tasks:
                if task.id not in task_ids:
                    task_ids.add(task.id)
                    tasks.append(task)
        
        # 获取每个任务的最后一次成功执行时间
        task_data = []
        for task in tasks:
            task_dict = task.to_dict()
            
            # 查询最后一次成功执行
            last_success = TaskExecution.query.filter_by(
                task_id=task.id, 
                status='success'
            ).order_by(TaskExecution.end_time.desc()).first()
            
            # 添加上次成功执行时间
            task_dict['last_success_time'] = last_success.end_time.isoformat() if last_success and last_success.end_time else None
            
            task_data.append(task_dict)
                    
        return jsonify(task_data)
    except Exception as e:
        logging.error(f"获取任务列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks', methods=['POST'])
@login_required
def create_task():
    """创建新的任务"""
    try:
        data = request.get_json()
        
        if not data or not data.get('name') or not data.get('task_type'):
            return jsonify({'error': '任务名称和类型为必填项'}), 400
            
        new_task = Task(
            name=data.get('name'),
            description=data.get('description', ''),
            task_type=data.get('task_type'),
            user_id=g.current_user.id,
            is_enabled=data.get('is_enabled', True),
            view_id=data.get('view_id')
        )
        
        # 根据任务类型设置特定字段
        if data.get('task_type') == 'jenkins':
            new_task.jenkins_url = data.get('jenkins_url')
            new_task.jenkins_job_name = data.get('jenkins_job_name')
            new_task.jenkins_username = data.get('jenkins_username')
            new_task.jenkins_api_token = data.get('jenkins_api_token')
            
            # 处理Jenkins参数
            if 'jenkins_parameters' in data:
                new_task.set_jenkins_parameters(data.get('jenkins_parameters'))
                
        elif data.get('task_type') == 'script':
            new_task.script_content = data.get('script_content')
            new_task.script_type = data.get('script_type')
        elif data.get('task_type') == 'command':
            new_task.command = data.get('command')
        
        db.session.add(new_task)
        db.session.commit()
        
        # 如果不是管理员，给当前用户添加查看权限
        user = g.current_user
        if not user.is_admin:
            # 添加查看权限
            db.session.execute(
                task_permissions.insert().values(
                    user_id=user.id,
                    task_id=new_task.id,
                    can_view=True,
                    can_execute=False,
                    can_terminate=False,
                    can_delete=False
                )
            )
            db.session.commit()
        
        return jsonify(new_task.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        logging.error(f"创建任务失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>', methods=['GET'])
@login_required
def get_task(task_id):
    """获取单个任务详情"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id and not user.authorized_tasks.filter_by(id=task_id).first():
            return jsonify({'error': '权限不足'}), 403
            
        return jsonify(task.to_dict())
    except Exception as e:
        logging.error(f"获取任务详情失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>', methods=['PUT'])
@login_required
def update_task(task_id):
    """更新任务"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        data = request.get_json()
        
        if 'name' in data:
            task.name = data['name']
        if 'description' in data:
            task.description = data['description']
        if 'is_enabled' in data:
            task.is_enabled = data['is_enabled']
        if 'view_id' in data:
            task.view_id = data['view_id']
        
        # 根据任务类型更新特定字段
        if task.task_type == 'jenkins':
            if 'jenkins_url' in data:
                task.jenkins_url = data['jenkins_url']
            if 'jenkins_job_name' in data:
                task.jenkins_job_name = data['jenkins_job_name']
            if 'jenkins_username' in data:
                task.jenkins_username = data['jenkins_username']
            if 'jenkins_api_token' in data:
                task.jenkins_api_token = data['jenkins_api_token']
        elif task.task_type == 'script':
            if 'script_content' in data:
                task.script_content = data['script_content']
            if 'script_type' in data:
                task.script_type = data['script_type']
        elif task.task_type == 'command':
            if 'command' in data:
                task.command = data['command']
            
        db.session.commit()
        
        return jsonify(task.to_dict())
    except Exception as e:
        db.session.rollback()
        logging.error(f"更新任务失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>', methods=['DELETE'])
@login_required
def delete_task(task_id):
    """删除任务"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 检查删除权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        db.session.delete(task)
        db.session.commit()
        
        return jsonify({'message': '任务删除成功'}), 200
    except Exception as e:
        db.session.rollback()
        logging.error(f"删除任务失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>/execute', methods=['POST'])
@login_required
def execute_task(task_id):
    """执行任务"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
        
        if not task.is_enabled:
            return jsonify({'error': '任务已禁用'}), 400
            
        # 检查执行权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id:
            # 检查是否有执行权限
            permission = db.session.query(task_permissions).filter_by(
                user_id=user.id, 
                task_id=task_id
            ).first()
            
            if not permission or not permission.can_execute:
                return jsonify({'error': '权限不足'}), 403
        
        # 获取执行参数
        data = request.get_json() or {}
        logging.info(f"收到执行请求数据: {data}")
        
        # 检查参数格式
        execution_params = None
        if 'parameters' in data:
            if isinstance(data['parameters'], dict):
                execution_params = data['parameters']
            elif isinstance(data['parameters'], str) and data['parameters'].strip():
                try:
                    execution_params = json.loads(data['parameters'])
                except:
                    execution_params = {'value': data['parameters']}
            
            logging.info(f"解析到执行参数: {execution_params}")
        
        # 创建执行记录
        execution = TaskExecution(
            task_id=task_id,
            user_id=user.id,
            status='pending'
        )
        
        # 如果是Jenkins任务，存储本次执行的参数
        if task.task_type == 'jenkins' and execution_params:
            execution.set_jenkins_parameters(execution_params)
        
        db.session.add(execution)
        db.session.commit()
        
        # 获取当前应用实例
        from flask import current_app
        app = current_app._get_current_object()
        
        # 获取必要的数据，避免在线程中使用原始对象
        task_id = task.id
        execution_id = execution.id
        
        # 使用独立线程执行任务
        @copy_current_request_context
        def run_task_thread():
            run_task(app, task_id, execution_id, execution_params)
            
        thread = threading.Thread(target=run_task_thread)
        thread.daemon = True
        thread.start()
        
        return jsonify({
            'message': '任务已提交执行',
            'execution_id': execution.id
        })
    except Exception as e:
        db.session.rollback()
        logging.error(f"执行任务失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

def run_task(app, task_id, execution_id, execution_params=None):
    """异步执行任务"""
    # 在线程中创建应用上下文
    with app.app_context():
        # 创建独立的数据库会话
        session = Session()
        
        try:
            # 获取任务和执行记录
            task = session.query(Task).get(task_id)
            execution = session.query(TaskExecution).get(execution_id)
            
            if not task or not execution:
                logging.error(f"找不到任务或执行记录: task_id={task_id}, execution_id={execution_id}")
                return
            
            # 更新状态为运行中
            execution.status = 'running'
            session.commit()
            
            # 根据任务类型执行不同的操作
            if task.task_type == 'jenkins':
                # 创建Jenkins客户端
                client = JenkinsClient(
                    task.jenkins_url,
                    task.jenkins_username,
                    task.jenkins_api_token
                )
                
                # 合并默认参数和执行参数
                build_params = {}
                if task.jenkins_parameters:
                    default_params = task.get_jenkins_parameters()
                    logging.info(f"任务默认参数: {default_params}")
                    build_params.update(default_params)
                
                if execution_params:
                    logging.info(f"执行时传入参数: {execution_params}")
                    build_params.update(execution_params)
                
                # 记录使用的参数
                logging.info(f"执行Jenkins任务，最终参数: {build_params}")
                
                # 如果有参数，保存到执行记录中
                if build_params:
                    execution.set_jenkins_parameters(build_params)
                    session.commit()
                    logging.info(f"已保存执行参数到数据库: {build_params}")
                
                # 检查参数是否为空
                params_to_use = build_params if build_params else None
                logging.info(f"传递给Jenkins的参数: {params_to_use}")
                
                # 触发Jenkins构建
                try:
                    # 检查任务是否需要参数
                    job_params = client.get_job_parameters(task.jenkins_job_name)
                    if job_params and not params_to_use:
                        # 任务需要参数但没有提供
                        logging.warning(f"Jenkins任务需要参数但未提供: {job_params}")
                    
                    # 触发构建
                    build_number, queue_url = client.build_job(task.jenkins_job_name, params_to_use)
                    
                    logging.info(f"Jenkins构建已触发: job={task.jenkins_job_name}, build_number={build_number}, queue_url={queue_url}")
                    
                    if build_number:
                        # 更新执行记录
                        execution.jenkins_build_number = build_number
                        execution.jenkins_build_url = f"{task.jenkins_url}/job/{urllib.parse.quote(task.jenkins_job_name.replace('/', '/job/'))}/{build_number}"
                        session.commit()
                        
                        # 监控构建进度并获取日志
                        monitor_jenkins_build(session, client, task, execution, build_number)
                    else:
                        # 触发失败
                        execution.status = 'failed'
                        execution.result = '触发Jenkins构建失败，无法获取构建号'
                        execution.end_time = datetime.utcnow()
                        session.commit()
                except Exception as e:
                    logging.error(f"触发Jenkins构建失败: {str(e)}")
                    execution.status = 'failed'
                    execution.result = f'触发Jenkins构建失败: {str(e)}'
                    execution.end_time = datetime.utcnow()
                    session.commit()
            
            # 其他类型的任务执行逻辑（脚本、命令等）可以在这里添加
            
        except Exception as e:
            logging.error(f"任务执行过程中出错: {str(e)}")
            try:
                execution.status = 'failed'
                execution.result = f'执行出错: {str(e)}'
                execution.end_time = datetime.utcnow()
                session.commit()
            except Exception as commit_error:
                logging.error(f"更新任务状态失败: {str(commit_error)}")
        finally:
            # 确保会话被关闭
            session.close()

def monitor_jenkins_build(session, client, task, execution, build_number):
    """监控Jenkins构建进度并获取日志
    
    Args:
        session: 数据库会话
        client: JenkinsClient实例
        task: 任务对象
        execution: 执行记录对象
        build_number: 构建号
    """
    try:
        # 初始日志位置
        log_content = ""
        log_size_limit = 1024 * 1024  # 限制日志大小为1MB
        
        # 初始化Socket.IO客户端
        from backend.socket_instance import socketio
        
        # 每隔一段时间检查构建状态和日志
        while True:
            try:
                # 获取构建状态
                status = client.get_build_status(task.jenkins_job_name, build_number)
                
                # 获取最新日志
                new_log = client.get_build_log(task.jenkins_job_name, build_number)
                
                # 如果日志有更新，发送到前端
                if new_log != log_content:
                    log_content = new_log
                    
                    # 如果日志内容过大，截断保存
                    if len(log_content) > log_size_limit:
                        logging.warning(f"日志内容过大({len(log_content)}字节)，将被截断保存到数据库")
                        # 保存截断的日志到数据库
                        truncated_log = log_content[:log_size_limit] + "\n\n... 日志内容过长，已截断 ...\n"
                        execution.log_content = truncated_log
                    else:
                        execution.log_content = log_content
                    
                    try:
                        session.commit()
                    except Exception as commit_error:
                        logging.error(f"保存日志到数据库失败: {str(commit_error)}")
                        session.rollback()
                    
                    # 通过Socket.IO发送日志更新
                    socketio.emit(f'task_log_update_{execution.id}', {
                        'log': log_content
                    })
                
                # 如果构建已完成，更新状态并退出循环
                if status and status != 'BUILDING':
                    if status == 'SUCCESS':
                        execution.status = 'success'
                    else:
                        execution.status = 'failed'
                    
                    execution.result = f'Jenkins构建结果: {status}'
                    execution.end_time = datetime.utcnow()
                    
                    try:
                        session.commit()
                    except Exception as commit_error:
                        logging.error(f"更新执行状态失败: {str(commit_error)}")
                        session.rollback()
                        
                    break
                
                # 等待一段时间再次检查
                time.sleep(5)
            except Exception as e:
                logging.error(f"监控构建过程中出错: {str(e)}")
                time.sleep(5)
    except Exception as e:
        logging.error(f"监控Jenkins构建失败: {str(e)}")
        try:
            execution.status = 'failed'
            execution.result = f'监控构建失败: {str(e)}'
            execution.end_time = datetime.utcnow()
            session.commit()
        except Exception as commit_error:
            logging.error(f"更新执行状态失败: {str(commit_error)}")
            session.rollback()

@task_bp.route('/tasks/<int:task_id>/executions', methods=['GET'])
@login_required
def get_task_executions(task_id):
    """获取任务的执行记录"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 检查权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id and not user.authorized_tasks.filter_by(id=task_id).first():
            return jsonify({'error': '权限不足'}), 403
        
        # 获取执行记录，按时间倒序排列
        executions = TaskExecution.query.filter_by(task_id=task_id).order_by(TaskExecution.start_time.desc()).all()
        
        return jsonify([execution.to_dict() for execution in executions])
    except Exception as e:
        logging.error(f"获取任务执行记录失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/executions/<int:execution_id>', methods=['GET'])
@login_required
def get_execution(execution_id):
    """获取执行记录详情"""
    try:
        execution = TaskExecution.query.get(execution_id)
        
        if not execution:
            return jsonify({'error': '执行记录不存在'}), 404
            
        # 检查权限
        user = g.current_user
        task = Task.query.get(execution.task_id)
        
        if not user.is_admin and user.id != task.user_id and not user.authorized_tasks.filter_by(id=task.id).first():
            return jsonify({'error': '权限不足'}), 403
            
        return jsonify(execution.to_dict())
    except Exception as e:
        logging.error(f"获取执行记录详情失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/executions/<int:execution_id>/log', methods=['GET'])
@login_required
def get_execution_log(execution_id):
    """获取执行记录日志"""
    try:
        execution = TaskExecution.query.get(execution_id)
        
        if not execution:
            return jsonify({'error': '执行记录不存在'}), 404
            
        # 检查权限
        user = g.current_user
        task = Task.query.get(execution.task_id)
        
        if not user.is_admin and user.id != task.user_id and not user.authorized_tasks.filter_by(id=task.id).first():
            return jsonify({'error': '权限不足'}), 403
            
        return jsonify({
            'execution_id': execution.id,
            'log_content': execution.log_content or ''
        })
    except Exception as e:
        logging.error(f"获取执行记录日志失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/executions/<int:execution_id>/terminate', methods=['POST'])
@login_required
def terminate_execution(execution_id):
    """终止任务执行"""
    try:
        execution = TaskExecution.query.get(execution_id)
        
        if not execution:
            return jsonify({'error': '执行记录不存在'}), 404
            
        # 检查是否可以终止
        if execution.status not in ['pending', 'running']:
            return jsonify({'error': '只能终止待执行或执行中的任务'}), 400
            
        # 检查权限
        user = g.current_user
        task = Task.query.get(execution.task_id)
        
        if not user.is_admin and user.id != task.user_id:
            # 检查是否有终止权限
            permission = db.session.query(task_permissions).filter_by(
                user_id=user.id, 
                task_id=task.id
            ).first()
            
            if not permission or not permission.can_terminate:
                return jsonify({'error': '权限不足'}), 403
        
        # 根据任务类型执行不同的终止操作
        if task.task_type == 'jenkins' and execution.jenkins_build_number:
            # 创建Jenkins客户端
            client = JenkinsClient(
                task.jenkins_url,
                task.jenkins_username,
                task.jenkins_api_token
            )
            
            # 停止Jenkins构建
            success = client.stop_build(task.jenkins_job_name, execution.jenkins_build_number)
            
            if not success:
                # 如果API方法失败，尝试直接访问构建URL终止
                try:
                    logging.info("尝试通过直接访问构建URL终止任务")
                    
                    # 构建终止URL
                    job_path = task.jenkins_job_name.replace('/', '/job/')
                    encoded_job_path = urllib.parse.quote(job_path)
                    stop_url = f"{task.jenkins_url}/job/{encoded_job_path}/{execution.jenkins_build_number}/stop"
                    
                    # 发送请求
                    auth = (task.jenkins_username, task.jenkins_api_token) if task.jenkins_username else None
                    response = requests.post(stop_url, auth=auth)
                    
                    if response.status_code < 400:
                        logging.info(f"通过直接访问URL成功终止任务: {stop_url}")
                        success = True
                    else:
                        logging.warning(f"通过直接访问URL终止任务失败: {response.status_code} - {response.text}")
                except Exception as e:
                    logging.error(f"通过直接访问URL终止任务出错: {str(e)}")
                
                if not success:
                    # 即使终止失败，也更新本地状态为已终止
                    logging.warning("无法终止Jenkins构建，但仍将在本地标记为已终止")
        
        # 更新执行记录
        execution.status = 'terminated'
        execution.end_time = datetime.utcnow()
        execution.result = '任务已手动终止' + ('' if success else '（Jenkins构建可能仍在运行）')
        db.session.commit()
        
        # 发送终止通知
        socketio.emit(f'task_complete_{execution.id}', {
            'execution_id': execution.id,
            'status': execution.status,
            'result': execution.result
        })
        
        return jsonify({
            'message': '任务已终止' + ('' if success else '（注意：Jenkins构建可能仍在运行）'),
            'execution': execution.to_dict()
        })
    except Exception as e:
        db.session.rollback()
        logging.error(f"终止任务执行失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>/permissions', methods=['GET'])
@login_required
def get_task_permissions(task_id):
    """获取任务的权限设置"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 只有管理员和任务创建者可以查看权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        # 查询拥有此任务权限的用户
        result = db.session.query(
            User, 
            task_permissions.c.can_view,
            task_permissions.c.can_execute,
            task_permissions.c.can_terminate,
            task_permissions.c.can_delete
        ).join(
            task_permissions, 
            User.id == task_permissions.c.user_id
        ).filter(
            task_permissions.c.task_id == task_id
        ).all()
        
        permissions = []
        for user, can_view, can_execute, can_terminate, can_delete in result:
            permissions.append({
                'user_id': user.id,
                'username': user.username,
                'can_view': can_view,
                'can_execute': can_execute,
                'can_terminate': can_terminate,
                'can_delete': can_delete
            })
            
        return jsonify({
            'permissions': permissions
        })
    except Exception as e:
        logging.error(f"获取任务权限设置失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/<int:task_id>/permissions', methods=['POST'])
@login_required
def update_task_permissions(task_id):
    """更新任务的权限设置"""
    try:
        task = Task.query.get(task_id)
        
        if not task:
            return jsonify({'error': '任务不存在'}), 404
            
        # 只有管理员和任务创建者可以设置权限
        user = g.current_user
        if not user.is_admin and user.id != task.user_id:
            return jsonify({'error': '权限不足'}), 403
            
        data = request.get_json()
        
        # 更新用户权限
        if 'permissions' in data:
            # 先删除现有权限
            db.session.execute(task_permissions.delete().where(task_permissions.c.task_id == task_id))
            
            # 添加新的权限
            for perm in data['permissions']:
                if perm.get('user_id') == task.user_id:
                    # 跳过任务创建者，创建者默认拥有所有权限
                    continue
                    
                db.session.execute(
                    task_permissions.insert().values(
                        user_id=perm.get('user_id'),
                        task_id=task_id,
                        can_view=perm.get('can_view', True),
                        can_execute=perm.get('can_execute', False),
                        can_terminate=perm.get('can_terminate', False),
                        can_delete=perm.get('can_delete', False)
                    )
                )
            
            db.session.commit()
            
        return jsonify({'message': '权限设置已更新'})
    except Exception as e:
        db.session.rollback()
        logging.error(f"更新任务权限设置失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/tasks/permissions', methods=['GET'])
@login_required
def get_user_task_permissions():
    """获取当前用户的所有任务权限"""
    try:
        user = g.current_user
        
        # 查询用户拥有权限的任务
        result = db.session.query(
            task_permissions.c.task_id,
            task_permissions.c.can_view,
            task_permissions.c.can_execute,
            task_permissions.c.can_terminate,
            task_permissions.c.can_delete
        ).filter(
            task_permissions.c.user_id == user.id
        ).all()
        
        permissions = []
        for task_id, can_view, can_execute, can_terminate, can_delete in result:
            permissions.append({
                'task_id': task_id,
                'can_view': can_view,
                'can_execute': can_execute,
                'can_terminate': can_terminate,
                'can_delete': can_delete
            })
            
        return jsonify(permissions)
    except Exception as e:
        logging.error(f"获取用户任务权限失败: {str(e)}")
        return jsonify({'error': str(e)}), 500

@task_bp.route('/jenkins/jobs', methods=['GET'])
@login_required
def get_jenkins_jobs():
    """获取Jenkins任务列表"""
    try:
        # 获取Jenkins连接参数
        jenkins_url = request.args.get('url')
        jenkins_username = request.args.get('username')
        jenkins_api_token = request.args.get('api_token')
        
        if not jenkins_url:
            return jsonify({'error': '缺少Jenkins URL参数'}), 400
            
        # 创建Jenkins客户端
        client = JenkinsClient(
            jenkins_url,
            jenkins_username,
            jenkins_api_token
        )
        
        # 获取Jenkins版本，测试连接
        try:
            version = client.get_jenkins_version()
            if not version:
                return jsonify({'error': '无法连接到Jenkins服务器'}), 500
                
            logging.info(f"成功连接到Jenkins服务器，版本: {version}")
        except Exception as e:
            logging.error(f"连接Jenkins服务器失败: {str(e)}")
            return jsonify({'error': f'连接Jenkins服务器失败: {str(e)}'}), 500
        
        # 获取所有任务
        try:
            jobs = client.get_all_jobs()
            
            # 格式化返回数据
            result = []
            for job in jobs:
                result.append({
                    'name': job.get('name', ''),
                    'url': job.get('url', ''),
                    'color': job.get('color', '')
                })
                
            return jsonify(result)
        except Exception as e:
            logging.error(f"获取Jenkins任务列表失败: {str(e)}")
            return jsonify({'error': f'获取Jenkins任务列表失败: {str(e)}'}), 500
    except Exception as e:
        logging.error(f"获取Jenkins任务列表失败: {str(e)}")
        return jsonify({'error': str(e)}), 500 

@task_bp.route('/jenkins/job/parameters', methods=['GET'])
@login_required
def get_jenkins_job_parameters():
    """获取Jenkins任务的参数列表"""
    try:
        # 获取Jenkins连接参数
        jenkins_url = request.args.get('url')
        jenkins_username = request.args.get('username')
        jenkins_api_token = request.args.get('api_token')
        job_name = request.args.get('job_name')
        
        if not jenkins_url:
            return jsonify({'error': '缺少Jenkins URL参数'}), 400
            
        if not job_name:
            return jsonify({'error': '缺少Jenkins任务名称参数'}), 400
            
        # 创建Jenkins客户端
        client = JenkinsClient(
            jenkins_url,
            jenkins_username,
            jenkins_api_token
        )
        
        # 获取任务参数
        try:
            parameters = client.get_job_parameters(job_name)
            
            # 格式化返回数据
            result = []
            for param in parameters:
                param_info = {
                    'name': param.get('name', ''),
                    'type': param.get('type', ''),
                    'description': param.get('description', ''),
                    'default_value': param.get('defaultParameterValue', {}).get('value', '')
                }
                
                # 处理选项参数
                if 'choices' in param:
                    param_info['choices'] = param.get('choices', [])
                
                result.append(param_info)
                
            return jsonify(result)
        except Exception as e:
            logging.error(f"获取Jenkins任务参数失败: {str(e)}")
            return jsonify({'error': f'获取Jenkins任务参数失败: {str(e)}'}), 500
    except Exception as e:
        logging.error(f"获取Jenkins任务参数失败: {str(e)}")
        return jsonify({'error': str(e)}), 500 

@task_bp.route('/jenkins/test-build', methods=['POST'])
@login_required
def test_jenkins_build():
    """测试Jenkins构建API"""
    try:
        data = request.get_json() or {}
        
        # 获取必要参数
        jenkins_url = data.get('jenkins_url')
        jenkins_username = data.get('jenkins_username')
        jenkins_api_token = data.get('jenkins_api_token')
        job_name = data.get('job_name')
        parameters = data.get('parameters')
        
        # 验证参数
        if not jenkins_url:
            return jsonify({'error': '缺少Jenkins URL'}), 400
        if not job_name:
            return jsonify({'error': '缺少任务名称'}), 400
            
        # 创建Jenkins客户端
        client = JenkinsClient(
            jenkins_url,
            jenkins_username,
            jenkins_api_token
        )
        
        # 记录详细信息
        logging.info(f"===== 测试Jenkins构建 =====")
        logging.info(f"Jenkins URL: {jenkins_url}")
        logging.info(f"任务名称: {job_name}")
        logging.info(f"参数: {parameters}")
        
        # 检查任务是否存在
        try:
            job_info = client.get_job_info(job_name)
            logging.info(f"任务信息获取成功: {job_info.get('displayName', job_name)}")
        except Exception as e:
            logging.error(f"获取任务信息失败: {str(e)}")
            return jsonify({'error': f'获取任务信息失败: {str(e)}'}), 500
        
        # 检查任务是否有参数
        try:
            job_params = client.get_job_parameters(job_name)
            logging.info(f"任务参数: {job_params}")
            
            # 如果任务有参数但未提供
            if job_params and not parameters:
                logging.warning("任务需要参数但未提供")
        except Exception as e:
            logging.error(f"获取任务参数失败: {str(e)}")
        
        # 尝试构建
        try:
            # 直接使用buildWithParameters API
            encoded_job_name = urllib.parse.quote(job_name)
            url = f"{jenkins_url}/job/{encoded_job_name}/buildWithParameters"
            
            logging.info(f"直接调用buildWithParameters API: {url}")
            
            auth = (jenkins_username, jenkins_api_token) if jenkins_username and jenkins_api_token else None
            
            # 发送请求
            response = requests.post(url, auth=auth, params=parameters if parameters else {})
            
            logging.info(f"响应状态码: {response.status_code}")
            logging.info(f"响应头: {dict(response.headers)}")
            logging.info(f"响应内容: {response.text[:200]}...")  # 只记录前200个字符
            
            # 检查响应
            if response.status_code == 201:
                queue_url = response.headers.get('Location')
                return jsonify({
                    'success': True,
                    'message': '构建已触发',
                    'queue_url': queue_url
                })
            else:
                return jsonify({
                    'success': False,
                    'status_code': response.status_code,
                    'message': f'构建触发失败: {response.text}'
                }), 500
        except Exception as e:
            logging.exception("构建触发失败:")
            return jsonify({'error': f'构建触发失败: {str(e)}'}), 500
    except Exception as e:
        logging.exception("测试Jenkins构建失败:")
        return jsonify({'error': str(e)}), 500 