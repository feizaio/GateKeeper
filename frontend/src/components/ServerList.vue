<template>
  <div class="server-list-container">
    <!-- 左侧分类树 -->
    <div class="category-tree" :class="{ 'category-tree-collapsed': isMobile && !showSidebar }">
      <div class="sidebar-toggle" v-if="isMobile" @click="toggleSidebar">
        <i :class="showSidebar ? 'el-icon-arrow-left' : 'el-icon-arrow-right'"></i>
      </div>
      <el-tree
        v-show="!isMobile || showSidebar"
        :data="categoryTree"
        :props="defaultProps"
        @node-click="handleNodeClick"
        default-expand-all
        highlight-current>
      </el-tree>
    </div>

    <!-- 右侧服务器列表 -->
    <div class="server-list">
      <!-- 只有管理员才能看到添加服务器按钮 -->
      <div class="toolbar" v-if="isAdmin">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索服务器名称或IP"
          clearable
          style="width: 260px; margin-right: 16px;"
          @input="currentPage = 1"
        >
          <i slot="prefix" class="el-icon-search"></i>
        </el-input>
        <el-button type="primary" @click="showAddDialog">
          <i class="el-icon-plus"></i> 添加服务器
        </el-button>
      </div>

      <el-table 
        :data="paginatedServers" 
        style="width: 100%"
        :max-height="tableMaxHeight"
        @sort-change="handleSortChange">
        <el-table-column prop="name" label="名称" min-width="180" sortable="custom" />
        <el-table-column prop="ip" label="IP地址" min-width="120" sortable="custom" />
        <el-table-column prop="type" label="类型" min-width="100" align="center" sortable="custom">
          <template slot-scope="scope">
            <el-tag 
              :type="scope.row.type === 'Windows' ? 'primary' : 'success'"
              size="medium"
              effect="plain">
              {{ scope.row.type }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" min-width="150" align="center">
          <template slot-scope="scope">
            <el-tag 
              v-if="scope.row.in_use"
              :type="scope.row.in_use_by_me ? 'warning' : 'danger'"
              size="medium"
              effect="plain">
              {{ scope.row.in_use_by_me ? '我正在使用中' : `${scope.row.in_use_by_username} 正在使用中` }}
            </el-tag>
            <el-tag 
              v-else 
              type="success"
              size="medium"
              effect="plain">
              空闲
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="200">
          <template slot-scope="scope">
            <el-tooltip class="item" effect="dark" :content="scope.row.remark" placement="top">
              <div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                {{ scope.row.remark }}
              </div>
            </el-tooltip>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="280" align="center">
          <template slot-scope="scope">
            <div class="action-buttons">
              <el-button 
                type="primary" 
                size="mini" 
                @click="connectServer(scope.row)"
                :disabled="scope.row.in_use && !scope.row.in_use_by_me"
                :type="scope.row.type === 'Windows' ? 'primary' : 'success'"
                plain>
                <i :class="scope.row.type === 'Windows' ? 'el-icon-monitor' : 'el-icon-terminal'"></i>
                {{ scope.row.type === 'Windows' ? 'RDP连接' : 'SSH连接' }}
              </el-button>
              <el-button
                v-if="isAdmin"
                type="warning"
                size="mini"
                @click="showEditDialog(scope.row)"
                plain>
                <i class="el-icon-edit"></i>
                编辑
              </el-button>
              <el-button
                v-if="isAdmin"
                type="danger"
                size="mini"
                @click="deleteServer(scope.row)"
                plain>
                <i class="el-icon-delete"></i>
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页组件 -->
      <div class="pagination-container">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[8, 10, 20, 50, 100]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="filteredServers.length">
        </el-pagination>
      </div>

      <!-- 添加/编辑服务器对话框 -->
      <el-dialog 
        :title="isEdit ? '编辑服务器' : '添加服务器'" 
        :visible.sync="dialogVisible" 
        :width="isMobile ? '95%' : '600px'"
        custom-class="server-dialog"
        :close-on-click-modal="false">
        <el-form 
          :model="serverForm" 
          ref="serverForm" 
          :rules="rules"
          :label-width="isMobile ? '70px' : '80px'"
          class="server-form">
          <div class="form-row" :class="{ 'form-row-mobile': isMobile }">
            <el-form-item label="名称" prop="name" class="form-item">
              <el-input v-model="serverForm.name" placeholder="请输入服务器名称"></el-input>
            </el-form-item>
            <el-form-item label="IP地址" prop="ip" class="form-item">
              <el-input v-model="serverForm.ip" placeholder="请输入IP地址"></el-input>
            </el-form-item>
          </div>
          <div class="form-row" :class="{ 'form-row-mobile': isMobile }">
            <el-form-item label="类型" prop="type" class="form-item">
              <el-select v-model="serverForm.type" placeholder="请选择服务器类型" style="width: 100%" @change="updateDefaultPort">
                <el-option label="Windows" value="Windows"></el-option>
                <el-option label="Linux" value="Linux"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="端口" prop="port" class="form-item">
              <el-input v-model.number="serverForm.port" type="number" placeholder="请输入端口号"></el-input>
            </el-form-item>
          </div>
          <el-form-item label="备注" prop="remark">
            <el-input v-model="serverForm.remark" type="textarea" placeholder="请输入备注信息"></el-input>
          </el-form-item>
          <el-form-item label="凭据" prop="credential_id">
            <el-select 
              v-model="serverForm.credential_id" 
              placeholder="选择预设凭据" 
              style="width: 100%"
              @change="handleCredentialChange"
              clearable>
              <el-option 
                v-for="item in credentialOptions" 
                :key="item.id" 
                :label="item.name" 
                :value="item.id">
                <span style="float: left">{{ item.name }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">{{ item.username }}</span>
              </el-option>
            </el-select>
            <div class="form-tip">选择预设凭据后，用户名和密码将自动填充</div>
          </el-form-item>
          
          <div class="form-credentials" v-if="!serverForm.credential_id">
            <div class="form-row" :class="{ 'form-row-mobile': isMobile }">
              <el-form-item label="用户名" prop="username" class="form-item">
                <el-input v-model="serverForm.username" placeholder="请输入用户名"></el-input>
              </el-form-item>
              <el-form-item :label="isEdit ? '新密码' : '密码'" prop="password" class="form-item">
                <el-input 
                  type="password" 
                  v-model="serverForm.password" 
                  placeholder="请输入密码"
                  show-password>
                  <template slot="append">
                    <el-button @click="generatePassword" type="text">生成</el-button>
                  </template>
                </el-input>
                <div class="form-tip" v-if="isEdit">留空表示不修改密码</div>
              </el-form-item>
            </div>
          </div>
          <div class="form-credentials" v-else>
            <div class="credential-info">
              <el-alert
                title="使用预设凭据"
                type="info"
                :closable="false">
                <div>当前选择的预设凭据：<b>{{ selectedCredentialName }}</b></div>
                <div>用户名：{{ selectedCredentialUsername }}</div>
              </el-alert>
            </div>
          </div>

          <el-form-item label="分类" prop="category_id">
            <el-select 
              v-model="serverForm.category_id" 
              placeholder="选择分类" 
              style="width: 100%"
              @change="handleCategoryChange">
              <el-option 
                v-for="item in categories" 
                :key="item.id" 
                :label="item.name" 
                :value="item.id">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="submitForm">确 定</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      servers: [],
      dialogVisible: false,
      serverForm: {
        name: '',
        ip: '',
        type: 'Windows',
        port: 3389,
        username: '',
        password: '',
        credential_id: null,
        category_id: null,
        remark: ''
      },
      rules: {
        name: [{ required: true, message: '请输入服务器名称', trigger: 'blur' }],
        ip: [{ required: true, message: '请输入IP地址', trigger: 'blur' }],
        type: [{ required: true, message: '请选择服务器类型', trigger: 'change' }],
        port: [
          { required: true, message: '请输入端口号', trigger: 'blur' },
          { type: 'number', message: '端口必须为数字', trigger: 'blur' },
          { validator: (rule, value, callback) => {
              if (value < 1 || value > 65535) {
                callback(new Error('端口号必须在1-65535之间'));
              } else {
                callback();
              }
            }, 
            trigger: 'blur' 
          }
        ],
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ 
          validator: (rule, value, callback) => {
            if (!this.isEdit && !value) {
              callback(new Error('请输入密码'));
            } else {
              callback();
            }
          },
          trigger: 'blur' 
        }]
      },
      activeConnections: {},  // 存储活动连接的 token
      heartbeatTimer: null,
      refreshInterval: null,
      categories: [],
      selectedCategory: null,
      categoryTree: [{
        id: 'all',
        label: '全部服务器'
      }],
      defaultProps: {
        children: 'children',
        label: 'label'
      },
      isEdit: false,
      editingServerId: null,
      // 新增分页相关
      currentPage: 1,
      pageSize: 8,
      // 自适应相关
      windowWidth: 0,
      isMobile: false,
      showSidebar: true,
      tableMaxHeight: 500,
      // 排序相关
      sortColumn: null,
      sortOrder: null,
      // 凭据相关
      credentials: [],
      selectedCredentialName: '',
      selectedCredentialUsername: '',
      // 搜索关键字
      searchKeyword: ''
    }
  },

  computed: {
    isAdmin() {
      return this.$store.state.user && this.$store.state.user.is_admin;
    },
    isLoggedIn() {
      return this.$store.state.user !== null;
    },
    filteredServers() {
      let servers = [];
      if (!this.selectedCategory || this.selectedCategory.id === 'all') {
        servers = this.servers;
      } else {
        servers = this.servers.filter(server => server.category_id === this.selectedCategory.id);
      }
      if (this.searchKeyword) {
        const keyword = this.searchKeyword.trim().toLowerCase();
        servers = servers.filter(server =>
          (server.name && server.name.toLowerCase().includes(keyword)) ||
          (server.ip && server.ip.toLowerCase().includes(keyword))
        );
      }
      return servers;
    },
    // 添加分页计算属性
    paginatedServers() {
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      
      // 对筛选后的服务器进行排序
      let sortedServers = [...this.filteredServers];
      if (this.sortColumn && this.sortOrder) {
        sortedServers.sort((a, b) => {
          const aValue = a[this.sortColumn];
          const bValue = b[this.sortColumn];
          
          if (typeof aValue === 'string') {
            if (this.sortOrder === 'ascending') {
              return aValue.localeCompare(bValue);
            } else {
              return bValue.localeCompare(aValue);
            }
          } else {
            if (this.sortOrder === 'ascending') {
              return aValue - bValue;
            } else {
              return bValue - aValue;
            }
          }
        });
      }
      
      return sortedServers.slice(start, end);
    },
    credentialOptions() {
      return this.credentials;
    }
  },

  methods: {
    updateDefaultPort() {
      // 根据服务器类型更新默认端口
      if (this.serverForm.type === 'Windows') {
        this.serverForm.port = 3389;
      } else if (this.serverForm.type === 'Linux') {
        this.serverForm.port = 22;
      }
    },
    
    async loadServers() {
      // 如果未登录，不加载服务器列表
      if (!this.isLoggedIn) {
        return;
      }
      
      try {
        const response = await this.axios.get('/api/servers');
        console.log('获取的服务器列表:', response.data); // 添加调试日志
        this.servers = response.data;
      } catch (error) {
        // 只在登录状态下显示错误消息
        if (this.isLoggedIn) {
          this.$message.error('获取服务器列表失败');
        }
      }
    },

    showAddDialog() {
      this.isEdit = false;
      this.editingServerId = null;
      this.dialogVisible = true;
      this.serverForm = {
        name: '',
        ip: '',
        type: 'Windows',
        port: 3389, // 默认为Windows RDP端口
        username: '',
        password: '',
        credential_id: null,
        category_id: null,
        remark: ''
      };
      this.selectedCredentialName = '';
      this.selectedCredentialUsername = '';
    },

    showEditDialog(server) {
      this.isEdit = true;
      this.editingServerId = server.id;
      this.dialogVisible = true;
      this.serverForm = {
        name: server.name,
        ip: server.ip,
        type: server.type,
        port: server.port || (server.type === 'Windows' ? 3389 : 22), // 根据类型设置默认端口
        username: server.username,
        password: '', // 编辑时密码为空
        credential_id: server.credential_id || null,
        category_id: server.category_id || null,
        remark: server.remark || ''
      };
      
      if (server.credential_id) {
        this.handleCredentialChange(server.credential_id);
      } else {
        this.selectedCredentialName = '';
        this.selectedCredentialUsername = '';
      }
    },

    async loadCategories() {
      try {
        const response = await this.axios.get('/api/categories');
        this.categories = response.data;
        // 更新分类树
        this.categoryTree = [{
          id: 'all',
          label: '全部服务器'
        }, ...this.categories.map(category => ({
          id: category.id,
          label: category.name
        }))];
      } catch (error) {
        this.$message.error('获取分类列表失败');
      }
    },

    async loadCredentials() {
      try {
        const response = await this.axios.get('/api/credentials');
        this.credentials = response.data;
      } catch (error) {
        console.error('获取凭据列表失败', error);
      }
    },

    async submitForm() {
      try {
        const valid = await this.$refs.serverForm.validate();
        if (valid) {
          if (this.isEdit) {
            // 更新服务器
            try {
              console.log('提交的表单数据:', this.serverForm); // 添加调试日志
              const response = await this.axios.put(`/api/servers/${this.editingServerId}`, this.serverForm);
              console.log('服务器更新响应:', response.data); // 添加调试日志
              if (response.data) {
                this.$message.success('更新服务器成功');
                this.dialogVisible = false;
                this.loadServers();
              }
            } catch (error) {
              const errorMsg = error.response && error.response.data && error.response.data.error 
                ? error.response.data.error 
                : '未知错误';
              this.$message.error(`更新服务器失败: ${errorMsg}`);
              console.error('更新服务器错误:', error);
            }
          } else {
            // 添加服务器
            try {
              console.log('提交的表单数据:', this.serverForm); // 添加调试日志
              const response = await this.axios.post('/api/servers', this.serverForm);
              console.log('服务器添加响应:', response.data); // 添加调试日志
              this.$message.success('添加服务器成功');
              this.dialogVisible = false;
              this.loadServers();
            } catch (error) {
              const errorMsg = error.response && error.response.data && error.response.data.error 
                ? error.response.data.error 
                : '未知错误';
              this.$message.error(`添加服务器失败: ${errorMsg}`);
              console.error('添加服务器错误:', error);
            }
          }
        }
      } catch (error) {
        console.error('表单验证错误:', error);
        this.$message.error('表单验证失败，请检查输入');
      }
    },

    async deleteServer(server) {
      try {
        await this.$confirm('确认删除该服务器?', '提示', {
          type: 'warning'
        });
        await this.axios.delete(`/api/servers/${server.id}`);
        this.$message.success('删除成功');
        this.loadServers();
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('删除失败');
        }
      }
    },

    async connectServer(server) {
      try {
        if (server.type === 'Windows') {
          // 获取服务器密码（已加密）
          const passwordResponse = await this.axios.get(`/api/servers/${server.id}/password`);
          const encryptedPassword = passwordResponse.data.password;
          const isEncrypted = passwordResponse.data.encrypted || false;

          // 发起 RDP 连接
          const response = await this.axios.post('/api/rdp/connect', {
            server_id: server.id,
            username: server.username,
            password: encryptedPassword,
            is_encrypted: isEncrypted
          });

          if (response.data.success) {
            this.$message.success('RDP 连接请求已发送');
          }
        } else {
          // Linux SSH 连接
          await this.connectSSH(server);
        }
      } catch (error) {
        this.$message.error('连接失败：' + (error.response && error.response.data ? error.response.data.error : error.message));
      }
    },

    async connectSSH(server) {
      try {
        // 获取服务器密码（已加密）
        const passwordResponse = await this.axios.get(`/api/servers/${server.id}/password`);
        const encryptedPassword = passwordResponse.data.password;
        const isEncrypted = passwordResponse.data.encrypted || false;
        
        // 通过后端API发起SSH连接请求
        const response = await this.axios.post('/api/ssh/connect', {
          server_id: server.id,
          password: encryptedPassword,
          is_encrypted: isEncrypted
        });
        
        if (response.data.success) {
          this.$message.success('SSH 连接请求已发送');
        } else {
          throw new Error(response.data.error || '启动SSH连接失败');
        }
      } catch (error) {
        console.error('SSH连接错误:', error);
        this.$message.error('SSH连接失败：' + (error.response && error.response.data ? error.response.data.error : error.message));
      }
    },

    handleNodeClick(data) {
      this.selectedCategory = data;
      // 切换分类时重置分页
      this.currentPage = 1;
    },

    // 新增分页方法
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1; // 重置到第一页
    },

    handleCurrentChange(val) {
      this.currentPage = val;
    },
    
    // 排序方法
    handleSortChange({ column, prop, order }) {
      this.sortColumn = prop;
      this.sortOrder = order;
    },

    // 自适应相关方法
    handleResize() {
      this.windowWidth = window.innerWidth;
      this.isMobile = this.windowWidth < 768;
      
      // 在移动设备上默认隐藏侧边栏
      if (this.isMobile && this.showSidebar) {
        this.showSidebar = false;
      }
      
      // 调整表格高度
      this.calculateTableHeight();
    },

    toggleSidebar() {
      this.showSidebar = !this.showSidebar;
    },
    
    calculateTableHeight() {
      // 计算表格可用高度，减去其他元素（分页、标题等）占用的空间
      // 这个值需要根据实际布局调整
      const otherHeight = this.isMobile ? 130 : 150;
      this.tableMaxHeight = window.innerHeight - otherHeight;
    },

    handleCredentialChange(credentialId) {
      if (credentialId) {
        const credential = this.credentials.find(c => c.id === credentialId);
        if (credential) {
          this.selectedCredentialName = credential.name;
          this.selectedCredentialUsername = credential.username;
          
          // 清空用户名和密码字段，因为将使用凭据
          this.serverForm.username = '';
          this.serverForm.password = '';
        }
      } else {
        this.selectedCredentialName = '';
        this.selectedCredentialUsername = '';
      }
    },
    
    generatePassword() {
      // 生成8-12位的随机密码，包含大小写字母、数字和特殊字符
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+';
      const length = 12;
      let password = '';
      
      for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * chars.length);
        password += chars[randomIndex];
      }
      
      this.serverForm.password = password;
      
      // 弹出提示
      this.$message({
        message: '已生成随机密码',
        type: 'success',
        duration: 2000
      });
    },

    handleCategoryChange(categoryId) {
      this.serverForm.category_id = categoryId;
    }
  },

  created() {
    this.loadCategories();  // 加载分类列表
    this.loadServers();
    this.loadCredentials();
    // 每30秒刷新一次服务器列表
    this.refreshInterval = setInterval(() => {
      if (this.isLoggedIn) {
        this.loadServers();
        this.loadCategories();  // 同时刷新分类列表
      }
    }, 30000);
  },

  mounted() {
    // 监听窗口大小变化
    window.addEventListener('resize', this.handleResize);
    // 初始化窗口大小
    this.handleResize();
  },

  beforeDestroy() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
    }
    // 移除窗口大小监听
    window.removeEventListener('resize', this.handleResize);
  }
}
</script>

<style scoped>
.server-list-container {
  display: flex;
  height: 100%;
  padding: 20px;
  gap: 20px;
}

.category-tree {
  width: 250px;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
  transition: all 0.3s;
  position: relative;
}

.category-tree-collapsed {
  width: 50px;
  padding: 20px 10px;
}

.sidebar-toggle {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  background-color: #f5f7fa;
  border-radius: 50%;
  z-index: 2;
}

.server-list {
  flex: 1;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
  overflow: auto;
}

.toolbar {
  margin-bottom: 20px;
}

.terminal {
  height: 100%;
  background: #000;
}

/* 添加服务器对话框样式 */
.server-dialog {
  border-radius: 8px;
}

.server-form {
  padding: 20px 20px 0;
}

.form-row {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px;
}

/* 移动端表单样式 */
.form-row-mobile {
  flex-direction: column;
  gap: 0;
}

.form-item {
  flex: 1;
  margin-bottom: 0;
}

.dialog-footer {
  text-align: right;
  padding: 10px 20px;
  border-top: 1px solid #eee;
}

/* 分页容器样式 */
.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 操作按钮容器 */
.action-buttons {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 5px;
}

:deep(.el-dialog__body) {
  padding: 0;
}

:deep(.el-dialog__header) {
  padding: 20px;
  border-bottom: 1px solid #eee;
}

:deep(.el-dialog__title) {
  font-size: 18px;
  font-weight: 500;
}

:deep(.el-form-item__label) {
  font-weight: 500;
}

:deep(.el-input__inner) {
  border-radius: 4px;
}

/* 表格样式优化 */
:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th) {
  background-color: #f5f7fa !important;
  color: #606266;
  font-weight: 600;
  height: 50px;
  padding: 8px 0;
}

:deep(.el-table td) {
  padding: 12px 0;
}

:deep(.el-table--enable-row-hover .el-table__body tr:hover > td) {
  background-color: #f5f7fa;
}

/* 标签样式优化 */
:deep(.el-tag) {
  border-radius: 4px;
  padding: 0 12px;
  height: 28px;
  line-height: 26px;
  font-size: 13px;
}

/* 按钮样式优化 */
:deep(.el-button--mini) {
  padding: 7px 12px;
  font-size: 12px;
  border-radius: 4px;
}

:deep(.el-button--mini i) {
  margin-right: 4px;
  font-size: 14px;
}

/* 分类树样式优化 */
:deep(.el-tree) {
  background: none;
  color: #606266;
}

:deep(.el-tree-node__content) {
  height: 40px;
  border-radius: 4px;
}

:deep(.el-tree-node__content:hover) {
  background-color: #f5f7fa;
}

:deep(.el-tree-node.is-current > .el-tree-node__content) {
  background-color: #ecf5ff;
  color: #409EFF;
}

/* 工具栏样式 */
.toolbar {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.toolbar .el-button {
  padding: 10px 20px;
  font-size: 14px;
  border-radius: 4px;
  display: flex;
  align-items: center;
}

.toolbar .el-button i {
  margin-right: 6px;
  font-size: 16px;
}

/* 移动端响应式样式 */
@media screen and (max-width: 768px) {
  .server-list-container {
    flex-direction: column;
    padding: 10px;
  }
  
  .category-tree {
    width: 100%;
    max-height: 300px;
    overflow-y: auto;
    margin-bottom: 10px;
  }
  
  .server-list {
    padding: 15px;
  }
  
  .toolbar {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 0;
  }
  
  .el-form-item {
    margin-bottom: 18px;
  }
  
  :deep(.el-pagination) {
    padding: 0;
    justify-content: center;
    flex-wrap: wrap;
    gap: 5px;
  }
}

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.credential-info {
  margin-bottom: 15px;
}
</style>