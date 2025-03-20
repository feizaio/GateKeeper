from flask import Blueprint, request, jsonify
from backend.models.server import Server
from backend.models.user import User
from backend.extensions import db
from datetime import datetime
import urllib.parse

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
                server.in_use_by = None
                server.last_active = None
                
        db.session.commit()
        return jsonify({'success': True})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500 
