<template>
  <div class="layout" @mousemove="resetInactivityTimer" @click="checkAndResetTimer" @keydown="resetInactivityTimer">
    <el-container>
      <el-header height="50px">
        <div class="header-content">
          <div class="client-status">
            <el-tooltip :content="statusText" placement="bottom">
              <i :class="['client-icon', statusIcon]"></i>
            </el-tooltip>
          </div>
          <span class="header-title">堡垒机管理系统</span>
          
          <!-- 用户信息下拉菜单 -->
          <div class="user-dropdown">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info">
                <i class="el-icon-user-solid"></i>
                <span>{{ currentUser.username }}</span>
                <i class="el-icon-caret-bottom"></i>
              </div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="changePassword">
                  <i class="el-icon-key"></i>
                  <span>修改密码</span>
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <i class="el-icon-switch-button"></i>
                  <span>退出登录</span>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </el-header>
      
      <el-container>
        <el-aside width="180px">
          <el-menu
            :default-active="$route.path"
            class="el-menu-vertical"
            router>
            <el-menu-item index="/">
              <i class="el-icon-monitor"></i>
              <span>服务器管理</span>
            </el-menu-item>
            
            <el-submenu index="2">
              <template slot="title">
                <i class="el-icon-setting"></i>
                <span>系统设置</span>
              </template>
              <el-menu-item index="/users">
                <i class="el-icon-user"></i>
                <span>用户管理</span>
              </el-menu-item>
              <el-menu-item index="/system/categories" v-if="isAdmin">
                <i class="el-icon-collection-tag"></i>
                <span>分类管理</span>
              </el-menu-item>
            </el-submenu>
          </el-menu>
        </el-aside>
        
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
    </el-container>

    <!-- 修改密码对话框 -->
    <el-dialog
      title="修改密码"
      :visible.sync="passwordDialogVisible"
      width="400px"
      :close-on-click-modal="false">
      <el-form
        :model="passwordForm"
        :rules="passwordRules"
        ref="passwordForm"
        label-width="100px">
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="passwordForm.oldPassword"
            type="password"
            show-password
            placeholder="请输入原密码">
          </el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            show-password
            placeholder="请输入新密码">
          </el-input>
        </el-form-item>
        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            show-password
            placeholder="请再次输入新密码">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="passwordDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitPasswordChange">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 客户端下载提示对话框 -->
    <el-dialog
      title="堡垒机客户端提示"
      :visible.sync="showClientDialog"
      width="450px">
      <div class="client-dialog-content">
        <div class="client-dialog-icon">
          <i class="el-icon-warning-outline"></i>
        </div>
        <div class="client-dialog-message">
          <p>检测到堡垒机客户端未连接，您需要：</p>
          <ol>
            <li>确保客户端正常运行后再使用远程连接功能</li>
            <li>如未安装，请点击"下载客户端"，下载后手动运行安装程序</li>
            <li>如已安装，请点击"启动客户端"</li>
          </ol>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showClientDialog = false">取消</el-button>
        <el-button type="primary" @click="startClient">启动客户端</el-button>
        <el-button type="success" @click="downloadClient">下载客户端</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Layout',
  data() {
    // 密码确认验证函数
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的密码不一致'));
      } else {
        callback();
      }
    };

    return {
      clientConnected: false,
      clientStatus: null,
      checkingStatus: false,
      showClientDialog: false,
      passwordDialogVisible: false,
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能小于6个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      statusCheckController: null,
      lastCheckTime: 0, // 添加上次检查时间记录
      consecutiveFailures: 0 // 添加连续失败次数记录
    }
  },
  computed: {
    statusIcon() {
      if (this.checkingStatus) return 'el-icon-loading';
      if (!this.clientStatus) return 'el-icon-error';
      return this.clientStatus.server_connected ? 'el-icon-success' : 'el-icon-warning';
    },
    statusText() {
      if (this.checkingStatus) return '正在检查客户端状态...';
      if (!this.clientStatus) return '客户端未连接';
      if (!this.clientStatus.server_connected) return '堡垒机连接断开';
      return '客户端已连接';
    },
    isLoggedIn() {
      return this.$store.state.user !== null;
    },
    isAdmin() {
      return this.$store.state.user && this.$store.state.user.is_admin;
    },
    currentUser() {
      return this.$store.state.user || { username: '' };
    }
  },
  methods: {
    // 重置不活动计时器
    resetInactivityTimer() {
      // 使用Vuex action重置计时器
      this.$store.dispatch('resetInactivityTimer');
    },
    
    // 检查客户端状态并重置计时器
    checkAndResetTimer() {
      this.resetInactivityTimer();
      
      // 如果最后一次检查是在3秒前，且当前未在检查中，则立即检查
      const now = Date.now();
      if (now - this.lastCheckTime > 3000 && !this.checkingStatus) {
        this.checkClientStatus();
      }
    },
    async handleLogout() {
      try {
        // 调用注销接口
        await axios.post('/api/auth/logout');
        // 清除本地存储的 token 和用户信息
        localStorage.removeItem('token');
        this.$store.commit('SET_USER', null);
        // 停止状态检查
        this.stopStatusCheck();
        // 重置状态
        this.clientConnected = false;
        this.clientStatus = null;
        this.checkingStatus = false;
        this.showClientDialog = false;
        // 跳转到登录页面
        this.$router.push('/login');
        this.$message.success('注销成功');
      } catch (error) {
        console.error('注销失败:', error);
        const errorMessage = error.response && error.response.data && error.response.data.error || error.message;
        this.$message.error('注销失败: ' + errorMessage);
      }
    },
    async checkClientStatus() {
      // 如果未登录，不执行检查
      if (!this.isLoggedIn) {
        return;
      }
      
      // 更新最后检查时间
      this.lastCheckTime = Date.now();
      
      // 记录检查前的连接状态
      const wasConnected = this.clientConnected;
      
      try {
        // 设置正在检查状态
        this.checkingStatus = true;

        // 取消之前的请求（如果有）
        if (this.statusCheckController) {
          this.statusCheckController.abort();
        }
        
        // 创建新的 AbortController
        this.statusCheckController = new AbortController();
        const timeout = setTimeout(() => this.statusCheckController.abort(), 1500);
        
        // 直接从本地客户端获取状态
        const response = await fetch('http://127.0.0.1:45654/status', {
          method: 'GET',
          headers: {
            'Accept': 'application/json'
          },
          signal: this.statusCheckController.signal
        });
        
        clearTimeout(timeout);
        
        if (response.ok) {
          const data = await response.json();
          this.clientStatus = data;
          this.clientConnected = data.status === 'running' && data.server_connected;
          
          // 保存客户端信息到store
          this.$store.commit('SET_CLIENT_INFO', data);
          
          // 如果连接成功，重置连续失败次数
          if (this.clientConnected) {
            this.consecutiveFailures = 0;
            // 如果之前未连接，现在连接成功，显示连接成功提示
            if (!wasConnected) {
              this.$notify({
                title: '客户端已连接',
                message: '堡垒机客户端连接成功',
                type: 'success',
                duration: 3000,
                position: 'top-right'
              });
            }
          } else {
            // 即使请求成功，但如果客户端未真正连接，也计为失败
            this.consecutiveFailures++;
            this.handleClientDisconnected();
          }
          
          console.log('客户端状态:', data);
        } else {
          this.clientStatus = null;
          this.clientConnected = false;
          this.$store.commit('SET_CLIENT_INFO', null);
          
          // 增加连续失败次数
          this.consecutiveFailures++;
          
          // 处理客户端断开连接情况
          this.handleClientDisconnected();
        }
      } catch (error) {
        this.clientStatus = null;
        this.clientConnected = false;
        this.$store.commit('SET_CLIENT_INFO', null);
        
        // 对任何错误（包括AbortError）都增加连续失败次数，但权重不同
        if (error.name === 'AbortError') {
          // 超时错误也算作失败，但增加幅度较小
          this.consecutiveFailures += 0.5;
          console.log('检查客户端状态超时');
        } else {
          this.consecutiveFailures++;
          console.error('检查客户端状态失败:', error);
        }
        
        // 处理客户端断开连接情况
        this.handleClientDisconnected();
      } finally {
        this.checkingStatus = false;
        this.statusCheckController = null;
      }
    },
    
    // 新增：处理客户端断开连接的方法
    handleClientDisconnected() {
      // 当连续失败次数达到阈值或状态明确为断开连接时，显示提示
      const shouldShowDialog = this.consecutiveFailures >= 1;
      
      // 如果客户端状态确定为未连接，并且对话框没有显示，则显示对话框
      if (shouldShowDialog) {
        // 弹窗在一定时间后自动关闭的话，这里可以直接重新显示
        if (!this.showClientDialog) {
          this.showClientDialog = true;
          this.$store.commit('SET_CLIENT_DIALOG_VISIBLE', true);
          
          // 添加通知提醒
          this.$notify({
            title: '客户端未连接',
            message: '需要安装或启动堡垒机客户端',
            type: 'warning',
            duration: 5000,
            position: 'top-right'
          });
        }
      }
    },
    
    // 在下面的方法中，增加立即检查状态的逻辑
    downloadClient() {
      window.location.href = '/static/GatekeeperSetup.exe';
      this.showClientDialog = false;
      
      // 设置一个稍长的延迟，等待用户可能完成下载和安装
      setTimeout(() => {
        this.checkClientStatus();
      }, 30000); // 30秒后检查，给用户时间安装客户端
    },
    
    startClient() {
      // 尝试通过特定协议启动已安装的客户端应用程序
      window.location.href = 'gatekeeper://start';
      
      // 显示正在启动的消息
      this.$message({
        message: '正在尝试启动客户端...',
        type: 'info',
        duration: 3000
      });
      
      // 设置一个短暂的延迟后再次检查客户端状态
      setTimeout(() => {
        this.checkClientStatus();
      }, 3000);
      
      this.showClientDialog = false;
    },
    
    startStatusCheck() {
      // 如果未登录，不启动检查
      if (!this.isLoggedIn) {
        return;
      }
      
      // 如果已经有定时器在运行，先清除它
      this.stopStatusCheck();
      
      // 更频繁地检查状态（每3秒一次）
      this.statusCheckInterval = setInterval(() => {
        this.checkClientStatus();
      }, 3000); // 将检查间隔从5秒减少到3秒
      
      // 立即执行一次检查
      this.checkClientStatus();
    },
    stopStatusCheck() {
      if (this.statusCheckInterval) {
        clearInterval(this.statusCheckInterval);
        this.statusCheckInterval = null;
      }
      
      // 取消进行中的请求
      if (this.statusCheckController) {
        this.statusCheckController.abort();
        this.statusCheckController = null;
      }
    },
    handleCommand(command) {
      switch (command) {
        case 'changePassword':
          this.showChangePasswordDialog();
          break;
        case 'logout':
          this.handleLogout();
          break;
      }
    },
    showChangePasswordDialog() {
      this.passwordDialogVisible = true;
      this.passwordForm = {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      };
    },
    async submitPasswordChange() {
      try {
        await this.$refs.passwordForm.validate();
        
        const response = await this.axios.post('/api/auth/change-password', {
          old_password: this.passwordForm.oldPassword,
          new_password: this.passwordForm.newPassword
        });

        if (response.data.success) {
          this.$message.success('密码修改成功');
          this.passwordDialogVisible = false;
        }
      } catch (error) {
        if (error.response) {
          this.$message.error(error.response.data.error || '密码修改失败');
        } else if (error.message) {
          // 表单验证错误
          this.$message.error(error.message);
        } else {
          this.$message.error('密码修改失败');
        }
      }
    }
  },
  watch: {
    // 监听登录状态变化
    isLoggedIn(newValue) {
      if (newValue) {
        this.startStatusCheck();
        // 初始化不活动计时器
        this.resetInactivityTimer();
      } else {
        this.stopStatusCheck();
      }
    }
  },
  mounted() {
    // 只在登录状态下启动检查
    if (this.isLoggedIn) {
      this.startStatusCheck();
      // 初始化不活动计时器
      this.resetInactivityTimer();
    }
  },
  beforeDestroy() {
    this.stopStatusCheck();
  }
}
</script>

<style scoped>
.layout {
  height: 100vh;
  background-color: #f0f2f5;
}

.el-aside {
  background: linear-gradient(180deg, #F8FAFF 0%, #F0F5FF 100%);
  height: 100vh;
  box-shadow: 1px 0 8px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  width: 180px !important;
}

.el-menu {
  border-right: none;
  background: transparent;
  padding-top: 12px;
  flex: 1;
  width: 180px;
}

.el-menu-item {
  height: 48px;
  line-height: 48px;
  color: #5B6B8B !important;
  margin: 4px 12px;
  padding: 0 16px !important;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.el-menu-item:hover {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.08) !important;
  transform: translateX(4px);
}

.el-menu-item.is-active {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.12) !important;
  font-weight: 500;
}

.el-submenu /deep/ .el-submenu__title {
  height: 48px;
  line-height: 48px;
  color: #5B6B8B !important;
  margin: 4px 12px;
  padding: 0 16px !important;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.el-submenu /deep/ .el-submenu__title:hover {
  color: #4B7BE5 !important;
  background-color: rgba(75, 123, 229, 0.08) !important;
  transform: translateX(4px);
}

.el-submenu.is-active /deep/ .el-submenu__title {
  color: #4B7BE5 !important;
}

.el-submenu /deep/ .el-menu {
  background-color: transparent !important;
  padding-left: 8px;
  margin: 0 8px;
  border-radius: 8px;
}

.el-menu-item i, .el-submenu /deep/ .el-submenu__title i {
  margin-right: 12px;
  width: 18px;
  font-size: 18px;
  color: inherit;
  transition: all 0.3s ease;
}

.header-content {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 24px;
  background: linear-gradient(90deg, #5B8FF9 0%, #4B7BE5 100%);
  position: relative;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.header-title {
  color: #fff;
  font-size: 18px;
  font-weight: 500;
  letter-spacing: 0.5px;
  opacity: 0.95;
  margin-left: 20px;
}

.user-dropdown {
  margin-left: auto;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 6px 16px;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  transition: all 0.3s ease;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.2);
}

.user-info i {
  color: #fff;
  font-size: 16px;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 6px 14px; /* 调整 */
  cursor: pointer;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); /* 调整 */
  gap: 6px; /* 新增 */
}

.el-dropdown-menu {
  min-width: 140px; /* 新增 */
  border-radius: 6px; /* 调整 */
  margin-top: 4px; /* 减少间距 */
}

.el-dropdown-menu__item {
  align-items: center; /* 新增 */
  padding: 8px 16px; /* 调整 */
  font-size: 13px; /* 可选：调小字号 */
}

.el-dropdown-menu__item i {
  margin-right: 8px; /* 调整 */
  width: 18px; /* 新增 */
  font-size: 16px; /* 调整 */
}

.el-dropdown-menu__item.is-divided {
  border-top: 1px solid #ebeef5;
  margin: 4px 0;
  padding-top: 8px; /* 调整 */
}

.el-header {
  padding: 0;
  height: 60px !important;
  box-shadow: 0 1px 4px rgba(0,21,41,0.08);
  z-index: 10;
  position: relative;
}

.el-main {
  padding: 20px;
  background-color: #F8FAFF;
}

.client-status {
  display: flex;
  align-items: center;
  margin-right: 24px;
  padding: 6px 12px;
  background: rgba(255,255,255,0.1);
  border-radius: 20px;
  backdrop-filter: blur(5px);
  transition: all 0.3s ease;
}

.client-status:hover {
  background: rgba(255,255,255,0.15);
}

.client-icon {
  font-size: 16px;
  color: rgba(255,255,255,0.85);
  transition: all 0.3s ease;
}

.client-icon.el-icon-success {
  color: #67C23A;
  text-shadow: 0 0 8px rgba(103, 194, 58, 0.3);
}

.client-icon.el-icon-error {
  color: #F56C6C;
  text-shadow: 0 0 8px rgba(245, 108, 108, 0.3);
}

.client-icon.el-icon-loading {
  color: #409EFF;
  text-shadow: 0 0 8px rgba(64, 158, 255, 0.3);
}

/* 客户端对话框样式 */
.client-dialog-content {
  display: flex;
  padding: 10px;
}

.client-dialog-icon {
  margin-right: 15px;
  display: flex;
  align-items: flex-start;
  padding-top: 5px;
}

.client-dialog-icon i {
  font-size: 24px;
  color: #E6A23C;
  animation: pulse 2s infinite;
}

.client-dialog-message {
  flex: 1;
}

.client-dialog-message p {
  margin-top: 0;
  margin-bottom: 10px;
  font-weight: 500;
  color: #303133;
}

.client-dialog-message ol {
  margin: 0;
  padding-left: 20px;
  color: #606266;
}

.client-dialog-message li {
  margin-bottom: 8px;
  line-height: 1.5;
}

@keyframes pulse {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0.6;
  }
  100% {
    opacity: 1;
  }
}

/* 增加对话框中按钮的间距 */
.dialog-footer .el-button {
  margin-left: 10px;
}
</style>