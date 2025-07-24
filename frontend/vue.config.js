module.exports = {
    devServer: {
      proxy: {
        '/api': {  // 确保代理路径与后端 API 前缀匹配
          target: 'http://10.16.30.223:5000',  // 后端地址
          changeOrigin: true
        }
      }
    }
  }