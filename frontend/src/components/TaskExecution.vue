<template>
  <div class="task-execution">
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">任务执行详情</h2>
        <el-tag :type="getStatusType(execution.status)" class="status-tag">
          {{ getStatusLabel(execution.status) }}
        </el-tag>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-back" @click="goBack">
          返回
        </el-button>
        <el-button 
          type="danger" 
          icon="el-icon-close" 
          @click="terminateExecution"
          v-if="canTerminate">
          终止执行
        </el-button>
      </div>
    </div>

    <el-row :gutter="20">
      <el-col :span="8">
        <el-card class="info-card">
          <div slot="header">
            <span>执行信息</span>
          </div>
          
          <el-descriptions direction="vertical" :column="1" border>
            <el-descriptions-item label="执行ID">{{ execution.id }}</el-descriptions-item>
            <el-descriptions-item label="任务名称">
              <router-link :to="`/system/task-detail/${execution.task_id}`">
                {{ task.name }}
              </router-link>
            </el-descriptions-item>
            <el-descriptions-item label="任务类型">{{ getTaskTypeLabel(task.task_type) }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="getStatusType(execution.status)">
                {{ getStatusLabel(execution.status) }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="开始时间">{{ formatDate(execution.start_time) }}</el-descriptions-item>
            <el-descriptions-item label="结束时间">
              {{ execution.end_time ? formatDate(execution.end_time) : '进行中' }}
            </el-descriptions-item>
            <el-descriptions-item label="执行用户">{{ executionUser }}</el-descriptions-item>
            <el-descriptions-item label="执行结果">{{ execution.result || '无结果' }}</el-descriptions-item>
          </el-descriptions>
          
          <!-- Jenkins特有信息 -->
          <template v-if="task.task_type === 'jenkins' && execution.jenkins_build_number">
            <div class="section-divider">Jenkins构建信息</div>
            <el-descriptions direction="vertical" :column="1" border>
              <el-descriptions-item label="构建号">{{ execution.jenkins_build_number }}</el-descriptions-item>
              <el-descriptions-item label="构建URL">
                <a :href="execution.jenkins_build_url" target="_blank">{{ execution.jenkins_build_url }}</a>
              </el-descriptions-item>
              <el-descriptions-item label="执行参数" v-if="Object.keys(execution.jenkins_parameters || {}).length > 0">
                <div class="params-table">
                  <el-table :data="formatJenkinsParams(execution.jenkins_parameters)" border size="small">
                    <el-table-column prop="name" label="参数名" width="180"></el-table-column>
                    <el-table-column prop="value" label="参数值"></el-table-column>
                  </el-table>
                </div>
              </el-descriptions-item>
            </el-descriptions>
          </template>
        </el-card>
      </el-col>
      
      <el-col :span="16">
        <el-card class="log-card">
          <div slot="header" class="log-header">
            <span>执行日志</span>
            <div class="log-actions">
              <el-switch
                v-model="autoScroll"
                active-text="自动滚动"
                inactive-text="手动滚动"
              ></el-switch>
              <el-button 
                size="mini" 
                type="text" 
                icon="el-icon-refresh" 
                @click="refreshLog"
                :loading="loadingLog">
                刷新
              </el-button>
            </div>
          </div>
          
          <div 
            class="log-content" 
            ref="logContainer"
            v-loading="loadingLog"
            element-loading-text="加载日志中..."
          >
            <pre v-if="logContent">{{ logContent }}</pre>
            <div v-else class="no-log">
              <i class="el-icon-document"></i>
              <span>暂无日志内容</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios';
import io from 'socket.io-client';

export default {
  name: 'TaskExecution',
  props: {
    id: {
      type: [Number, String],
      required: true
    }
  },
  data() {
    return {
      execution: {},
      task: {},
      logContent: '',
      loadingExecution: false,
      loadingLog: false,
      autoScroll: true,
      socket: null,
      executionUser: '',
      refreshInterval: null
    };
  },
  computed: {
    canTerminate() {
      return ['pending', 'running'].includes(this.execution.status);
    },
    currentUser() {
      return this.$store.state.user || {};
    }
  },
  created() {
    this.loadExecutionDetails();
  },
  mounted() {
    // 设置自动刷新
    this.refreshInterval = setInterval(() => {
      if (this.canTerminate) {
        this.refreshExecution();
      }
    }, 5000);
    
    // 连接WebSocket
    this.connectWebSocket();
  },
  beforeDestroy() {
    // 清除自动刷新
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
    
    // 断开WebSocket连接
    if (this.socket) {
      this.socket.disconnect();
    }
  },
  methods: {
    // 加载执行详情
    async loadExecutionDetails() {
      this.loadingExecution = true;
      try {
        // 获取执行记录
        const response = await axios.get(`/api/executions/${this.id}`);
        this.execution = response.data;
        
        // 获取任务详情
        const taskResponse = await axios.get(`/api/tasks/${this.execution.task_id}`);
        this.task = taskResponse.data;
        
        // 获取执行用户信息
        if (this.execution.user_id) {
          try {
            const userResponse = await axios.get(`/api/users/${this.execution.user_id}`);
            this.executionUser = userResponse.data.username;
          } catch (error) {
            console.error('获取用户信息失败:', error);
            // 直接显示用户ID，不添加前缀
            this.executionUser = String(this.execution.user_id);
          }
        }
        
        // 加载日志
        this.loadLog();
        
        this.loadingExecution = false;
      } catch (error) {
        this.$message.error('加载执行详情失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loadingExecution = false;
        // 返回任务详情页
        this.$router.push(`/system/task-detail/${this.execution.task_id}`);
      }
    },
    
    // 刷新执行状态
    async refreshExecution() {
      try {
        const response = await axios.get(`/api/executions/${this.id}`);
        this.execution = response.data;
        
        // 如果任务已经完成，清除自动刷新
        if (!this.canTerminate && this.refreshInterval) {
          clearInterval(this.refreshInterval);
        }
      } catch (error) {
        console.error('刷新执行状态失败:', error);
      }
    },
    
    // 加载日志
    async loadLog() {
      this.loadingLog = true;
      try {
        const response = await axios.get(`/api/executions/${this.id}/log`);
        this.logContent = response.data.log_content || '';
        
        // 自动滚动到底部
        if (this.autoScroll) {
          this.$nextTick(() => {
            this.scrollToBottom();
          });
        }
        
        this.loadingLog = false;
      } catch (error) {
        this.$message.error('加载日志失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loadingLog = false;
      }
    },
    
    // 刷新日志
    refreshLog() {
      this.loadLog();
    },
    
    // 终止执行
    async terminateExecution() {
      try {
        // 显示确认对话框
        await this.$confirm(
          '确定要终止此任务执行吗？如果是Jenkins任务，可能需要一些时间才能完全停止。',
          '终止任务',
          {
            confirmButtonText: '确定终止',
            cancelButtonText: '取消',
            type: 'warning'
          }
        );
        
        // 用户确认后，发送终止请求
        const response = await axios.post(`/api/executions/${this.id}/terminate`);
        
        // 显示响应消息
        this.$message.success(response.data.message || '任务已终止');
        
        // 刷新执行状态
        this.refreshExecution();
        
        // 如果有警告信息，显示通知
        if (response.data.message && response.data.message.includes('Jenkins构建可能仍在运行')) {
          this.$notify({
            title: '警告',
            message: 'Jenkins构建可能无法完全终止，系统已尝试所有可能的终止方法。',
            type: 'warning',
            duration: 10000
          });
        }
      } catch (error) {
        // 如果用户取消了确认对话框，不显示错误
        if (error === 'cancel' || error.toString().includes('cancel')) {
          return;
        }
        
        // 显示错误信息
        this.$message.error('终止任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        
        // 如果是Jenkins任务，显示额外提示
        if (this.task.task_type === 'jenkins') {
          this.$notify({
            title: '提示',
            message: '您可以尝试直接在Jenkins界面中终止此构建。',
            type: 'info',
            duration: 10000
          });
        }
      }
    },
    
    // 连接WebSocket
    connectWebSocket() {
      // 创建Socket.IO连接
      const socketUrl = `${window.location.protocol}//${window.location.host}`;
      this.socket = io(socketUrl);
      
      // 监听日志更新事件
      this.socket.on(`task_log_update_${this.id}`, data => {
        if (data.new_content) {
          this.logContent += data.new_content;
          
          // 自动滚动到底部
          if (this.autoScroll) {
            this.$nextTick(() => {
              this.scrollToBottom();
            });
          }
        }
        
        // 如果任务完成，刷新执行状态
        if (data.complete) {
          this.refreshExecution();
        }
      });
      
      // 监听任务完成事件
      this.socket.on(`task_complete_${this.id}`, data => {
        // 更新执行状态
        this.execution.status = data.status;
        this.execution.result = data.result;
        this.execution.end_time = new Date().toISOString();
        
        // 显示通知
        this.$notify({
          title: '任务执行完成',
          message: `任务执行结果: ${data.result || '未知'}`,
          type: data.status === 'success' ? 'success' : 'warning',
          duration: 5000
        });
      });
    },
    
    // 滚动到日志底部
    scrollToBottom() {
      const container = this.$refs.logContainer;
      if (container) {
        container.scrollTop = container.scrollHeight;
      }
    },
    
    // 返回上一页
    goBack() {
      if (this.$route.query.from === 'list') {
        this.$router.push('/system/task-manager');
      } else {
        this.$router.push(`/system/task-detail/${this.execution.task_id}`);
      }
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
    },

    // 格式化Jenkins参数为表格数据
    formatJenkinsParams(params) {
      if (!params) return [];
      return Object.keys(params).map(key => ({
        name: key,
        value: params[key]
      }));
    }
  }
};
</script>

<style scoped>
.task-execution {
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

.status-tag {
  margin-right: 10px;
}

.info-card,
.log-card {
  margin-bottom: 20px;
}

.section-divider {
  font-size: 16px;
  font-weight: bold;
  margin: 20px 0 10px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #EBEEF5;
}

.log-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.log-actions {
  display: flex;
  align-items: center;
}

.log-actions .el-switch {
  margin-right: 15px;
}

.log-content {
  height: 600px;
  overflow-y: auto;
  background-color: #1e1e1e;
  color: #f0f0f0;
  padding: 10px;
  font-family: monospace;
  border-radius: 4px;
}

.log-content pre {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-all;
}

.no-log {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: #909399;
}

.no-log i {
  font-size: 48px;
  margin-bottom: 10px;
}

.params-table {
  max-width: 100%;
}

.params-table .el-table {
  margin-bottom: 0;
}
</style> 