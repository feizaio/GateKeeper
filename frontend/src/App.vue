<template>
  <div id="app">
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
  async created() {
    try {
      const response = await axios.get('/api/auth/check');
      this.$store.commit('setUser', response.data);
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