<template>
  <div class="dashboard-container">
    <h1>仪表盘</h1>
    
    <!-- 统计卡片 -->
    <div class="stat-cards">
      <el-card class="stat-card" shadow="hover">
        <div class="stat-card-content">
          <div class="stat-card-value">{{ dashboardData.total_servers }}</div>
          <div class="stat-card-label">总资产</div>
        </div>
        <div class="stat-card-icon">
          <i class="el-icon-monitor"></i>
        </div>
      </el-card>
      
      <el-card class="stat-card" shadow="hover">
        <div class="stat-card-content">
          <div class="stat-card-value">{{ dashboardData.total_users }}</div>
          <div class="stat-card-label">在线用户</div>
        </div>
        <div class="stat-card-icon">
          <i class="el-icon-user"></i>
        </div>
      </el-card>
      
      <el-card class="stat-card" shadow="hover">
        <div class="stat-card-content">
          <div class="stat-card-value">{{ dashboardData.today_activities }}</div>
          <div class="stat-card-label">今日会话</div>
        </div>
        <div class="stat-card-icon">
          <i class="el-icon-data-line"></i>
        </div>
      </el-card>
      
      <el-card class="stat-card" shadow="hover">
        <div class="stat-card-content">
          <div class="stat-card-value">{{ dashboardData.alerts }}</div>
          <div class="stat-card-label">告警事件</div>
        </div>
        <div class="stat-card-icon warning">
          <i class="el-icon-warning"></i>
        </div>
      </el-card>
    </div>
    
    <!-- 图表区域 -->
    <div class="chart-container">
      <!-- 资产类型分布 -->
      <el-card class="chart-card" shadow="hover">
        <div slot="header" class="chart-header">
          <span>资产类型分布</span>
        </div>
        <div class="chart-content" id="asset-type-chart"></div>
      </el-card>
      
      <!-- 会话趋势 -->
      <el-card class="chart-card" shadow="hover">
        <div slot="header" class="chart-header">
          <span>会话趋势</span>
        </div>
        <div class="chart-content" id="activity-trend-chart"></div>
      </el-card>
    </div>
    
    <!-- 最新活动日志 -->
    <el-card class="log-card" shadow="hover">
      <div slot="header" class="log-header">
        <span>最新活动日志</span>
      </div>
      <div class="table-container">
        <el-table :data="dashboardData.recent_activities" style="width: 100%" stripe>
          <el-table-column prop="time" label="时间" width="180"></el-table-column>
          <el-table-column prop="user" label="用户" width="120"></el-table-column>
          <el-table-column prop="action" label="操作" width="120">
            <template slot-scope="scope">
              <span>{{ formatAction(scope.row.action) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="server" label="资产" width="180"></el-table-column>
          <el-table-column prop="ip" label="IP地址" width="140"></el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === 'success' ? 'success' : 'danger'" size="mini">
                {{ scope.row.status === 'success' ? '成功' : '失败' }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>
  </div>
</template>

<script>
import axios from 'axios';
import * as echarts from 'echarts';

export default {
  name: 'Dashboard',
  data() {
    return {
      dashboardData: {
        total_servers: 0,
        total_users: 0,
        today_activities: 0,
        alerts: 0,
        server_type_distribution: {},
        activity_trend: [],
        recent_activities: []
      },
      assetTypeChart: null,
      activityTrendChart: null,
      refreshInterval: null
    };
  },
  mounted() {
    this.fetchDashboardData();
    // 每60秒刷新一次数据
    this.refreshInterval = setInterval(() => {
      this.fetchDashboardData();
    }, 60000);
    
    // 监听窗口大小变化，重新调整图表大小
    window.addEventListener('resize', this.resizeCharts);
  },
  beforeDestroy() {
    // 组件销毁前清除定时器
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
    
    // 移除事件监听
    window.removeEventListener('resize', this.resizeCharts);
    
    // 销毁图表实例
    if (this.assetTypeChart) {
      this.assetTypeChart.dispose();
    }
    if (this.activityTrendChart) {
      this.activityTrendChart.dispose();
    }
  },
  methods: {
    async fetchDashboardData() {
      try {
        // 使用真实API调用获取数据
        const response = await axios.get('/api/dashboard/stats');
        this.dashboardData = response.data;
        
        this.$nextTick(() => {
          this.initCharts();
        });
      } catch (error) {
        console.error('获取仪表盘数据失败:', error);
        this.$message.error('获取仪表盘数据失败');
      }
    },
    
    initCharts() {
      this.initAssetTypeChart();
      this.initActivityTrendChart();
    },
    
    initAssetTypeChart() {
      // 初始化资产类型分布图表
      const chartDom = document.getElementById('asset-type-chart');
      if (!chartDom) return;
      
      this.assetTypeChart = echarts.init(chartDom);
      
      const data = [];
      const typeMap = {
        'Windows': 'Windows 服务器',
        'Linux': 'Linux 服务器',
        'Network': '网络设备',
        'Other': '其他'
      };
      
      for (const [type, count] of Object.entries(this.dashboardData.server_type_distribution)) {
        data.push({
          value: count,
          name: typeMap[type] || type
        });
      }
      
      const option = {
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          data: data.map(item => item.name)
        },
        series: [
          {
            name: '资产类型',
            type: 'pie',
            radius: ['50%', '70%'],
            avoidLabelOverlap: false,
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '18',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: data
          }
        ],
        color: ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399']
      };
      
      this.assetTypeChart.setOption(option);
    },
    
    initActivityTrendChart() {
      // 初始化活动趋势图表
      const chartDom = document.getElementById('activity-trend-chart');
      if (!chartDom) return;
      
      this.activityTrendChart = echarts.init(chartDom);
      
      const xAxisData = this.dashboardData.activity_trend.map(item => item.date);
      const seriesData = this.dashboardData.activity_trend.map(item => item.count);
      
      const option = {
        title: {
          text: '近7天会话趋势',
          left: 'center',
          textStyle: {
            fontSize: 14,
            fontWeight: 'normal'
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow',
            label: {
              backgroundColor: '#6a7985'
            }
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: [
          {
            type: 'category',
            data: xAxisData,
            axisLabel: {
              interval: 0,
              rotate: 0
            }
          }
        ],
        yAxis: [
          {
            type: 'value',
            name: '会话数'
          }
        ],
        series: [
          {
            name: '会话数',
            type: 'bar',
            emphasis: {
              focus: 'series'
            },
            data: seriesData,
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0, color: '#83bff6'},
                {offset: 0.5, color: '#188df0'},
                {offset: 1, color: '#188df0'}
              ])
            }
          }
        ]
      };
      
      this.activityTrendChart.setOption(option);
    },
    
    resizeCharts() {
      if (this.assetTypeChart) {
        this.assetTypeChart.resize();
      }
      if (this.activityTrendChart) {
        this.activityTrendChart.resize();
      }
    },
    
    formatAction(action) {
      const actionMap = {
        'login': '登录',
        'logout': '登出',
        'connect': '连接',
        'disconnect': '断开',
        'login_failed': '登录失败',
        'connect_failed': '连接失败'
      };
      
      return actionMap[action] || action;
    }
  }
};
</script>

<style scoped>
.dashboard-container {
  padding: 0;
  width: 100%;
}

.stat-cards {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 20px;
}

.stat-card {
  flex: 1;
  min-width: 220px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
}

.stat-card-content {
  display: flex;
  flex-direction: column;
}

.stat-card-value {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-card-label {
  font-size: 14px;
  color: #909399;
}

.stat-card-icon {
  font-size: 48px;
  color: #409EFF;
  opacity: 0.7;
}

.stat-card-icon.warning {
  color: #E6A23C;
}

.chart-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 20px;
}

.chart-card {
  flex: 1;
  min-width: 45%;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart-content {
  height: 300px;
}

.log-card {
  margin-bottom: 20px;
}

.log-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-container {
  width: 100%;
  overflow-x: auto;
}

@media (max-width: 768px) {
  .stat-card {
    min-width: 100%;
  }
  
  .chart-card {
    min-width: 100%;
  }
}
</style> 