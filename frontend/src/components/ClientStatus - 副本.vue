<template>
  <div class="client-status">
    <div v-if="isLoading" class="loading">检查客户端状态中...</div>
    <div v-else>
      <div :class="['status-indicator', getStatusClass]">
        <div class="status-text">{{ statusText }}</div>
        <div v-if="clientStatus" class="status-details">
          <div>本机IP: {{ clientStatus.local_ip || '未知' }}</div>
          <div>
            堡垒机连接: 
            <span :class="{ 'text-success': clientStatus.server_connected, 'text-error': !clientStatus.server_connected }">
              {{ clientStatus.server_connected ? '正常' : '断开' }}
            </span>
          </div>
          <div v-if="clientStatus.version" class="version">
            客户端版本: {{ clientStatus.version }}
          </div>
          <div v-if="clientStatus.last_error" class="error-message">
            错误信息: {{ clientStatus.last_error }}
          </div>
        </div>
      </div>
      <div v-if="!isConnected" class="download-link">
        <a href="/static/gatekeeperclient.exe" class="download-button">下载客户端</a>
        <p class="help-text">安装并运行客户端后，才能使用远程连接功能</p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue'

export default {
  setup() {
    const isConnected = ref(false)
    const clientStatus = ref(null)
    const isLoading = ref(true)
    const checkInterval = ref(null)
    const controller = ref(null)

    const checkLocalClient = async () => {
      // 取消之前的请求（如果有）
      if (controller.value) {
        controller.value.abort()
      }
      
      controller.value = new AbortController()
      const timeout = setTimeout(() => controller.value.abort(), 2000)

      try {
        const response = await fetch('http://127.0.0.1:45654/status', {
          method: 'GET',
          headers: {
            'Accept': 'application/json'
          },
          signal: controller.value.signal
        })
        clearTimeout(timeout)

        if (response.ok) {
          const data = await response.json()
          clientStatus.value = data
          isConnected.value = data.status === 'running' && data.server_connected
          
          // 将状态记录到控制台，便于调试
          console.log('客户端状态:', data)
        } else {
          console.log('客户端响应异常:', response.status)
          isConnected.value = false
          clientStatus.value = null
        }
      } catch (error) {
        isConnected.value = false
        clientStatus.value = null
        if (error.name === 'AbortError') {
          console.log('请求超时，客户端可能未运行')
        } else {
          console.log('请求失败:', error)
        }
      } finally {
        isLoading.value = false
        controller.value = null
      }
    }

    onMounted(() => {
      // 立即检查一次
      checkLocalClient()
      
      // 设置定期检查
      checkInterval.value = setInterval(checkLocalClient, 10000)  // 每10秒检查一次
    })

    onUnmounted(() => {
      if (checkInterval.value) {
        clearInterval(checkInterval.value)
      }
      if (controller.value) {
        controller.value.abort()
      }
    })

    const getStatusClass = computed(() => {
      if (!clientStatus.value) return 'disconnected'
      if (!clientStatus.value.server_connected) return 'warning'
      return 'connected'
    })

    const statusText = computed(() => {
      if (!clientStatus.value) return '客户端未运行'
      if (clientStatus.value.status === 'stopped') return '客户端已停止'
      if (!clientStatus.value.server_connected) return '堡垒机连接断开'
      return '客户端已连接'
    })

    return {
      isConnected,
      clientStatus,
      isLoading,
      statusText,
      getStatusClass
    }
  }
}
</script>

<style scoped>
.client-status {
  padding: 16px;
  border: 1px solid #dcdfe6;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  background-color: #fff;
}

.status-indicator {
  padding: 12px 16px;
  border-radius: 6px;
  margin-bottom: 16px;
}

.status-indicator.disconnected {
  background-color: #fef0f0;
  color: #f56c6c;
  border-left: 4px solid #f56c6c;
}

.status-indicator.warning {
  background-color: #fdf6ec;
  color: #e6a23c;
  border-left: 4px solid #e6a23c;
}

.status-indicator.connected {
  background-color: #f0f9eb;
  color: #67c23a;
  border-left: 4px solid #67c23a;
}

.status-text {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 8px;
}

.status-details {
  margin-top: 12px;
  font-size: 14px;
  color: #606266;
  line-height: 1.8;
}

.text-success {
  color: #67c23a;
  font-weight: 500;
}

.text-error {
  color: #f56c6c;
  font-weight: 500;
}

.error-message {
  color: #f56c6c;
  margin-top: 8px;
  padding: 8px;
  background-color: rgba(245, 108, 108, 0.05);
  border-radius: 4px;
}

.version {
  font-size: 13px;
  color: #909399;
}

.download-link {
  margin-top: 16px;
  text-align: center;
  padding: 16px;
  background-color: #f5f7fa;
  border-radius: 6px;
}

.download-button {
  display: inline-block;
  background-color: #409eff;
  color: #fff;
  padding: 10px 20px;
  text-decoration: none;
  border-radius: 4px;
  font-weight: 500;
  transition: background-color 0.3s;
}

.download-button:hover {
  background-color: #66b1ff;
  text-decoration: none;
}

.help-text {
  margin-top: 8px;
  font-size: 13px;
  color: #909399;
}

.loading {
  text-align: center;
  color: #606266;
  font-size: 14px;
  padding: 20px;
}
</style>