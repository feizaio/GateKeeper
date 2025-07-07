<template>
  <div class="audit-logs-container">
    <div class="page-header">
      <h1>审计日志</h1>
      <div class="controls">
        <el-button type="primary" size="small" icon="el-icon-refresh" @click="getLogs">刷新</el-button>
      </div>
    </div>

    <!-- 过滤器 -->
    <div class="filter-section">
      <el-form :inline="true" :model="filters" class="filter-form">
        <el-form-item label="用户:">
          <el-select v-model="filters.userId" placeholder="所有用户" clearable>
            <el-option
              v-for="user in users"
              :key="user.id"
              :label="user.username"
              :value="user.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="操作:">
          <el-select v-model="filters.action" placeholder="所有操作" clearable>
            <el-option label="登录" value="login"></el-option>
            <el-option label="注销" value="logout"></el-option>
            <el-option label="连接服务器" value="connect"></el-option>
            <el-option label="断开服务器" value="disconnect"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围:">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            @change="handleDateChange">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleFilter">筛选</el-button>
          <el-button @click="resetFilter">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 日志表格 -->
    <el-table
      v-loading="loading"
      :data="logs"
      border
      stripe
      style="width: 100%">
      <el-table-column
        prop="username"
        label="用户名"
        width="120">
      </el-table-column>
      <el-table-column
        prop="action"
        label="操作类型"
        width="120">
        <template slot-scope="scope">
          <el-tag
            :type="getActionTagType(scope.row.action)">
            {{ getActionText(scope.row.action) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="server_name"
        label="服务器名称"
        width="150">
      </el-table-column>
      <el-table-column
        prop="server_ip"
        label="服务器IP"
        width="140">
      </el-table-column>
      <el-table-column
        prop="client_ip"
        label="客户端IP"
        width="140">
      </el-table-column>
      <el-table-column
        prop="details"
        label="详细信息"
        min-width="250">
      </el-table-column>
      <el-table-column
        prop="created_at"
        label="时间"
        width="170"
        :formatter="formatDate">
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[8, 16, 24, 50]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total">
      </el-pagination>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'AuditLogs',
  data() {
    return {
      logs: [],
      loading: false,
      users: [],
      filters: {
        userId: '',
        action: '',
        startDate: '',
        endDate: ''
      },
      dateRange: [],
      currentPage: 1,
      pageSize: 8,
      total: 0
    };
  },
  created() {
    this.getLogs();
    this.getUsers();
  },
  methods: {
    async getLogs() {
      this.loading = true;
      try {
        const params = {
          page: this.currentPage,
          per_page: this.pageSize,
          user_id: this.filters.userId || undefined,
          action: this.filters.action || undefined,
          start_date: this.filters.startDate || undefined,
          end_date: this.filters.endDate || undefined
        };

        const response = await axios.get('/api/auth/logs', { params });
        this.logs = response.data.logs;
        this.total = response.data.total;
      } catch (error) {
        console.error('获取审计日志失败:', error);
        this.$message.error('获取审计日志失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      } finally {
        this.loading = false;
      }
    },
    async getUsers() {
      try {
        const response = await axios.get('/api/users');
        this.users = response.data;
      } catch (error) {
        console.error('获取用户列表失败:', error);
      }
    },
    handleFilter() {
      this.currentPage = 1;
      this.getLogs();
    },
    resetFilter() {
      this.filters = {
        userId: '',
        action: '',
        startDate: '',
        endDate: ''
      };
      this.dateRange = [];
      this.currentPage = 1;
      this.getLogs();
    },
    handleDateChange(val) {
      if (val) {
        this.filters.startDate = val[0];
        this.filters.endDate = val[1];
      } else {
        this.filters.startDate = '';
        this.filters.endDate = '';
      }
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.getLogs();
    },
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getLogs();
    },
    formatDate(row, column) {
      return row.created_at;
    },
    getActionText(action) {
      const actions = {
        'login': '登录',
        'logout': '注销',
        'connect': '连接',
        'disconnect': '断开'
      };
      return actions[action] || action;
    },
    getActionTagType(action) {
      const types = {
        'login': 'success',
        'logout': 'info',
        'connect': 'primary',
        'disconnect': 'warning'
      };
      return types[action] || '';
    }
  }
};
</script>

<style scoped>
.audit-logs-container {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.filter-section {
  margin-bottom: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
}
</style> 