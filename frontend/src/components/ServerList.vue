<template>
  <div class="server-list-container">
    <!-- 左侧分类树 -->
    <div class="category-tree">
      <el-tree
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
        <el-button type="primary" @click="showAddDialog">
          <i class="el-icon-plus"></i> 添加服务器
        </el-button>
      </div>

      <el-table :data="filteredServers" style="width: 100%">
        <el-table-column prop="name" label="名称" min-width="120" />
        <el-table-column prop="ip" label="IP地址" min-width="140" />
        <el-table-column prop="type" label="类型" width="100" align="center">
          <template slot-scope="scope">
            <el-tag 
              :type="scope.row.type === 'Windows' ? 'primary' : 'success'"
              size="medium"
              effect="plain">
              {{ scope.row.type }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="150" align="center">
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
        <el-table-column label="操作" width="280" align="center">
          <template slot-scope="scope">
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
          </template>
        </el-table-column>
      </el-table>

      <!-- 添加/编辑服务器对话框 -->
      <el-dialog 
        :title="isEdit ? '编辑服务器' : '添加服务器'" 
        :visible.sync="dialogVisible" 
        width="600px"
        custom-class="server-dialog"
        :close-on-click-modal="false">
        <el-form 
          :model="serverForm" 
          ref="serverForm" 
          :rules="rules"
          label-width="80px"
          class="server-form">
          <div class="form-row">
            <el-form-item label="名称" prop="name" class="form-item">
              <el-input v-model="serverForm.name" placeholder="请输入服务器名称"></el-input>
            </el-form-item>
            <el-form-item label="IP地址" prop="ip" class="form-item">
              <el-input v-model="serverForm.ip" placeholder="请输入IP地址"></el-input>
            </el-form-item>
          </div>
          <div class="form-row">
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
          <div class="form-row">
            <el-form-item label="用户名" prop="username" class="form-item">
              <el-input v-model="serverForm.username" placeholder="请输入用户名"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password" class="form-item">
              <el-input 
                type="password" 
                v-model="serverForm.password" 
                :placeholder="isEdit ? '不修改请留空' : '请输入密码'" 
                show-password>
              </el-input>
            </el-form-item>
          </div>
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
        port: 22,
        username: '',
        password: ''
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
      editingServerId: null
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
      if (!this.selectedCategory || this.selectedCategory.id === 'all') {
        return this.servers;
      }
      
      // 根据选中的分类筛选服务器
      return this.servers.filter(server => {
        return server.category_id === this.selectedCategory.id;
      });
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
        password: ''
      };
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
      };
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

    async submitForm() {
      try {
        const valid = await this.$refs.serverForm.validate();
        if (valid) {
          if (this.isEdit) {
            // 更新服务器
            try {
              const response = await this.axios.put(`/api/servers/${this.editingServerId}`, this.serverForm);
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
              await this.axios.post('/api/servers', this.serverForm);
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
          // 获取服务器密码
          const passwordResponse = await this.axios.get(`/api/servers/${server.id}/password`);
          const password = passwordResponse.data.password;

          // 发起 RDP 连接
          const response = await this.axios.post('/api/rdp/connect', {
            server_id: server.id,
            username: server.username,
            password: password
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
        // 通过后端API发起SSH连接请求
        const response = await this.axios.post('/api/ssh/connect', {
          server_id: server.id
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
    }
  },

  created() {
    this.loadCategories();  // 加载分类列表
    this.loadServers();
    // 每30秒刷新一次服务器列表
    this.refreshInterval = setInterval(() => {
      if (this.isLoggedIn) {
        this.loadServers();
        this.loadCategories();  // 同时刷新分类列表
      }
    }, 30000);
  },

  beforeDestroy() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
    }
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
}

.server-list {
  flex: 1;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
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

.form-item {
  flex: 1;
  margin-bottom: 0;
}

.dialog-footer {
  text-align: right;
  padding: 10px 20px;
  border-top: 1px solid #eee;
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
</style>