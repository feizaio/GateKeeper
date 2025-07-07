<template>
  <div class="category-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog">
        <i class="el-icon-plus"></i> 添加分类
      </el-button>
    </div>

    <el-table :data="categories" style="width: 100%">
      <el-table-column prop="name" label="分类名称" />
      <el-table-column prop="server_count" label="服务器数量" width="120" />
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button 
            type="primary" 
            size="small" 
            @click="showEditDialog(scope.row)">
            编辑
          </el-button>
          <el-button
            type="success"
            size="small"
            @click="showServerList(scope.row)"
          >
            管理服务器
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="deleteCategory(scope.row)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑分类对话框 -->
    <el-dialog 
      :title="dialogType === 'add' ? '添加分类' : '编辑分类'" 
      :visible.sync="dialogVisible" 
      width="500px"
      custom-class="category-dialog">
      <el-form 
        :model="categoryForm" 
        ref="categoryForm" 
        :rules="rules"
        label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="categoryForm.name" placeholder="请输入分类名称"></el-input>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input 
            type="textarea" 
            v-model="categoryForm.description" 
            placeholder="请输入分类描述"
            :rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 管理服务器对话框 -->
    <el-dialog 
      title="管理服务器" 
      :visible.sync="serverDialogVisible" 
      width="800px"
      custom-class="server-dialog">
      <div class="server-list-container">
        <el-table 
          ref="serverTable"
          :data="allServers" 
          style="width: 100%"
          @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55"></el-table-column>
          <el-table-column prop="name" label="服务器名称" />
          <el-table-column prop="ip" label="IP地址" />
          <el-table-column prop="type" label="类型">
            <template slot-scope="scope">
              <el-tag :type="scope.row.type === 'Windows' ? 'primary' : 'success'">
                {{ scope.row.type }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="serverDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveServerSelection">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'CategoryManagement',
  data() {
    return {
      categories: [],
      allServers: [],
      dialogVisible: false,
      serverDialogVisible: false,
      dialogType: 'add', // 'add' 或 'edit'
      selectedServers: [],
      currentCategory: null,
      categoryForm: {
        name: '',
        description: ''
      },
      rules: {
        name: [
          { required: true, message: '请输入分类名称', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        description: [
          { max: 200, message: '描述不能超过200个字符', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    async loadCategories() {
      try {
        const response = await this.axios.get('/api/categories');
        this.categories = response.data;
      } catch (error) {
        this.$message.error('获取分类列表失败');
      }
    },
    async loadAllServers() {
      try {
        const response = await this.axios.get('/api/servers');
        this.allServers = response.data;
      } catch (error) {
        this.$message.error('获取服务器列表失败');
      }
    },
    showAddDialog() {
      this.dialogType = 'add';
      this.categoryForm = {
        name: '',
        description: ''
      };
      this.dialogVisible = true;
    },
    showEditDialog(category) {
      this.dialogType = 'edit';
      this.categoryForm = { ...category };
      this.dialogVisible = true;
    },
    async submitForm() {
      try {
        const valid = await this.$refs.categoryForm.validate();
        if (valid) {
          if (this.dialogType === 'add') {
            await this.axios.post('/api/categories', this.categoryForm);
            this.$message.success('添加分类成功');
          } else {
            await this.axios.put(`/api/categories/${this.categoryForm.id}`, this.categoryForm);
            this.$message.success('更新分类成功');
          }
          this.dialogVisible = false;
          this.loadCategories();
        }
      } catch (error) {
        this.$message.error(this.dialogType === 'add' ? '添加分类失败' : '更新分类失败');
      }
    },
    async deleteCategory(category) {
      try {
        await this.$confirm('确认删除该分类?', '提示', {
          type: 'warning'
        });
        await this.axios.delete(`/api/categories/${category.id}`);
        this.$message.success('删除成功');
        this.loadCategories();
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('删除失败');
        }
      }
    },
    async showServerList(category) {
      this.currentCategory = category;
      this.serverDialogVisible = true;
      await this.loadAllServers();
      
      // 获取属于当前分类的服务器
      const categoryServers = this.allServers.filter(server => 
        server.category_id === category.id
      );
      this.selectedServers = categoryServers;
      
      // 使用$nextTick确保表格已渲染
      this.$nextTick(() => {
        // 先清除所有选中状态
        this.$refs.serverTable.clearSelection();
        
        // 然后为每个属于当前分类的服务器设置选中状态
        categoryServers.forEach(server => {
          this.$refs.serverTable.toggleRowSelection(server, true);
        });
      });
    },
    handleSelectionChange(selection) {
      this.selectedServers = selection;
    },
    async saveServerSelection() {
      try {
        const serverIds = this.selectedServers.map(server => server.id);
        await this.axios.put(`/api/categories/${this.currentCategory.id}/servers`, {
          server_ids: serverIds
        });
        this.$message.success('更新服务器成功');
        this.serverDialogVisible = false;
        this.loadCategories();
      } catch (error) {
        this.$message.error('更新服务器失败');
      }
    }
  },
  created() {
    this.loadCategories();
  }
}
</script>

<style scoped>
.category-management {
  padding: 20px;
}
.toolbar {
  margin-bottom: 20px;
}
.server-list-container {
  max-height: 500px;
  overflow-y: auto;
}
.category-dialog {
  border-radius: 8px;
}
:deep(.el-dialog__body) {
  padding: 20px 20px 0;
}
:deep(.el-form-item__label) {
  font-weight: 500;
}
:deep(.el-input__inner) {
  border-radius: 4px;
}
:deep(.el-dialog__header) {
  padding: 20px 20px 10px;
  border-bottom: 1px solid #eee;
}
:deep(.el-dialog__footer) {
  border-top: 1px solid #eee;
  padding: 15px 20px;
}
</style> 