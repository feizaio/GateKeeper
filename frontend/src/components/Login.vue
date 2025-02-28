<template>
  <div class="login-container">
    <el-card class="login-card">
      <div class="title">
        <h2>堡垒机管理系统</h2>
      </div>
      <el-form :model="loginForm" :rules="rules" ref="loginForm" @submit.native.prevent="handleLogin">
        <el-form-item prop="username">
          <el-input 
            v-model="loginForm.username" 
            prefix-icon="el-icon-user"
            placeholder="用户名">
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input 
            v-model="loginForm.password" 
            prefix-icon="el-icon-lock"
            type="password"
            placeholder="密码"
            @keyup.enter.native="handleLogin">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" 
                     native-type="submit" 
                     style="width: 100%"
                     :loading="loading"
                     @click="handleLogin">
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      loading: false,
      loginForm: {
        username: '',
        password: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    async handleLogin() {
      this.loading = true;  // 开始加载状态
      try {
        const response = await axios.post('/api/auth/login', this.loginForm);
        localStorage.setItem('token', response.data.token);  // 存储token
        this.$store.commit('SET_USER', response.data.user); // 更新用户状态
        this.$message.success('登录成功');
        console.log('跳转到首页')
        this.$router.push('/');  // 登录成功后跳转到首页
      } catch (error) {
        console.error('登录失败:', error);
        let errorMessage = '登录失败';
        if (error.response) {
          errorMessage = error.response.data.error || '服务器错误';
        } else if (error.request) {
          errorMessage = '网络错误，请检查网络连接';
        } else {
          errorMessage = error.message || '未知错误';
        }
        this.$message.error(errorMessage);
      } finally {
        this.loading = false;  // 结束加载状态
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #409EFF, #67C23A);
}

.login-card {
  width: 400px;
  padding: 20px;
}

.title {
  text-align: center;
  margin-bottom: 30px;
}

.title h2 {
  color: #409EFF;
}

.el-button {
  transition: all 0.3s;
}

.el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}

.el-input {
  margin-bottom: 5px;
}
</style>