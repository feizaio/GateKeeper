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
    try {
      const response = await axios.get('/api/auth/check');
      this.$store.commit('setUser', response.data);
      // 如果登录状态有效，初始化自动登出计时器
      this.$store.dispatch('startInactivityTimer');
    } catch (error) {
      console.error('Auth check failed:', error);
      this.$router.push('/login'); // 重定向到登录页
    } finally {
      this.isLoading = false;
    }
  }
}
</script>

<style>
#app {
  height: 100vh;
  margin: 0;
  padding: 0;
}

body {
  margin: 0;
  padding: 0;
  font-family: Arial, sans-serif;
  background-color: #f5f5f5;
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