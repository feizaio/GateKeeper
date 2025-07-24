from flask import Blueprint, jsonify, g
from sqlalchemy import func, desc
from datetime import datetime, timedelta
from backend.models.server import Server
from backend.models.user import User
from backend.models.userlog import UserLog
from backend.models.client import Client
from backend.models.category import Category
from backend.extensions import db

dashboard_bp = Blueprint('dashboard', __name__)

@dashboard_bp.route('/stats', methods=['GET'])
def get_dashboard_stats():
    """获取仪表盘统计数据"""
    # 检查用户权限
    if not g.current_user or not g.current_user.is_admin:
        return jsonify({"error": "无权限访问"}), 403
    
    # 获取基础统计数据
    total_servers = Server.query.count()
    total_users = User.query.count()
    
    # 获取今日活跃度（当天的日志数量）
    today = datetime.now().date()
    today_start = datetime.combine(today, datetime.min.time())
    today_end = datetime.combine(today, datetime.max.time())
    
    today_activities = UserLog.query.filter(
        UserLog.created_at.between(today_start, today_end),
        UserLog.action == 'connect'
    ).count()
    
    # 获取告警数量（示例：过去24小时内的失败登录尝试）
    yesterday = datetime.now() - timedelta(days=1)
    alerts = UserLog.query.filter(
        UserLog.action == 'login_failed',
        UserLog.created_at >= yesterday
    ).count()
    
    # 获取服务器类型分布
    server_types = db.session.query(
        Server.type, 
        func.count(Server.id).label('count')
    ).group_by(Server.type).all()
    
    server_type_distribution = {
        server_type: count 
        for server_type, count in server_types
    }
    
    # 获取活动趋势（近7天的每日活动数）
    activity_trend = []
    for day in range(6, -1, -1):  # 从6到0，对应过去7天
        day_date = today - timedelta(days=day)
        day_start = datetime.combine(day_date, datetime.min.time())
        day_end = datetime.combine(day_date, datetime.max.time())
        
        count = UserLog.query.filter(
            UserLog.created_at.between(day_start, day_end)
        ).count()
        
        # 格式化为"6月1日"这样的格式
        # 跨平台兼容的日期格式化方式
        month = day_date.month
        day = day_date.day
        date_str = f"{month}月{day}日"
        
        activity_trend.append({
            'date': date_str,
            'count': count
        })
    
    # 获取最近活动日志
    recent_logs = UserLog.query.order_by(
        desc(UserLog.created_at)
    ).limit(10).all()
    
    recent_activities = []
    for log in recent_logs:
        recent_activities.append({
            'time': log.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'user': log.username,
            'action': log.action,
            'server': log.server_name,
            'ip': log.server_ip,
            'status': 'success' if log.action not in ['login_failed', 'connect_failed'] else 'failed'
        })
    
    return jsonify({
        'total_servers': total_servers,
        'total_users': total_users,
        'today_activities': today_activities,
        'alerts': alerts,
        'server_type_distribution': server_type_distribution,
        'activity_trend': activity_trend,
        'recent_activities': recent_activities
    })

@dashboard_bp.route('/online-users', methods=['GET'])
def get_online_users():
    """获取在线用户数据"""
    if not g.current_user or not g.current_user.is_admin:
        return jsonify({"error": "无权限访问"}), 403
    
    # 获取当前在线用户（示例：最近30分钟有活动的用户）
    recent_time = datetime.now() - timedelta(minutes=30)
    
    online_users = db.session.query(
        UserLog.username,
        func.max(UserLog.created_at).label('last_activity'),
        func.count(UserLog.id).label('activity_count')
    ).filter(
        UserLog.created_at >= recent_time
    ).group_by(
        UserLog.username
    ).all()
    
    result = []
    for username, last_activity, activity_count in online_users:
        result.append({
            'username': username,
            'last_activity': last_activity.strftime('%Y-%m-%d %H:%M:%S'),
            'activity_count': activity_count
        })
    
    return jsonify(result) 