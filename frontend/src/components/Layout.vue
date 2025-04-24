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

    <!-- 添加客户端未连接弹窗 -->
    <el-dialog
      title="客户端连接提示"
      :visible.sync="clientNotConnectedDialogVisible"
      width="360px"
      :close-on-click-modal="false"
      :show-close="false"
      custom-class="client-not-connected-dialog">
      <div class="client-dialog-content">
        <div class="client-dialog-icon">
          <i class="el-icon-warning-outline"></i>
        </div>
        <div class="client-dialog-message">
          <p>检测到客户端未连接</p>
          <ul>
            <li>请确保已安装堡垒机客户端</li>
            <li>如未安装，请点击下载并安装</li>
            <li>如已安装，请点击启动客户端</li>
          </ul>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="downloadClient" size="small">下载客户端</el-button>
        <el-button type="primary" @click="startClient" size="small">启动客户端</el-button>
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
      clientNotConnectedDialogVisible: false,
      clientConfig: {
        // 客户端协议，用于启动客户端应用
        protocol: 'fort://',
        // 客户端端口，用于检测客户端状态
        port: 45654,
        // 客户端下载文件名
        fileName: 'GatekeeperSetup.exe'
      },
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
      consecutiveFailures: 0, // 添加连续失败次数记录
      dialogUpdateTimer: null // 弹窗状态更新定时器
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
    // 添加更新弹窗显示状态的方法
    updateDialogVisibility() {
      console.log('更新弹窗状态，当前客户端状态:', this.statusIcon, '已连接:', this.clientConnected);
      
      // 如果状态图标是成功，强制关闭弹窗
      if (this.statusIcon === 'el-icon-success') {
        this.clientNotConnectedDialogVisible = false;
        console.log('客户端已连接，关闭弹窗');
      }
      
      // 如果客户端已连接，强制关闭弹窗
      if (this.clientConnected) {
        this.clientNotConnectedDialogVisible = false;
        console.log('客户端已连接，关闭弹窗');
      }
    },
    
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
        this.clientNotConnectedDialogVisible = false;
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
      
      // 检查是否处于冷却期（1秒内）且当前未在检查中
      const now = Date.now();
      if (now - this.lastCheckTime < 1000 && !this.checkingStatus) {
        console.log('客户端状态检查过于频繁，忽略本次检查');
        return;
      }
      
      // 更新最后检查时间
      this.lastCheckTime = now;
      
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
          const wasConnected = this.clientConnected;
          this.clientConnected = data.status === 'running' && data.server_connected;
          
          // 保存客户端信息到store
          this.$store.commit('SET_CLIENT_INFO', data);
          
          // 根据连接状态直接控制弹窗
          this.clientNotConnectedDialogVisible = !this.clientConnected;
          
          // 如果连接成功，重置连续失败次数
          if (this.clientConnected) {
            this.consecutiveFailures = 0;
            
            // 强制根据客户端状态更新弹窗
            this.updateDialogVisibility();
            
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
          }
          
          console.log('客户端状态:', data);
        } else {
          this.clientStatus = null;
          this.clientConnected = false;
          this.$store.commit('SET_CLIENT_INFO', null);
          this.consecutiveFailures++;
          this.clientNotConnectedDialogVisible = true;
        }
      } catch (error) {
        this.clientStatus = null;
        this.clientConnected = false;
        this.$store.commit('SET_CLIENT_INFO', null);
        
        if (error.name === 'AbortError') {
          this.consecutiveFailures += 0.5;
          console.log('检查客户端状态超时');
        } else {
          this.consecutiveFailures++;
          console.error('检查客户端状态失败:', error);
        }
        
        this.clientNotConnectedDialogVisible = true;
      } finally {
        this.checkingStatus = false;
        this.statusCheckController = null;
        
        // 检查完成后，再次根据当前状态强制更新弹窗状态
        this.$nextTick(() => {
          this.updateDialogVisibility();
        });
      }
    },
    
    // 在下面的方法中，增加立即检查状态的逻辑
    downloadClient() {
      try {
        // 使用静态的下载链接
        const downloadUrl = '/static/GatekeeperSetup.exe';
        console.log('尝试下载客户端，下载地址:', downloadUrl);
        
        // 显示提示
        this.$message.success('开始下载客户端，请稍候...');
        
        // 使用a标签下载
        const link = document.createElement('a');
        link.href = downloadUrl;
        link.setAttribute('download', 'GatekeeperSetup.exe');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        // 下载后显示提示
        setTimeout(() => {
          this.$confirm('如果下载没有自动开始，请联系管理员获取客户端安装包', '下载提示', {
            confirmButtonText: '确定',
            showCancelButton: false,
            type: 'info'
          });
        }, 3000);
      } catch (error) {
        console.error('下载客户端出错:', error);
        this.$message.error('下载失败，请联系管理员获取客户端安装包');
      }
    },
    
    startClient() {
      // 如果客户端已经连接，则不需要启动
      if (this.clientConnected) {
        this.$message.info('客户端已连接，无需重新启动');
        return;
      }
      
      // 显示正在尝试连接的消息
      this.$message({
        message: '正在尝试启动客户端...',
        type: 'info',
        duration: 3000
      });
      
      // 使用注册的协议启动客户端
      window.location.href = 'fort://start';
      
      // 设置一个短暂的延迟后再次检查客户端状态
      setTimeout(() => {
        console.log('启动客户端后重新检查状态');
        this.checkClientStatus();
      }, 3000);
    },
    
    checkClientInstalled() {
      this.clientInstalled = true;
    },
    
    startStatusCheck() {
      // 如果未登录，不启动检查
      if (!this.isLoggedIn) {
        return;
      }
      
      // 如果已经有定时器在运行，先清除它
      this.stopStatusCheck();

      // 初始化状态
      this.clientNotConnectedDialogVisible = false;
      
      // 更频繁地检查状态（每3秒一次）
      this.statusCheckInterval = setInterval(() => {
        this.checkClientStatus();
      }, 3000);
      
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

      // 重置状态
      this.clientNotConnectedDialogVisible = false;
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
        // 确保弹窗关闭
        this.clientNotConnectedDialogVisible = false;
      }
    },
    // 添加对状态图标的监听
    statusIcon(newIcon) {
      console.log('状态图标变化:', newIcon);
      this.updateDialogVisibility();
    },
    // 监听客户端连接状态变化
    clientConnected(newValue) {
      console.log('客户端连接状态变化:', newValue);
      this.updateDialogVisibility();
    }
  },
  mounted() {
    // 初始化弹窗状态
    this.clientNotConnectedDialogVisible = false;
    
    // 只在登录状态下启动检查
    if (this.isLoggedIn) {
      this.startStatusCheck();
      // 初始化不活动计时器
      this.resetInactivityTimer();
      
      // 启动后主动检查一次状态并更新弹窗
      this.$nextTick(() => {
        this.updateDialogVisibility();
      });
    }
    
    // 创建定时器，每秒检查一次弹窗状态
    this.dialogUpdateTimer = setInterval(() => {
      if (this.isLoggedIn) {
        this.updateDialogVisibility();
      }
    }, 1000);
  },
  beforeDestroy() {
    this.stopStatusCheck();
    // 确保组件销毁时关闭弹窗
    this.clientNotConnectedDialogVisible = false;
    
    // 清除定时器
    if (this.dialogUpdateTimer) {
      clearInterval(this.dialogUpdateTimer);
      this.dialogUpdateTimer = null;
    }
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

/* 添加客户端未连接弹窗的样式 */
.client-not-connected-dialog {
  border-radius: 8px;
}

.client-not-connected-dialog /deep/ .el-dialog__header {
  padding: 12px 20px 8px;
  background-color: #f9f9f9;
  border-bottom: 1px solid #eee;
  border-radius: 8px 8px 0 0;
}

.client-not-connected-dialog /deep/ .el-dialog__title {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.client-not-connected-dialog /deep/ .el-dialog__body {
  padding: 12px 20px;
}

.client-not-connected-dialog /deep/ .el-dialog__footer {
  padding: 8px 20px 12px;
  border-top: 1px solid #f0f0f0;
}

.client-not-connected-dialog .client-dialog-content {
  display: flex;
  padding: 0;
}

.client-not-connected-dialog .client-dialog-icon {
  margin-right: 12px;
  display: flex;
  align-items: flex-start;
  padding-top: 2px;
}

.client-not-connected-dialog .client-dialog-icon i {
  font-size: 20px;
  color: #E6A23C;
}

.client-not-connected-dialog .client-dialog-message {
  flex: 1;
}

.client-not-connected-dialog .client-dialog-message p {
  margin: 0 0 6px;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
}

.client-not-connected-dialog .client-dialog-message ul {
  margin: 0;
  padding-left: 16px;
  color: #606266;
  list-style-type: disc;
}

.client-not-connected-dialog .client-dialog-message li {
  margin-bottom: 4px;
  line-height: 1.4;
  font-size: 13px;
  padding-left: 2px;
}

.client-not-connected-dialog .dialog-footer {
  margin-top: 0;
  text-align: right;
}

.client-not-connected-dialog .dialog-footer .el-button {
  padding: 7px 15px;
}

.client-not-connected-dialog .dialog-footer .el-button + .el-button {
  margin-left: 8px;
}
</style>