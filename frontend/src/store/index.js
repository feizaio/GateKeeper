import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import router from '../router'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: localStorage.getItem('token') || '',
    user: JSON.parse(localStorage.getItem('user')) || null,
    clientInfo: null,
    clientDialogVisible: false,
    inactivityTimer: null,
    inactivityTimeout: 30 * 60 * 1000 // 30分钟，转换为毫秒
  },
  
  mutations: {
    setToken(state, token) {
      state.token = token
      localStorage.setItem('token', token)
    },
    
    setUser(state, user) {
      state.user = user
      localStorage.setItem('user', JSON.stringify(user))
    },
    
    clearUserInfo(state) {
      state.token = ''
      state.user = null
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      // 清除不活动计时器
      if (state.inactivityTimer) {
        clearTimeout(state.inactivityTimer)
        state.inactivityTimer = null
      }
    },
    
    SET_CLIENT_INFO(state, clientInfo) {
      state.clientInfo = clientInfo
    },
    
    SET_CLIENT_DIALOG_VISIBLE(state, visible) {
      state.clientDialogVisible = visible
    },
    
    SET_INACTIVITY_TIMER(state, timer) {
      state.inactivityTimer = timer
    }
  },
  
  actions: {
    async login({ commit, dispatch }, credentials) {
      const response = await axios.post('/api/auth/login', credentials)
      const { token, username } = response.data
      commit('setToken', token)
      commit('setUser', { username })
      
      // 设置全局请求头
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
      
      // 登录后启动不活动计时器
      dispatch('startInactivityTimer')
    },
    
    logout({ commit }) {
      commit('clearUserInfo')
      delete axios.defaults.headers.common['Authorization']
    },
    
    // 启动自动登出计时器
    startInactivityTimer({ state, dispatch }) {
      // 清除现有计时器
      if (state.inactivityTimer) {
        clearTimeout(state.inactivityTimer)
      }
      
      // 设置新的计时器
      const timer = setTimeout(() => {
        // 30分钟后自动登出
        dispatch('autoLogout')
      }, state.inactivityTimeout)
      
      // 保存计时器ID
      state.inactivityTimer = timer
    },
    
    // 自动登出处理
    autoLogout({ dispatch }) {
      // 显示提示信息
      Vue.prototype.$message.warning('由于长时间未操作，系统已自动退出登录')
      // 执行登出
      dispatch('logout')
      // 跳转到登录页
      router.push('/login')
    },
    
    // 重置自动登出计时器
    resetInactivityTimer({ dispatch }) {
      dispatch('startInactivityTimer')
    }
  }
}) 