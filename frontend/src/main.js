import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import axios from 'axios'

Vue.use(ElementUI)
Vue.config.productionTip = false

// 配置axios默认值
axios.defaults.baseURL = process.env.VUE_APP_API_URL || ''
axios.defaults.withCredentials = true  // 添加这行，允许跨域请求携带 cookie

// 设置全局请求拦截器
axios.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
axios.interceptors.response.use(
  response => response,
  error => {
    if (error.response && error.response.status === 401) {
      // 如果响应状态码为 401（未授权），则触发注销操作
      store.dispatch('logout').then(() => {
        // 清除本地存储的 token
        localStorage.removeItem('token');
        // 跳转到登录页面
        router.push('/login');
      });
    }
    return Promise.reject(error);
  }
);

// 将 axios 挂载到 Vue 原型上，方便全局调用
Vue.prototype.axios = axios;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app');