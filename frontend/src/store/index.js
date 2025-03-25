import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: localStorage.getItem('token') || '',
    user: JSON.parse(localStorage.getItem('user')) || null,
    clientInfo: null,
    clientDialogVisible: false
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
    },
    
    SET_CLIENT_INFO(state, clientInfo) {
      state.clientInfo = clientInfo
    },
    
    SET_CLIENT_DIALOG_VISIBLE(state, visible) {
      state.clientDialogVisible = visible
    }
  },
  
  actions: {
    async login({ commit }, credentials) {
      const response = await axios.post('/api/auth/login', credentials)
      const { token, username } = response.data
      commit('setToken', token)
      commit('setUser', { username })
      
      // 设置全局请求头
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    },
    
    logout({ commit }) {
      commit('clearUserInfo')
      delete axios.defaults.headers.common['Authorization']
    }
  }
}) 