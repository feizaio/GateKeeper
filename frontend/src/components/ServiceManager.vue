
<template>
  <div class="service-manager">
    <div class="page-header">
      <h2 class="page-title">服务管理</h2>
      <div class="page-description">添加和管理外部服务页面，方便快速访问</div>
    </div>

    <!-- 工具栏 -->
    <div class="actions-toolbar">
      <el-button type="primary" icon="el-icon-plus" @click="showAddDialog" v-if="isAdmin">添加页面</el-button>
    </div>
    
    <!-- 服务列表区域 -->
    <div class="section-title">
      <i class="el-icon-menu"></i> 服务列表
    </div>
    
    <!-- 卡片区 -->
    <div class="card-container">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :xl="6" v-for="(item, idx) in iframes" :key="item.id || idx">
          <el-card 
            class="iframe-card" 
            :class="{ 'is-active': selectedIdx === idx }"
            shadow="hover" 
            @click.native="selectIframe(idx)">
            <div class="card-header">
              <div class="iframe-title">{{ item.title || item.url }}</div>
              <el-dropdown trigger="click" @command="handleCommand($event, idx)" class="card-menu" @click.stop>
                <span class="el-dropdown-link" @click.stop>
                  <i class="el-icon-more"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="view">
                    <i class="el-icon-view"></i> 查看
                  </el-dropdown-item>
                  <el-dropdown-item command="share" v-if="canManagePermissions(item)">
                    <i class="el-icon-share"></i> 权限设置
                  </el-dropdown-item>
                  <el-dropdown-item command="delete" divided v-if="canDelete(item)">
                    <i class="el-icon-delete"></i> 删除
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </div>
            <div class="card-content">
              <div class="url-preview">{{ formatUrl(item.url) }}</div>
              <div class="card-footer">
                <span class="time-info" v-if="item.created_at">创建于 {{ formatDate(item.created_at) }}</span>
                <el-tag size="mini" type="success" v-if="item.is_public">公共</el-tag>
                <el-tag size="mini" type="info" v-if="item.user_id === currentUser.id">我的</el-tag>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <!-- 空状态提示 -->
        <el-col :span="24" v-if="iframes.length === 0">
          <div class="empty-tip">
            <i class="el-icon-info" style="font-size: 48px; margin-bottom: 16px;"></i>
            <span>暂无服务页面，点击"添加页面"按钮添加新的服务</span>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 添加服务对话框 -->
    <el-dialog title="添加服务页面" :visible.sync="addDialogVisible" width="30%" @closed="resetForm">
      <el-form :model="addForm" :rules="formRules" ref="addForm" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="addForm.title" placeholder="请输入服务标题"></el-input>
        </el-form-item>
        <el-form-item label="地址" prop="url">
          <el-input v-model="addForm.url" placeholder="请输入服务地址，例如: http://example.com"></el-input>
        </el-form-item>
        <el-form-item label="公共页面">
          <el-switch v-model="addForm.is_public"></el-switch>
          <div class="form-tip">开启后，所有用户都可以访问此服务页面</div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="addIframe" :loading="loading">确定</el-button>
      </div>
    </el-dialog>

    <!-- 服务内容对话框 -->
    <el-dialog 
      :title="(iframes[selectedIdx] && iframes[selectedIdx].title) || (iframes[selectedIdx] && iframes[selectedIdx].url)" 
      :visible.sync="dialogVisible" 
      width="90%" 
      :before-close="closeIframeContent"
      class="iframe-dialog"
      fullscreen>
      <iframe v-if="selectedIdx !== null && iframes[selectedIdx]" :src="iframes[selectedIdx].url" class="iframe-content"></iframe>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeIframeContent">关闭</el-button>
      </span>
    </el-dialog>

    <!-- 删除确认对话框 -->
    <el-dialog
      title="确认删除"
      :visible.sync="deleteConfirmVisible"
      width="30%">
      <span>确定要删除此服务页面吗？</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="deleteConfirmVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmDelete" :loading="deleteLoading">删除</el-button>
      </span>
    </el-dialog>

    <!-- 权限设置对话框 -->
    <el-dialog
      title="权限设置"
      :visible.sync="permissionDialogVisible"
      width="50%">
      <div v-if="selectedService">
        <el-form label-width="120px">
          <el-form-item label="公共页面">
            <el-switch v-model="permissionForm.is_public"></el-switch>
            <div class="form-tip">开启后，所有用户都可以访问此服务页面</div>
          </el-form-item>
        </el-form>
        
        <div class="section-divider">
          <span>用户权限</span>
        </div>
        
        <div class="user-permissions">
          <div class="user-permissions-header">
            <el-button size="small" type="primary" @click="showAddUserPermission">
              <i class="el-icon-plus"></i> 添加用户
            </el-button>
          </div>
          
          <el-table :data="permissionForm.permissions" style="width: 100%">
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column label="查看权限">
              <template slot-scope="scope">
                <el-switch v-model="scope.row.can_view" disabled></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="编辑权限">
              <template slot-scope="scope">
                <el-switch v-model="scope.row.can_edit"></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="删除权限">
              <template slot-scope="scope">
                <el-switch v-model="scope.row.can_delete"></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80">
              <template slot-scope="scope">
                <el-button 
                  size="mini" 
                  type="danger" 
                  icon="el-icon-delete"
                  @click="removeUserPermission(scope.$index)">
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <div class="empty-tip" v-if="permissionForm.permissions.length === 0">
            <span>暂无用户权限，点击"添加用户"按钮设置用户权限</span>
          </div>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="permissionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="savePermissions" :loading="permissionLoading">保存</el-button>
      </span>
    </el-dialog>

    <!-- 添加用户权限对话框 -->
    <el-dialog
      title="添加用户权限"
      :visible.sync="addUserPermissionDialogVisible"
      width="30%">
      <el-form :model="newUserPermission" label-width="80px">
        <el-form-item label="用户">
          <el-select v-model="newUserPermission.user_id" placeholder="请选择用户" style="width: 100%">
            <el-option
              v-for="user in availableUsers"
              :key="user.id"
              :label="user.username"
              :value="user.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="编辑权限">
          <el-switch v-model="newUserPermission.can_edit"></el-switch>
        </el-form-item>
        <el-form-item label="删除权限">
          <el-switch v-model="newUserPermission.can_delete"></el-switch>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addUserPermissionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="addUserPermission">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'ServiceManager',
  data() {
    return {
      addForm: {
        url: '',
        title: '',
        is_public: false
      },
      formRules: {
        url: [
          { required: true, message: '请输入页面地址', trigger: 'blur' },
          { type: 'string', pattern: /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$/, 
            message: '请输入有效的URL地址', trigger: 'blur' }
        ]
      },
      iframes: [],
      selectedIdx: null,
      loading: false,
      error: null,
      dialogVisible: false,
      addDialogVisible: false,
      deleteConfirmVisible: false,
      deleteLoading: false,
      indexToDelete: null,
      
      // 权限管理相关
      permissionDialogVisible: false,
      permissionLoading: false,
      selectedService: null,
      permissionForm: {
        is_public: false,
        permissions: []
      },
      
      // 添加用户权限
      addUserPermissionDialogVisible: false,
      newUserPermission: {
        user_id: null,
        username: '',
        can_view: true,
        can_edit: false,
        can_delete: false
      },
      availableUsers: []
    }
  },
  computed: {
    currentUser() {
      return this.$store.state.user || {};
    },
    isAdmin() {
      return this.currentUser && this.currentUser.is_admin;
    }
  },
  mounted() {
    this.loadServices();
  },
  methods: {
    // 显示添加对话框
    showAddDialog() {
      this.addDialogVisible = true;
      // 延迟聚焦到URL输入框
      this.$nextTick(() => {
        const inputEl = this.$refs.addForm.querySelector('input');
        if (inputEl) {
          inputEl.focus();
        }
      });
    },
    
    // 重置表单
    resetForm() {
      this.addForm = {
        url: '',
        title: '',
        is_public: false
      };
      if (this.$refs.addForm) {
        this.$refs.addForm.resetFields();
      }
    },
    
    // 加载服务列表
    async loadServices() {
      try {
        this.loading = true;
        const response = await axios.get('/api/services');
        this.iframes = response.data;
        this.loading = false;
      } catch (error) {
        this.error = error.response && error.response.data && error.response.data.error ? error.response.data.error : '加载服务失败';
        this.$message.error(this.error);
        this.loading = false;
      }
    },
    
    // 添加服务
    async addIframe() {
      // 表单验证
      this.$refs.addForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }
        
        try {
          this.loading = true;
          
          // 如果URL不包含http或https，添加http://前缀
          let url = this.addForm.url.trim();
          if (!/^https?:\/\//i.test(url)) {
            url = 'http://' + url;
          }
          
          const response = await axios.post('/api/services', {
            url: url,
            title: this.addForm.title.trim(),
            is_public: this.addForm.is_public
          });
          
          this.iframes.push(response.data);
          this.$message.success('添加成功');
          this.addDialogVisible = false;
          this.loading = false;
        } catch (error) {
          this.error = error.response && error.response.data && error.response.data.error ? error.response.data.error : '添加服务失败';
          this.$message.error(this.error);
          this.loading = false;
        }
      });
    },
    
    // 处理卡片菜单命令
    handleCommand(command, idx) {
      if (command === 'view') {
        this.selectIframe(idx);
      } else if (command === 'delete') {
        this.indexToDelete = idx;
        this.deleteConfirmVisible = true;
      } else if (command === 'share') {
        this.showPermissionDialog(idx);
      }
    },
    
    // 确认删除
    async confirmDelete() {
      if (this.indexToDelete === null) return;
      
      this.deleteLoading = true;
      await this.removeIframe(this.indexToDelete);
      this.deleteLoading = false;
      this.deleteConfirmVisible = false;
      this.indexToDelete = null;
    },
    
    // 删除服务
    async removeIframe(idxToRemove) {
      const serviceToRemove = this.iframes[idxToRemove];
      
      // 如果没有ID，说明是本地添加的未保存的服务
      if (!serviceToRemove.id) {
        this.iframes.splice(idxToRemove, 1);
        if (this.selectedIdx === idxToRemove) {
          this.closeIframeContent();
        } else if (this.selectedIdx > idxToRemove) {
          this.selectedIdx--;
        }
        this.$message.success('删除成功');
        return;
      }
      
      try {
        // 设置删除中状态
        this.$set(this.iframes[idxToRemove], 'deleting', true);
        
        await axios.delete(`/api/services/${serviceToRemove.id}`);
        
        this.iframes.splice(idxToRemove, 1);
        if (this.selectedIdx === idxToRemove) {
          this.closeIframeContent();
        } else if (this.selectedIdx > idxToRemove) {
          this.selectedIdx--;
        }
        this.$message.success('删除成功');
      } catch (error) {
        this.error = error.response && error.response.data && error.response.data.error ? error.response.data.error : '删除服务失败';
        this.$message.error(this.error);
        // 取消删除中状态
        if (this.iframes[idxToRemove]) {
          this.$set(this.iframes[idxToRemove], 'deleting', false);
        }
      }
    },
    
    selectIframe(idx) {
      this.selectedIdx = idx;
      this.dialogVisible = true;
    },
    
    closeIframeContent() {
      this.dialogVisible = false;
      this.selectedIdx = null;
    },
    
    // 格式化URL显示
    formatUrl(url) {
      if (!url) return '';
      try {
        const urlObj = new URL(url);
        return urlObj.hostname;
      } catch (e) {
        return url;
      }
    },
    
    // 格式化日期显示
    formatDate(dateStr) {
      if (!dateStr) return '';
      const date = new Date(dateStr);
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      });
    },
    
    // 权限相关方法
    
    // 判断当前用户是否可以删除服务
    canDelete(service) {
      if (!service) return false;
      return this.isAdmin || service.user_id === this.currentUser.id;
    },
    
    // 判断当前用户是否可以管理权限
    canManagePermissions(service) {
      if (!service) return false;
      return this.isAdmin || service.user_id === this.currentUser.id;
    },
    
    // 显示权限设置对话框
    async showPermissionDialog(idx) {
      if (idx === null || !this.iframes[idx]) return;
      
      this.selectedService = this.iframes[idx];
      this.permissionLoading = true;
      
      try {
        // 获取服务权限设置
        const response = await axios.get(`/api/services/${this.selectedService.id}/permissions`);
        
        this.permissionForm = {
          is_public: response.data.is_public,
          permissions: response.data.permissions || []
        };
        
        // 获取可用用户列表
        await this.loadAvailableUsers();
        
        this.permissionDialogVisible = true;
      } catch (error) {
        this.error = error.response && error.response.data && error.response.data.error ? error.response.data.error : '获取权限设置失败';
        this.$message.error(this.error);
      } finally {
        this.permissionLoading = false;
      }
    },
    
    // 加载可用用户列表
    async loadAvailableUsers() {
      try {
        const response = await axios.get('/api/users');
        // 过滤掉当前用户和已有权限的用户
        this.availableUsers = response.data.filter(user => 
          user.id !== this.currentUser.id && 
          !this.permissionForm.permissions.some(p => p.user_id === user.id)
        );
      } catch (error) {
        this.$message.error('获取用户列表失败');
      }
    },
    
    // 显示添加用户权限对话框
    showAddUserPermission() {
      // 重置表单
      this.newUserPermission = {
        user_id: null,
        can_view: true,
        can_edit: false,
        can_delete: false
      };
      
      // 更新可用用户列表
      this.addUserPermissionDialogVisible = true;
    },
    
    // 添加用户权限
    addUserPermission() {
      if (!this.newUserPermission.user_id) {
        this.$message.warning('请选择用户');
        return;
      }
      
      // 查找对应的用户名
      const selectedUser = this.availableUsers.find(u => u.id === this.newUserPermission.user_id);
      if (!selectedUser) return;
      
      // 添加到权限列表
      this.permissionForm.permissions.push({
        user_id: this.newUserPermission.user_id,
        username: selectedUser.username,
        can_view: true,
        can_edit: this.newUserPermission.can_edit,
        can_delete: this.newUserPermission.can_delete
      });
      
      // 从可用用户列表中移除
      this.availableUsers = this.availableUsers.filter(u => u.id !== this.newUserPermission.user_id);
      
      this.addUserPermissionDialogVisible = false;
    },
    
    // 移除用户权限
    removeUserPermission(index) {
      if (index < 0 || index >= this.permissionForm.permissions.length) return;
      
      // 将用户添加回可用用户列表
      const removedPermission = this.permissionForm.permissions[index];
      const existingUser = this.availableUsers.find(u => u.id === removedPermission.user_id);
      
      if (!existingUser) {
        this.availableUsers.push({
          id: removedPermission.user_id,
          username: removedPermission.username
        });
      }
      
      // 从权限列表中移除
      this.permissionForm.permissions.splice(index, 1);
    },
    
    // 保存权限设置
    async savePermissions() {
      if (!this.selectedService) return;
      
      this.permissionLoading = true;
      
      try {
        await axios.post(`/api/services/${this.selectedService.id}/permissions`, this.permissionForm);
        
        // 更新本地数据
        const serviceIndex = this.iframes.findIndex(s => s.id === this.selectedService.id);
        if (serviceIndex !== -1) {
          this.$set(this.iframes[serviceIndex], 'is_public', this.permissionForm.is_public);
        }
        
        this.$message.success('权限设置已保存');
        this.permissionDialogVisible = false;
      } catch (error) {
        this.error = error.response && error.response.data && error.response.data.error ? error.response.data.error : '保存权限设置失败';
        this.$message.error(this.error);
      } finally {
        this.permissionLoading = false;
      }
    }
  }
}
</script>

<style scoped>
.service-manager {
  padding: 20px;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 24px;
  color: #303133;
  margin: 0 0 8px 0;
  font-weight: 500;
}

.page-description {
  color: #606266;
  font-size: 14px;
}

.actions-toolbar {
  display: flex;
  justify-content: flex-start;
  margin-bottom: 20px;
}

.section-title {
  margin: 25px 0 15px 0;
  font-size: 16px;
  font-weight: 500;
  color: #5B6B8B;
  display: flex;
  align-items: center;
}

.section-title i {
  margin-right: 8px;
  font-size: 18px;
}

.card-container {
  margin-bottom: 20px;
  min-height: 120px;
}

.iframe-card {
  margin-bottom: 15px;
  cursor: pointer;
  transition: all 0.3s;
  border-radius: 8px;
  overflow: hidden;
  height: 150px;
  display: flex;
  flex-direction: column;
}

.iframe-card.is-active {
  border: 2px solid #4B7BE5;
  transform: translateY(-2px);
}

.iframe-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  background: linear-gradient(to right, #4B7BE5, #5B8FF9);
  color: white;
}

.iframe-title {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: 500;
  font-size: 14px;
}

.card-menu {
  color: white;
}

.el-dropdown-link {
  cursor: pointer;
  font-size: 16px;
}

.card-content {
  padding: 15px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.url-preview {
  color: #909399;
  font-size: 13px;
  margin-bottom: 10px;
}

.card-footer {
  margin-top: auto;
  font-size: 12px;
  color: #909399;
  display: flex;
  justify-content: space-between;
}

.empty-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #909399;
  height: 200px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
  padding: 20px;
}

.iframe-content {
  width: 100%;
  height: calc(100vh - 200px);
  border: none;
}

.iframe-dialog .el-dialog__body {
  padding: 0;
}

.form-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 4px;
}

.section-divider {
  display: flex;
  align-items: center;
  margin: 24px 0;
  color: #909399;
  font-size: 14px;
}

.section-divider::before,
.section-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: #EBEEF5;
}

.section-divider::before {
  margin-right: 12px;
}

.section-divider::after {
  margin-left: 12px;
}

.user-permissions {
  margin-bottom: 20px;
}

.user-permissions-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
}
</style>
