<template>
  <div class="user-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddUserDialog">
        <i class="el-icon-plus"></i> 添加用户
      </el-button>
    </div>

    <el-table :data="users" style="width: 100%">
      <el-table-column prop="username" label="用户名"></el-table-column>
      <el-table-column prop="is_admin" label="角色">
        <template slot-scope="scope">
          {{ scope.row.is_admin ? '管理员' : '普通用户' }}
        </template>
      </el-table-column>
      <el-table-column label="授权服务器">
        <template slot-scope="scope">
          <el-button size="mini" @click="showServerAuthDialog(scope.row)">
            管理授权
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button 
            size="mini" 
            type="primary"
            @click="showEditUserDialog(scope.row)">
            编辑
          </el-button>
          <el-button 
            size="mini" 
            type="danger" 
            @click="deleteUser(scope.row)"
            :disabled="scope.row.id === currentUser.id">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑用户对话框 -->
    <el-dialog :title="dialogTitle" :visible.sync="userDialogVisible">
      <el-form :model="userForm" :rules="userRules" ref="userForm" label-width="100px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="userForm.username"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="userForm.password"></el-input>
        </el-form-item>
        <el-form-item label="是否管理员">
          <el-switch v-model="userForm.is_admin"></el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="userDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleUserSubmit">确定</el-button>
      </div>
    </el-dialog>

    <!-- 服务器授权对话框 -->
    <el-dialog title="服务器授权" :visible.sync="serverAuthDialogVisible" width="900px" class="server-auth-dialog">
      <div class="server-transfer-container">
      <el-transfer
        v-model="selectedServers"
        :data="allServers"
        :titles="['未授权服务器', '已授权服务器']"
          filterable
          filter-placeholder="请输入服务器名称"
        :props="{
          key: 'id',
            label: 'displayName'
        }"
          class="server-transfer"
      ></el-transfer>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="serverAuthDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleServerAuth">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      users: [],
      allServers: [],
      selectedServers: [],
      currentUser: null,
      selectedUser: null,
      userDialogVisible: false,
      serverAuthDialogVisible: false,
      userForm: {
        username: '',
        password: '',
        is_admin: false
      },
      userRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    dialogTitle() {
      return this.selectedUser ? '编辑用户' : '添加用户';
    }
  },
  methods: {
    async loadUsers() {
      try {
        const response = await axios.get('/api/users');
        this.users = response.data;
        // 获取当前用户信息
        const currentUserResponse = await axios.get('/api/users/current');
        this.currentUser = currentUserResponse.data;
      } catch (error) {
        this.$message.error('获取用户列表失败');
      }
    },
    
    async loadServers() {
      try {
        const response = await axios.get('/api/servers');
        this.allServers = response.data.map(server => ({
          id: server.id,
          name: server.name,
          ip: server.ip,
          type: server.type,
          username: server.username,
          displayName: `${server.name} (${server.ip})`
        }));
      } catch (error) {
        this.$message.error('获取服务器列表失败');
      }
    },
    
    showAddUserDialog() {
      this.selectedUser = null;
      this.userForm = {
        username: '',
        password: '',
        is_admin: false
      };
      this.userDialogVisible = true;
    },
    
    showEditUserDialog(user) {
      this.selectedUser = user;
      this.userForm = {
        username: user.username,
        password: '',
        is_admin: user.is_admin
      };
      this.userDialogVisible = true;
    },
    
    async handleUserSubmit() {
      try {
        if (this.selectedUser) {
          // 编辑用户
          await axios.put(`/api/users/${this.selectedUser.id}`, this.userForm);
          this.$message.success('用户更新成功');
        } else {
          // 添加用户
          await axios.post('/api/users', this.userForm);
          this.$message.success('用户添加成功');
        }
        this.userDialogVisible = false;
        this.loadUsers();
      } catch (error) {
        let errorMessage = '操作失败';
        if (error.response && error.response.data && error.response.data.error) {
          errorMessage = error.response.data.error;
        }
        this.$message.error(errorMessage);
      }
    },
    
    async deleteUser(user) {
      try {
        await this.$confirm('确认删除该用户?', '提示', {
          type: 'warning'
        });
        await axios.delete(`/api/users/${user.id}`);
        this.$message.success('删除成功');
        this.loadUsers();
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('删除失败');
        }
      }
    },
    
    async showServerAuthDialog(user) {
      this.selectedUser = user;
      this.serverAuthDialogVisible = true;
      try {
        await this.loadServers(); // 加载所有服务器
        const response = await axios.get(`/api/users/${user.id}/servers`);
        this.selectedServers = response.data.map(server => server.id);
      } catch (error) {
        this.$message.error('获取用户服务器授权失败');
      }
    },
    
    async handleServerAuth() {
      try {
        await axios.post(`/api/users/${this.selectedUser.id}/servers`, {
          server_ids: this.selectedServers
        });
        this.$message.success('服务器授权更新成功');
        this.serverAuthDialogVisible = false;
      } catch (error) {
        this.$message.error('更新服务器授权失败');
      }
    }
  },
  created() {
    this.loadUsers();
  }
}
</script>

<style scoped>
.user-management {
  padding: 20px;
}

.toolbar {
  margin-bottom: 20px;
}

.server-auth-dialog :deep(.el-dialog__body) {
  padding: 20px;
}

.server-transfer-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0;
}

.server-transfer {
  display: flex;
  justify-content: center;
  align-items: center;
}

.server-transfer :deep(.el-transfer-panel) {
  width: 380px;
  margin: 0;
}

.server-transfer :deep(.el-transfer-panel__header) {
  padding: 8px 15px;
  background: #f5f7fa;
}

.server-transfer :deep(.el-transfer-panel__body) {
  height: 400px;
}

.server-transfer :deep(.el-transfer-panel__list) {
  height: 340px;
}

.server-transfer :deep(.el-transfer-panel__item) {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  padding: 0 15px;
  height: 32px;
  line-height: 32px;
}

.server-transfer :deep(.el-transfer__buttons) {
  padding: 0 30px;
}

.server-transfer :deep(.el-transfer__button) {
  display: block;
  margin: 5px 0;
  padding: 10px;
}

.server-transfer :deep(.el-checkbox__label) {
  font-size: 14px;
}

.dialog-footer {
  text-align: right;
  padding-top: 20px;
}
</style> 