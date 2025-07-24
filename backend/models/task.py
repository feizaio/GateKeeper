from backend.extensions import db
from datetime import datetime
import json

# 定义用户和任务的多对多关系表
task_permissions = db.Table('task_permissions',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'), primary_key=True),
    db.Column('task_id', db.Integer, db.ForeignKey('tasks.id', ondelete='CASCADE'), primary_key=True),
    db.Column('can_view', db.Boolean, default=True),
    db.Column('can_execute', db.Boolean, default=False),
    db.Column('can_terminate', db.Boolean, default=False),
    db.Column('can_delete', db.Boolean, default=False),
    db.Column('created_at', db.DateTime, default=datetime.utcnow)
)

class TaskView(db.Model):
    """任务视图模型，用于对任务进行分类"""
    __tablename__ = 'task_views'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 与用户的关系
    user = db.relationship('User', backref=db.backref('task_views', lazy='dynamic'))
    
    # 与任务的关系
    tasks = db.relationship('Task', backref='view', lazy='dynamic')
    
    def __repr__(self):
        return f'<TaskView {self.name}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'user_id': self.user_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'task_count': self.tasks.count()
        }

class Task(db.Model):
    """任务模型，用于存储任务信息"""
    __tablename__ = 'tasks'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=True)
    task_type = db.Column(db.String(50), nullable=False)  # jenkins, script, command等
    
    # Jenkins任务特有字段
    jenkins_url = db.Column(db.String(255), nullable=True)
    jenkins_job_name = db.Column(db.String(255), nullable=True)
    jenkins_username = db.Column(db.String(100), nullable=True)
    jenkins_api_token = db.Column(db.String(100), nullable=True)
    jenkins_parameters = db.Column(db.Text, nullable=True)  # 存储JSON格式的参数
    
    # 脚本任务特有字段
    script_content = db.Column(db.Text, nullable=True)
    script_type = db.Column(db.String(50), nullable=True)  # python, bash, powershell等
    
    # 命令任务特有字段
    command = db.Column(db.Text, nullable=True)
    
    # 任务状态
    is_enabled = db.Column(db.Boolean, default=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 任务视图关联
    view_id = db.Column(db.Integer, db.ForeignKey('task_views.id'), nullable=True)
    
    # 与用户的关系
    user = db.relationship('User', backref=db.backref('tasks', lazy='dynamic'))
    
    # 有权限访问此任务的用户
    authorized_users = db.relationship(
        'User',
        secondary=task_permissions,
        lazy='dynamic',
        backref=db.backref('authorized_tasks', lazy='dynamic')
    )
    
    # 任务执行记录
    executions = db.relationship('TaskExecution', backref='task', lazy='dynamic', cascade='all, delete-orphan')
    
    def __repr__(self):
        return f'<Task {self.name}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        result = {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'task_type': self.task_type,
            'is_enabled': self.is_enabled,
            'user_id': self.user_id,
            'view_id': self.view_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
        
        # 根据任务类型添加特定字段
        if self.task_type == 'jenkins':
            result.update({
                'jenkins_url': self.jenkins_url,
                'jenkins_job_name': self.jenkins_job_name,
                'jenkins_username': self.jenkins_username,
                'jenkins_api_token': self.jenkins_api_token,
                'jenkins_parameters': self.get_jenkins_parameters()
            })
        elif self.task_type == 'script':
            result.update({
                'script_content': self.script_content,
                'script_type': self.script_type
            })
        elif self.task_type == 'command':
            result.update({
                'command': self.command
            })
            
        return result
    
    def get_jenkins_parameters(self):
        """获取Jenkins参数字典"""
        if not self.jenkins_parameters:
            return {}
        try:
            return json.loads(self.jenkins_parameters)
        except:
            return {}
    
    def set_jenkins_parameters(self, params):
        """设置Jenkins参数"""
        if params is None:
            self.jenkins_parameters = None
        else:
            self.jenkins_parameters = json.dumps(params)

class TaskExecution(db.Model):
    """任务执行记录模型"""
    __tablename__ = 'task_executions'
    
    id = db.Column(db.Integer, primary_key=True)
    task_id = db.Column(db.Integer, db.ForeignKey('tasks.id', ondelete='CASCADE'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)  # pending, running, success, failed, terminated
    start_time = db.Column(db.DateTime, default=datetime.utcnow)
    end_time = db.Column(db.DateTime, nullable=True)
    
    # Jenkins任务特有字段
    jenkins_build_number = db.Column(db.Integer, nullable=True)
    jenkins_build_url = db.Column(db.String(255), nullable=True)
    jenkins_parameters = db.Column(db.Text, nullable=True)  # 存储本次执行使用的参数
    
    # 执行结果
    result = db.Column(db.Text, nullable=True)
    log_content = db.Column(db.Text(length=4294967295), nullable=True)  # 使用LONGTEXT类型存储大量日志
    
    # 与用户的关系
    user = db.relationship('User', backref=db.backref('task_executions', lazy='dynamic'))
    
    def __repr__(self):
        return f'<TaskExecution {self.id} - {self.status}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        result = {
            'id': self.id,
            'task_id': self.task_id,
            'user_id': self.user_id,
            'status': self.status,
            'start_time': self.start_time.isoformat() if self.start_time else None,
            'end_time': self.end_time.isoformat() if self.end_time else None,
            'result': self.result
        }
        
        # 添加Jenkins特有字段
        if self.jenkins_build_number:
            result.update({
                'jenkins_build_number': self.jenkins_build_number,
                'jenkins_build_url': self.jenkins_build_url,
                'jenkins_parameters': self.get_jenkins_parameters()
            })
            
        return result
    
    def get_jenkins_parameters(self):
        """获取Jenkins参数字典"""
        if not self.jenkins_parameters:
            return {}
        try:
            return json.loads(self.jenkins_parameters)
        except:
            return {}
    
    def set_jenkins_parameters(self, params):
        """设置Jenkins参数"""
        if params is None:
            self.jenkins_parameters = None
        else:
            self.jenkins_parameters = json.dumps(params) 