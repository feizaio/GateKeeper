<template>
  <div class="task-detail">
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">{{ task.name }}</h2>
        <el-tag :type="getTaskTypeTag(task.task_type)" class="task-type-tag">
          {{ getTaskTypeLabel(task.task_type) }}
        </el-tag>
        <el-tag :type="task.is_enabled ? 'success' : 'danger'" class="status-tag">
          {{ task.is_enabled ? '已启用' : '已禁用' }}
        </el-tag>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-back" @click="$router.push('/system/task-manager')">
          返回列表
        </el-button>
        <el-button 
          type="success" 
          icon="el-icon-video-play" 
          @click="executeTask" 
          :disabled="!task.is_enabled">
          执行任务
        </el-button>
      </div>
    </div>

    <el-tabs v-model="activeTab">
      <el-tab-pane label="任务详情" name="details">
        <el-card class="detail-card">
          <div slot="header">
            <span>基本信息</span>
            <el-button 
              style="float: right; padding: 3px 0" 
              type="text" 
              icon="el-icon-edit"
              @click="$router.push('/system/task-manager')"
              v-if="canEdit">
              编辑
            </el-button>
          </div>
          
          <el-descriptions :column="2" border>
            <el-descriptions-item label="任务名称">{{ task.name }}</el-descriptions-item>
            <el-descriptions-item label="任务类型">{{ getTaskTypeLabel(task.task_type) }}</el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ formatDate(task.created_at) }}</el-descriptions-item>
            <el-descriptions-item label="更新时间">{{ formatDate(task.updated_at) }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="task.is_enabled ? 'success' : 'danger'">
                {{ task.is_enabled ? '已启用' : '已禁用' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="创建者">{{ taskOwner }}</el-descriptions-item>
            <el-descriptions-item label="描述" :span="2">
              {{ task.description || '无描述' }}
            </el-descriptions-item>
          </el-descriptions>
          
          <!-- Jenkins任务特有信息 -->
          <template v-if="task.task_type === 'jenkins'">
            <div class="section-divider">Jenkins任务信息</div>
            <el-descriptions :column="1" border>
              <el-descriptions-item label="Jenkins URL">{{ task.jenkins_url }}</el-descriptions-item>
              <el-descriptions-item label="Jenkins任务名称">{{ task.jenkins_job_name }}</el-descriptions-item>
              <el-descriptions-item label="Jenkins用户名">{{ task.jenkins_username }}</el-descriptions-item>
              <el-descriptions-item label="任务参数" v-if="Object.keys(task.jenkins_parameters || {}).length > 0">
                <div class="params-table">
                  <el-table :data="formatJenkinsParams(task.jenkins_parameters)" border size="small">
                    <el-table-column prop="name" label="参数名" width="180"></el-table-column>
                    <el-table-column prop="value" label="默认值"></el-table-column>
                  </el-table>
                </div>
              </el-descriptions-item>
            </el-descriptions>
          </template>
          
          <!-- 脚本任务特有信息 -->
          <template v-if="task.task_type === 'script'">
            <div class="section-divider">脚本信息</div>
            <el-descriptions :column="1" border>
              <el-descriptions-item label="脚本类型">{{ task.script_type }}</el-descriptions-item>
              <el-descriptions-item label="脚本内容">
                <pre class="code-block">{{ task.script_content }}</pre>
              </el-descriptions-item>
            </el-descriptions>
          </template>
          
          <!-- 命令任务特有信息 -->
          <template v-if="task.task_type === 'command'">
            <div class="section-divider">命令信息</div>
            <el-descriptions :column="1" border>
              <el-descriptions-item label="命令内容">
                <pre class="code-block">{{ task.command }}</pre>
              </el-descriptions-item>
            </el-descriptions>
          </template>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="执行记录" name="executions">
        <el-card class="executions-card">
          <div slot="header">
            <span>执行历史记录</span>
          </div>
          
          <el-table
            :data="executions"
            style="width: 100%"
            v-loading="loadingExecutions"
            border
            stripe
          >
            <el-table-column prop="id" label="ID" width="80"></el-table-column>
            <el-table-column label="状态" width="120">
              <template slot-scope="scope">
                <el-tag :type="getStatusType(scope.row.status)">
                  {{ getStatusLabel(scope.row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="start_time" label="开始时间" width="180">
              <template slot-scope="scope">
                {{ formatDate(scope.row.start_time) }}
              </template>
            </el-table-column>
            <el-table-column prop="end_time" label="结束时间" width="180">
              <template slot-scope="scope">
                {{ scope.row.end_time ? formatDate(scope.row.end_time) : '进行中' }}
              </template>
            </el-table-column>
            <el-table-column prop="result" label="结果" min-width="150"></el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  icon="el-icon-view"
                  @click="viewExecution(scope.row)"
                >查看</el-button>
                <el-button
                  size="mini"
                  type="danger"
                  icon="el-icon-close"
                  @click="terminateExecution(scope.row)"
                  v-if="scope.row.status === 'pending' || scope.row.status === 'running'"
                >终止</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <div class="no-data" v-if="executions.length === 0 && !loadingExecutions">
            <i class="el-icon-info"></i>
            <span>暂无执行记录</span>
          </div>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="权限管理" name="permissions" v-if="canManagePermissions">
        <el-card class="permissions-card">
          <div slot="header">
            <span>任务权限管理</span>
            <el-button 
              style="float: right; padding: 3px 0" 
              type="text" 
              icon="el-icon-plus"
              @click="showAddPermissionDialog">
              添加用户权限
            </el-button>
          </div>
          
          <el-table
            :data="permissions"
            style="width: 100%"
            v-loading="loadingPermissions"
            border
            stripe
          >
            <el-table-column prop="username" label="用户名" width="180"></el-table-column>
            <el-table-column label="查看权限" width="120" align="center">
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.can_view"
                  active-color="#13ce66"
                  @change="updatePermission(scope.row)"
                  :disabled="isUpdatingPermission"
                ></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="执行权限" width="120" align="center">
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.can_execute"
                  active-color="#13ce66"
                  @change="updatePermission(scope.row)"
                  :disabled="isUpdatingPermission"
                ></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="终止权限" width="120" align="center">
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.can_terminate"
                  active-color="#13ce66"
                  @change="updatePermission(scope.row)"
                  :disabled="isUpdatingPermission"
                ></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="删除权限" width="120" align="center">
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.can_delete"
                  active-color="#13ce66"
                  @change="updatePermission(scope.row)"
                  :disabled="isUpdatingPermission"
                ></el-switch>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" fixed="right">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="danger"
                  icon="el-icon-delete"
                  @click="removePermission(scope.row)"
                  :disabled="isUpdatingPermission"
                >删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <div class="no-data" v-if="permissions.length === 0 && !loadingPermissions">
            <i class="el-icon-info"></i>
            <span>暂无其他用户权限设置</span>
          </div>
        </el-card>
      </el-tab-pane>
    </el-tabs>
    
    <!-- 添加用户权限对话框 -->
    <el-dialog
      title="添加用户权限"
      :visible.sync="permissionDialogVisible"
      width="40%">
      <el-form :model="permissionForm" label-width="100px">
        <el-form-item label="选择用户" prop="user_id">
          <el-select v-model="permissionForm.user_id" placeholder="请选择用户" style="width: 100%">
            <el-option
              v-for="user in availableUsers"
              :key="user.id"
              :label="user.username"
              :value="user.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="查看权限">
          <el-switch v-model="permissionForm.can_view"></el-switch>
        </el-form-item>
        <el-form-item label="执行权限">
          <el-switch v-model="permissionForm.can_execute"></el-switch>
        </el-form-item>
        <el-form-item label="终止权限">
          <el-switch v-model="permissionForm.can_terminate"></el-switch>
        </el-form-item>
        <el-form-item label="删除权限">
          <el-switch v-model="permissionForm.can_delete"></el-switch>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="permissionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="addPermission" :loading="isUpdatingPermission">确定</el-button>
      </span>
    </el-dialog>

    <!-- 参数编辑对话框 -->
    <el-dialog
      title="编辑任务参数"
      :visible.sync="paramsDialogVisible"
      width="750px"
      @close="cancelExecute"
    >
      <div v-if="task.task_type === 'jenkins'">
        <div class="params-editor">
          <div v-for="(param, index) in executionParams" :key="index" class="param-item">
            <el-form :inline="false" class="param-form">
              <el-form-item :label="param.name">
                <!-- 选择类型参数 -->
                <el-select 
                  v-if="param.type === 'ChoiceParameterDefinition'" 
                  v-model="param.value" 
                  :placeholder="`选择${param.name}参数值`"
                  style="width: 100%"
                >
                  <el-option 
                    v-for="choice in param.choices" 
                    :key="choice" 
                    :label="choice" 
                    :value="choice"
                  ></el-option>
                </el-select>
                <!-- 布尔类型参数 -->
                <el-switch 
                  v-else-if="param.type === 'BooleanParameterDefinition'"
                  v-model="param.value"
                  active-text="是"
                  inactive-text="否"
                ></el-switch>
                <!-- 默认文本类型参数 -->
                <el-input 
                  v-else
                  v-model="param.value" 
                  type="textarea" 
                  :rows="5"
                  :placeholder="`输入${param.name}参数值`"
                  class="param-textarea"
                ></el-input>
              </el-form-item>
              <el-form-item v-if="param.description" label="描述">
                <el-tooltip :content="param.description" placement="top">
                  <span class="param-description">{{ param.description }}</span>
                </el-tooltip>
              </el-form-item>
            </el-form>
          </div>
          <div v-if="executionParams.length === 0" class="no-params">
            <i class="el-icon-info"></i>
            <p>该任务没有定义参数</p>
          </div>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="cancelExecute">取消</el-button>
        <el-button type="primary" @click="confirmExecute" :loading="executeLoading">确认执行</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TaskDetail',
  props: {
    id: {
      type: [Number, String],
      required: true
    }
  },
  data() {
    return {
      task: {},
      activeTab: 'details',
      loading: false,
      
      // 执行记录相关
      executions: [],
      loadingExecutions: false,
      
      // 权限相关
      permissions: [],
      loadingPermissions: false,
      isUpdatingPermission: false,
      permissionDialogVisible: false,
      permissionForm: {
        user_id: null,
        can_view: true,
        can_execute: false,
        can_terminate: false,
        can_delete: false
      },
      availableUsers: [],
      
      // 任务所有者
      taskOwner: '',

      // 参数对话框相关
      paramsDialogVisible: false,
      executionParams: [],
      jobParameters: [],

      // 执行任务加载状态
      executeLoading: false,
      deleteLoading: false,
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user || {};
    },
    canEdit() {
      return this.currentUser.is_admin || (this.task.user_id === this.currentUser.id);
    },
    canManagePermissions() {
      return this.currentUser.is_admin || (this.task.user_id === this.currentUser.id);
    }
  },
  created() {
    this.loadTaskDetails();
  },
  watch: {
    activeTab(newVal) {
      if (newVal === 'executions') {
        this.loadExecutions();
      } else if (newVal === 'permissions' && this.canManagePermissions) {
        this.loadPermissions();
      }
    }
  },
  methods: {
    // 加载任务详情
    async loadTaskDetails() {
      this.loading = true;
      try {
        const response = await axios.get(`/api/tasks/${this.id}`);
        this.task = response.data;
        
        // 加载任务所有者信息
        if (this.task.user_id) {
          try {
            const userResponse = await axios.get(`/api/users/${this.task.user_id}`);
            this.taskOwner = userResponse.data.username;
          } catch (error) {
            console.error('获取用户信息失败:', error);
            // 直接显示用户ID，不添加前缀
            this.taskOwner = String(this.task.user_id);
          }
        }
        
        this.loading = false;
      } catch (error) {
        this.$message.error('加载任务详情失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loading = false;
        // 返回任务列表页
        this.$router.push('/system/task-manager');
      }
    },
    
    // 加载执行记录
    async loadExecutions() {
      this.loadingExecutions = true;
      try {
        const response = await axios.get(`/api/tasks/${this.id}/executions`);
        this.executions = response.data;
        this.loadingExecutions = false;
      } catch (error) {
        this.$message.error('加载执行记录失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loadingExecutions = false;
      }
    },
    
    // 加载权限设置
    async loadPermissions() {
      this.loadingPermissions = true;
      try {
        const response = await axios.get(`/api/tasks/${this.id}/permissions`);
        this.permissions = response.data.permissions || [];
        
        // 加载可用用户
        await this.loadAvailableUsers();
        
        this.loadingPermissions = false;
      } catch (error) {
        this.$message.error('加载权限设置失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loadingPermissions = false;
      }
    },
    
    // 加载可用用户
    async loadAvailableUsers() {
      try {
        const response = await axios.get('/api/users');
        // 过滤掉已有权限的用户和当前任务所有者
        this.availableUsers = response.data.filter(user => {
          return user.id !== this.task.user_id && 
                 !this.permissions.some(p => p.user_id === user.id);
        });
      } catch (error) {
        this.$message.error('加载用户列表失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      }
    },
    
    // 格式化Jenkins参数为表格数据
    formatJenkinsParams(params) {
      if (!params) return [];
      return Object.keys(params).map(key => ({
        name: key,
        value: params[key]
      }));
    },
    
    // 执行任务
    async executeTask() {
      if (this.task.task_type === 'jenkins') {
        // 获取任务参数
        try {
          this.executeLoading = true;
          
          // 获取Jenkins任务参数
          const params = {
            url: this.task.jenkins_url,
            username: this.task.jenkins_username || '',
            api_token: this.task.jenkins_api_token || '',
            job_name: this.task.jenkins_job_name
          };
          
          const response = await axios.get('/api/jenkins/job/parameters', { params });
          
          // 处理响应
          if (response.data && Array.isArray(response.data)) {
            this.jobParameters = response.data;
            
            // 准备执行参数，使用任务默认参数
            this.executionParams = [];
            const defaultParams = this.task.jenkins_parameters || {};
            
            // 将任务参数与默认值合并
            response.data.forEach(param => {
              this.executionParams.push({
                name: param.name,
                value: defaultParams[param.name] || param.default_value || '',
                description: param.description || '',
                type: param.type || 'string',
                choices: param.choices || [] // 添加选项数组
              });
            });
            
            // 显示参数对话框
            this.paramsDialogVisible = true;
            this.executeLoading = false; // 重要：在显示对话框时重置loading状态
          } else {
            // 没有参数，直接执行
            this.confirmExecute();
          }
        } catch (error) {
          console.error('获取任务参数失败:', error);
          this.$message.error('获取任务参数失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
          this.executeLoading = false;
        }
      } else {
        // 非Jenkins任务，直接执行
        this.confirmExecute();
      }
    },
    
    // 取消执行
    cancelExecute() {
      this.paramsDialogVisible = false;
      this.executeLoading = false;
      this.executionParams = [];
    },
    
    // 确认执行
    async confirmExecute() {
      try {
        this.executeLoading = true;
        
        // 构建参数
        const parameters = {};
        if (this.executionParams.length > 0) {
          this.executionParams.forEach(param => {
            parameters[param.name] = param.value;
          });
        }
        
        // 发送执行请求
        const response = await axios.post(`/api/tasks/${this.id}/execute`, 
          { parameters: Object.keys(parameters).length > 0 ? parameters : undefined }, 
          {
            headers: {
              'Content-Type': 'application/json'
            }
          }
        );
        
        this.$message.success('任务已提交执行');
        
        // 关闭对话框
        this.paramsDialogVisible = false;
        
        // 跳转到执行详情页
        this.$router.push(`/system/task-execution/${response.data.execution_id}`);
      } catch (error) {
        this.$message.error('执行任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      } finally {
        this.executeLoading = false;
      }
    },
    
    // 查看执行详情
    viewExecution(execution) {
      this.$router.push(`/system/task-execution/${execution.id}`);
    },
    
    // 终止执行
    async terminateExecution(execution) {
      try {
        await axios.post(`/api/executions/${execution.id}/terminate`);
        
        this.$message.success('任务已终止');
        
        // 重新加载执行记录
        this.loadExecutions();
      } catch (error) {
        this.$message.error('终止任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      }
    },
    
    // 显示添加权限对话框
    showAddPermissionDialog() {
      this.permissionForm = {
        user_id: null,
        can_view: true,
        can_execute: false,
        can_terminate: false,
        can_delete: false
      };
      this.permissionDialogVisible = true;
    },
    
    // 添加权限
    async addPermission() {
      if (!this.permissionForm.user_id) {
        this.$message.warning('请选择用户');
        return;
      }
      
      this.isUpdatingPermission = true;
      
      try {
        // 获取用户名
        const user = this.availableUsers.find(u => u.id === this.permissionForm.user_id);
        const username = user ? user.username : '';
        
        // 添加到本地数据
        const newPermission = {
          ...this.permissionForm,
          username
        };
        
        this.permissions.push(newPermission);
        
        // 更新权限
        await this.savePermissions();
        
        this.$message.success('权限添加成功');
        this.permissionDialogVisible = false;
        
        // 更新可用用户列表
        await this.loadAvailableUsers();
      } catch (error) {
        this.$message.error('添加权限失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      } finally {
        this.isUpdatingPermission = false;
      }
    },
    
    // 更新权限
    async updatePermission(permission) {
      this.isUpdatingPermission = true;
      
      try {
        await this.savePermissions();
        this.$message.success('权限更新成功');
      } catch (error) {
        this.$message.error('更新权限失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        // 重新加载权限
        await this.loadPermissions();
      } finally {
        this.isUpdatingPermission = false;
      }
    },
    
    // 移除权限
    async removePermission(permission) {
      this.isUpdatingPermission = true;
      
      try {
        // 从本地数据中移除
        const index = this.permissions.findIndex(p => p.user_id === permission.user_id);
        if (index !== -1) {
          this.permissions.splice(index, 1);
        }
        
        // 更新权限
        await this.savePermissions();
        
        this.$message.success('权限移除成功');
        
        // 更新可用用户列表
        await this.loadAvailableUsers();
      } catch (error) {
        this.$message.error('移除权限失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        // 重新加载权限
        await this.loadPermissions();
      } finally {
        this.isUpdatingPermission = false;
      }
    },
    
    // 保存所有权限
    async savePermissions() {
      await axios.post(`/api/tasks/${this.id}/permissions`, {
        permissions: this.permissions
      });
    },
    
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '';
      
      // 创建日期对象
      const date = new Date(dateString);
      
      // 获取UTC时间并添加8小时（东八区）
      const utcTime = date.getTime();
      const beijingTime = new Date(utcTime + 8 * 60 * 60 * 1000);
      
      // 格式化为本地时间字符串
      return beijingTime.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
      });
    },
    
    // 获取任务类型标签
    getTaskTypeLabel(type) {
      const types = {
        'jenkins': 'Jenkins任务',
        'script': '脚本任务',
        'command': '命令任务'
      };
      return types[type] || type;
    },
    
    // 获取任务类型标签样式
    getTaskTypeTag(type) {
      const types = {
        'jenkins': 'primary',
        'script': 'success',
        'command': 'warning'
      };
      return types[type] || '';
    },
    
    // 获取状态标签
    getStatusLabel(status) {
      const statuses = {
        'pending': '待执行',
        'running': '执行中',
        'success': '成功',
        'failed': '失败',
        'terminated': '已终止'
      };
      return statuses[status] || status;
    },
    
    // 获取状态标签样式
    getStatusType(status) {
      const types = {
        'pending': 'info',
        'running': 'primary',
        'success': 'success',
        'failed': 'danger',
        'terminated': 'warning'
      };
      return types[status] || '';
    }
  }
};
</script>

<style scoped>
.task-detail {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
}

.page-title {
  font-size: 24px;
  margin: 0;
  margin-right: 15px;
}

.task-type-tag,
.status-tag {
  margin-right: 10px;
}

.detail-card,
.executions-card,
.permissions-card {
  margin-bottom: 20px;
}

.section-divider {
  font-size: 16px;
  font-weight: bold;
  margin: 20px 0 10px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #EBEEF5;
}

.code-block {
  background-color: #f5f7fa;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  padding: 10px;
  font-family: monospace;
  white-space: pre-wrap;
  word-break: break-all;
  max-height: 300px;
  overflow-y: auto;
}

.no-data {
  padding: 30px 0;
  text-align: center;
  color: #909399;
}

.no-data i {
  font-size: 30px;
  margin-bottom: 10px;
  display: block;
}

.params-table {
  max-width: 100%;
}

.params-table .el-table {
  margin-bottom: 0;
}

.params-editor {
  max-height: 400px;
  overflow-y: auto;
}

.param-item {
  margin-bottom: 10px;
  padding: 10px;
  border-bottom: 1px solid #eee;
}

.param-item:last-child {
  border-bottom: none;
}

.param-form {
  display: flex;
  align-items: center;
}

.param-form .el-form-item {
  margin-bottom: 0;
}

.no-params {
  text-align: center;
  padding: 20px;
  color: #909399;
}

.no-params i {
  font-size: 30px;
  margin-bottom: 10px;
}

.param-description {
  color: #606266;
  font-size: 13px;
  line-height: 1.4;
  display: block;
  word-break: break-word;
}

.param-textarea {
  width: 100%;
  font-family: Consolas, Monaco, monospace;
  font-size: 14px;
  line-height: 1.5;
}

.param-textarea >>> .el-textarea__inner {
  border-radius: 4px;
  border-color: #dcdfe6;
  padding: 10px;
  min-height: 120px !important;
  transition: border-color 0.2s ease;
}

.param-textarea >>> .el-textarea__inner:focus {
  border-color: #409EFF;
}

.param-textarea >>> .el-textarea__inner:hover {
  border-color: #c0c4cc;
}
</style> 