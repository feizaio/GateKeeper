from flask import Blueprint, request, jsonify, g
from backend.models.credential import Credential
from backend.models.user import User
from backend.models.server import Server
from backend.extensions import db
from backend.routes.auth import admin_required, login_required

credential_bp = Blueprint('credential', __name__)

@credential_bp.route('/credentials', methods=['GET'])
@admin_required
def get_credentials():
    """获取所有凭据列表"""
    try:
        credentials = Credential.query.all()
        return jsonify([{
            'id': cred.id,
            'name': cred.name,
            'username': cred.username,
            'description': cred.description,
            'server_count': cred.servers.count()
        } for cred in credentials])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@credential_bp.route('/credentials/<int:credential_id>', methods=['GET'])
@admin_required
def get_credential(credential_id):
    """获取单个凭据详情"""
    credential = Credential.query.get_or_404(credential_id)
    
    # 获取使用此凭据的服务器列表
    servers = credential.servers.all()
    
    return jsonify({
        'id': credential.id,
        'name': credential.name,
        'username': credential.username,
        'description': credential.description,
        'servers': [{
            'id': server.id,
            'name': server.name,
            'ip': server.ip,
            'type': server.type
        } for server in servers]
    })

@credential_bp.route('/credentials', methods=['POST'])
@admin_required
def add_credential():
    """添加新凭据"""
    data = request.get_json()
    
    # 验证必需的字段
    required_fields = ['name', 'username', 'password']
    for field in required_fields:
        if field not in data or not data[field]:
            return jsonify({'error': f'缺少必须字段: {field}'}), 400
    
    # 检查凭据名称是否已存在
    existing = Credential.query.filter_by(name=data['name']).first()
    if existing:
        return jsonify({'error': '凭据名称已存在'}), 400
    
    try:
        credential = Credential(
            name=data['name'],
            username=data['username'],
            description=data.get('description', '')
        )
        credential.set_password(data['password'])
        
        db.session.add(credential)
        db.session.commit()
        
        return jsonify({
            'message': '凭据添加成功',
            'id': credential.id
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@credential_bp.route('/credentials/<int:credential_id>', methods=['PUT'])
@admin_required
def update_credential(credential_id):
    """更新凭据"""
    credential = Credential.query.get_or_404(credential_id)
    data = request.get_json()
    
    # 验证必需的字段
    if 'name' not in data or not data['name']:
        return jsonify({'error': '缺少必须字段: name'}), 400
    
    # 检查凭据名称是否已存在（排除当前凭据）
    existing = Credential.query.filter(Credential.name==data['name'], Credential.id!=credential_id).first()
    if existing:
        return jsonify({'error': '凭据名称已存在'}), 400
    
    try:
        credential.name = data['name']
        
        if 'username' in data and data['username']:
            credential.username = data['username']
            
        if 'description' in data:
            credential.description = data['description']
            
        if 'password' in data and data['password']:
            credential.set_password(data['password'])
        
        db.session.commit()
        return jsonify({'message': '凭据更新成功'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@credential_bp.route('/credentials/<int:credential_id>', methods=['DELETE'])
@admin_required
def delete_credential(credential_id):
    """删除凭据"""
    credential = Credential.query.get_or_404(credential_id)
    
    # 检查是否有服务器正在使用此凭据
    if credential.servers.count() > 0:
        return jsonify({'error': '无法删除，有服务器正在使用此凭据'}), 400
    
    try:
        db.session.delete(credential)
        db.session.commit()
        return jsonify({'message': '凭据删除成功'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500 