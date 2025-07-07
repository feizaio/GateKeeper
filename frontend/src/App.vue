<template>
  <div id="app" @mousemove="resetInactivityTimer" @click="resetInactivityTimer" @keydown="resetInactivityTimer">
    <div v-if="isLoading" class="loading">加载中...</div>
    <router-view v-else></router-view>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'App',
  data() {
    return {
      isLoading: true
    };
  },
  methods: {
    // 添加重置不活动计时器的方法
    resetInactivityTimer() {
      // 只有在用户已登录的情况下才重置计时器
      if (this.$store.state.user) {
        this.$store.dispatch('resetInactivityTimer');
      }
    }
  },
  async created() {
    // 首先检查localStorage中是否有token
    const token = localStorage.getItem('token');
    
    if (token) {
      // 设置axios请求头
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      
      try {
        // 验证token有效性
        const response = await axios.get('/api/auth/check');
        // 更新用户状态
        this.$store.commit('setUser', response.data);
        // 如果登录状态有效，初始化自动登出计时器
        this.$store.dispatch('startInactivityTimer');
      } catch (error) {
        console.error('Auth check failed:', error);
        // 清除无效的token
        localStorage.removeItem('token');
        this.$store.commit('clearUserInfo');
        this.$router.push('/login');
      }
    } else {
      // 没有token，直接跳转到登录页
      if (this.$router.currentRoute.path !== '/login') {
        this.$router.push('/login');
      }
    }
    
    // 完成加载
    this.isLoading = false;
  }
}
</script>

<style>
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  overflow: hidden;
  font-family: Arial, sans-serif;
  background-color: #f5f5f5;
}

#app {
  height: 100vh;
  width: 100vw;
  margin: 0;
  padding: 0;
  overflow: hidden;
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-size: 18px;
  color: #409EFF;
}
</style>