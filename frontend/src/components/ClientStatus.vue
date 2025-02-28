<template>
  <div class="client-status">
    <div v-if="isLoading" class="loading">检查客户端状态中...</div>
    <div v-else>
      <div :class="['status-indicator', getStatusClass]">
        <div class="status-text">{{ statusText }}</div>
        <div v-if="clientStatus" class="status-details">
          <div>本机IP: {{ clientStatus.local_ip }}</div>
          <div>
            堡垒机连接: 
            <span :class="{ 'text-success': clientStatus.server_connected, 'text-error': !clientStatus.server_connected }">
              {{ clientStatus.server_connected ? '正常' : '断开' }}
            </span>
          </div>
          <div v-if="clientStatus.last_error" class="error-message">
            {{ clientStatus.last_error }}
          </div>
        </div>
      </div>
      <div v-if="!isConnected" class="download-link">
        <a href="/static/fortress_client.exe">下载客户端</a>
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
        } else {
          isConnected.value = false
          clientStatus.value = null
        }
      } catch (error) {
        isConnected.value = false
        clientStatus.value = null
        if (error.name === 'AbortError') {
          console.log('请求超时')
        } else {
          console.log('请求失败:', error)
        }
      } finally {
        isLoading.value = false
      }
    }

    onMounted(() => {
      checkLocalClient()
      checkInterval.value = setInterval(checkLocalClient, 5000)  // 每5秒检查一次
    })

    onUnmounted(() => {
      if (checkInterval.value) {
        clearInterval(checkInterval.value)
      }
      if (controller.value) {
        controller.value.abort()
      }
    })

    const getStatusClass = computed(() => ({
      'connected': isConnected.value,
      'disconnected': !isConnected.value
    }))

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
  padding: 10px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
}

.status-indicator {
  padding: 10px;
}

.status-indicator.disconnected {
  background-color: #fef0f0;
  color: #f56c6c;
}

.status-indicator.connected {
  background-color: #f0f9eb;
  color: #67c23a;
}

.status-details {
  margin-top: 10px;
  font-size: 14px;
  color: #606266;
}

.text-success {
  color: #67c23a;
}

.text-error {
  color: #f56c6c;
}

.error-message {
  color: #f56c6c;
  margin-top: 5px;
}

.download-link {
  margin-top: 10px;
  text-align: center;
}

.download-link a {
  color: #409eff;
  text-decoration: none;
}

.download-link a:hover {
  text-decoration: underline;
}

.loading {
  text-align: center;
  color: #606266;
  font-size: 14px;
}
</style>