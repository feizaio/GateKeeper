from flask import Blueprint, request, jsonify
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from datetime import datetime
import urllib.parse
from backend.models.userlog import UserLog

agent_bp = Blueprint('agent', __name__)

@agent_bp.route('/agent/status', methods=['POST'])
def update_server_status():
    data = request.get_json()
    
    if not data or 'server_ip' not in data:
        return jsonify({'error': 'Invalid data'}), 400
        
    try:
        server = Server.query.filter_by(ip=data['server_ip']).first()
        if not server:
            return jsonify({'error': 'Server not found'}), 404
            
        if data['has_active_session'] and data['session_info']:
            session = data['session_info'][0]
            # 查找用户
            user = User.query.filter_by(username=session['username']).first()
            
            if user and not server.in_use_by:
                server.in_use_by = user.id
                server.last_active = datetime.now()
                
        else:
            if server.in_use_by:
                # 记录断开日志
                user = User.query.get(server.in_use_by)
                if user:
                    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0]
                    log = UserLog(
                        user_id=user.id,
                        username=user.username,
                        action='disconnect',
                        server_id=server.id,
                        server_name=server.name,
                        server_ip=server.ip,
                        client_ip=client_ip,
                        details=f"用户 {user.username} 断开{server.type}连接 {server.name}({server.ip}) [代理检测]"
                    )
                    db.session.add(log)
                
                server.in_use_by = None
                server.last_active = None
                
        db.session.commit()
        return jsonify({'success': True})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500 