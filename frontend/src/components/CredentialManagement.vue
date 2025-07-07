<template>
  <div class="credential-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog">
        <i class="el-icon-plus"></i> 添加凭据
      </el-button>
    </div>

    <el-table :data="credentials" style="width: 100%">
      <el-table-column prop="name" label="凭据名称"></el-table-column>
      <el-table-column prop="username" label="用户名"></el-table-column>
      <el-table-column prop="server_count" label="使用此凭据的服务器数">
        <template slot-scope="scope">
          <el-tag type="info">{{ scope.row.server_count }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" show-overflow-tooltip></el-table-column>
      <el-table-column label="操作" width="220">
        <template slot-scope="scope">
          <el-button 
            size="mini" 
            type="primary"
            @click="showViewDialog(scope.row)">
            查看
          </el-button>
          <el-button 
            size="mini" 
            type="warning"
            @click="showEditDialog(scope.row)">
            编辑
          </el-button>
          <el-button 
            size="mini" 
            type="danger" 
            @click="deleteCredential(scope.row)"
            :disabled="scope.row.server_count > 0">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑凭据对话框 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="500px">
      <el-form :model="credentialForm" :rules="rules" ref="credentialForm" label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="credentialForm.name" placeholder="请输入凭据名称"></el-input>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="credentialForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item :label="isEdit ? '新密码' : '密码'" prop="password">
          <el-input 
            type="password" 
            v-model="credentialForm.password" 
            placeholder="请输入密码"
            show-password>
            <template slot="append">
              <el-button type="text" @click="generatePassword">生成</el-button>
            </template>
          </el-input>
          <div class="form-tip" v-if="isEdit">留空表示不修改密码</div>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input 
            type="textarea" 
            v-model="credentialForm.description" 
            placeholder="请输入描述信息"
            :rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </div>
    </el-dialog>

    <!-- 查看凭据详情对话框 -->
    <el-dialog title="凭据详情" :visible.sync="viewDialogVisible" width="700px">
      <template v-if="currentCredential">
        <div class="credential-detail">
          <div class="detail-item">
            <span class="item-label">凭据名称：</span>
            <span class="item-value">{{ currentCredential.name }}</span>
          </div>
          <div class="detail-item">
            <span class="item-label">用户名：</span>
            <span class="item-value">{{ currentCredential.username }}</span>
          </div>
          <div class="detail-item">
            <span class="item-label">描述：</span>
            <span class="item-value">{{ currentCredential.description || '无' }}</span>
          </div>
        </div>
        
        <el-divider content-position="left">使用此凭据的服务器</el-divider>
        
        <div v-if="currentCredential.servers && currentCredential.servers.length > 0">
          <el-table :data="currentCredential.servers" style="width: 100%">
            <el-table-column prop="name" label="服务器名称"></el-table-column>
            <el-table-column prop="ip" label="IP地址"></el-table-column>
            <el-table-column prop="type" label="类型">
              <template slot-scope="scope">
                <el-tag :type="scope.row.type === 'Windows' ? 'primary' : 'success'">
                  {{ scope.row.type }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <div v-else class="empty-list">
          暂无服务器使用此凭据
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      credentials: [],
      dialogVisible: false,
      viewDialogVisible: false,
      isEdit: false,
      currentCredential: null,
      credentialForm: {
        name: '',
        username: '',
        password: '',
        description: ''
      },
      rules: {
        name: [
          { required: true, message: '请输入凭据名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { 
            validator: (rule, value, callback) => {
              if (!this.isEdit && !value) {
                callback(new Error('请输入密码'));
              } else {
                callback();
              }
            },
            trigger: 'blur' 
          }
        ]
      }
    }
  },
  computed: {
    dialogTitle() {
      return this.isEdit ? '编辑凭据' : '添加凭据';
    }
  },
  methods: {
    async loadCredentials() {
      try {
        const response = await axios.get('/api/credentials');
        this.credentials = response.data;
      } catch (error) {
        this.$message.error('获取凭据列表失败');
        console.error(error);
      }
    },
    
    showAddDialog() {
      this.isEdit = false;
      this.credentialForm = {
        name: '',
        username: '',
        password: '',
        description: ''
      };
      this.dialogVisible = true;
    },
    
    showEditDialog(credential) {
      this.isEdit = true;
      this.credentialForm = {
        id: credential.id,
        name: credential.name,
        username: credential.username,
        password: '',  // 编辑时不显示密码
        description: credential.description || ''
      };
      this.dialogVisible = true;
    },
    
    async showViewDialog(credential) {
      try {
        const response = await axios.get(`/api/credentials/${credential.id}`);
        this.currentCredential = response.data;
        this.viewDialogVisible = true;
      } catch (error) {
        this.$message.error('获取凭据详情失败');
        console.error(error);
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
      
      this.credentialForm.password = password;
      
      // 弹出提示
      this.$message({
        message: '已生成随机密码',
        type: 'success',
        duration: 2000
      });
    },
    
    async handleSubmit() {
      try {
        await this.$refs.credentialForm.validate();
        
        if (this.isEdit) {
          // 编辑凭据
          const data = {
            name: this.credentialForm.name,
            username: this.credentialForm.username,
            description: this.credentialForm.description
          };
          
          // 只有当密码字段有值时才发送
          if (this.credentialForm.password) {
            data.password = this.credentialForm.password;
          }
          
          await axios.put(`/api/credentials/${this.credentialForm.id}`, data);
          this.$message.success('凭据更新成功');
        } else {
          // 添加凭据
          await axios.post('/api/credentials', this.credentialForm);
          this.$message.success('凭据添加成功');
        }
        
        this.dialogVisible = false;
        this.loadCredentials();
      } catch (error) {
        // 表单验证失败不需要特殊处理
        if (error.constructor && error.constructor.name === 'Error') {
          return;
        }
        
        let errorMessage = '操作失败';
        if (error.response && error.response.data && error.response.data.error) {
          errorMessage = error.response.data.error;
        }
        this.$message.error(errorMessage);
      }
    },
    
    async deleteCredential(credential) {
      try {
        await this.$confirm(`确认删除凭据 "${credential.name}"?`, '提示', {
          type: 'warning'
        });
        
        await axios.delete(`/api/credentials/${credential.id}`);
        this.$message.success('删除成功');
        this.loadCredentials();
      } catch (error) {
        if (error !== 'cancel') {
          let errorMessage = '删除失败';
          if (error.response && error.response.data && error.response.data.error) {
            errorMessage = error.response.data.error;
          }
          this.$message.error(errorMessage);
        }
      }
    }
  },
  created() {
    this.loadCredentials();
  }
}
</script>

<style scoped>
.credential-management {
  padding: 20px;
}

.toolbar {
  margin-bottom: 20px;
}

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.credential-detail {
  padding: 10px;
  background-color: #f8f8f8;
  border-radius: 4px;
}

.detail-item {
  margin: 10px 0;
  line-height: 20px;
}

.item-label {
  font-weight: bold;
  margin-right: 10px;
  color: #606266;
}

.empty-list {
  color: #909399;
  text-align: center;
  padding: 20px 0;
}
</style> 