<template>
  <div class="task-view-management">
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">任务视图管理</h2>
        <div class="page-description">创建和管理任务视图，对任务进行分类</div>
      </div>
      <div class="header-right">
        <el-button plain icon="el-icon-back" @click="$router.push('/system/task-manager')">返回任务管理</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="showAddDialog">创建视图</el-button>
      </div>
    </div>

    <!-- 视图列表 -->
    <el-table
      :data="views"
      style="width: 100%"
      v-loading="loading"
      border
      stripe
      :default-sort="{prop: 'updated_at', order: 'descending'}"
    >
      <el-table-column prop="name" label="视图名称" min-width="130">
        <template slot-scope="scope">
          <span class="view-name">{{ scope.row.name }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" min-width="180">
        <template slot-scope="scope">
          <span class="description-text">{{ scope.row.description || '无描述' }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="task_count" label="任务数量" width="100" align="center">
        <template slot-scope="scope">
          <el-tag size="medium">{{ scope.row.task_count }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="updated_at" label="更新时间" width="160" sortable align="center">
        <template slot-scope="scope">
          {{ formatDate(scope.row.updated_at) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right" align="center">
        <template slot-scope="scope">
          <div class="action-buttons">
            <!-- 查看任务按钮 -->
            <el-tooltip content="查看任务" placement="top">
              <el-button
                size="mini"
                type="info"
                icon="el-icon-view"
                circle
                @click="viewTasks(scope.row)"
              ></el-button>
            </el-tooltip>
            
            <!-- 编辑视图按钮 -->
            <el-tooltip content="编辑视图" placement="top" v-if="canEdit(scope.row)">
              <el-button
                size="mini"
                type="warning"
                icon="el-icon-edit"
                circle
                @click="editView(scope.row)"
              ></el-button>
            </el-tooltip>
            
            <!-- 删除视图按钮 -->
            <el-tooltip content="删除视图" placement="top" v-if="canDelete(scope.row)">
              <el-button
                size="mini"
                type="danger"
                icon="el-icon-delete"
                circle
                @click="confirmDelete(scope.row)"
              ></el-button>
            </el-tooltip>
          </div>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 添加/编辑视图对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="40%"
      @closed="resetForm"
    >
      <el-form :model="viewForm" :rules="formRules" ref="viewForm" label-width="100px">
        <el-form-item label="视图名称" prop="name">
          <el-input v-model="viewForm.name" placeholder="请输入视图名称"></el-input>
        </el-form-item>
        <el-form-item label="描述">
          <el-input type="textarea" v-model="viewForm.description" placeholder="请输入视图描述"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveView" :loading="saveLoading">保存</el-button>
      </span>
    </el-dialog>
    
    <!-- 删除确认对话框 -->
    <el-dialog
      title="确认删除"
      :visible.sync="deleteDialogVisible"
      width="30%">
      <p>确定要删除视图 "{{ viewToDelete ? viewToDelete.name : '' }}" 吗？</p>
      <p class="warning-text">删除视图不会删除其中的任务，但任务将不再属于任何视图。</p>
      <span slot="footer" class="dialog-footer">
        <el-button @click="deleteDialogVisible = false">取消</el-button>
        <el-button type="danger" @click="deleteView" :loading="deleteLoading">确定删除</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TaskViewManagement',
  data() {
    return {
      views: [],
      loading: false,
      
      // 对话框相关
      dialogVisible: false,
      dialogTitle: '创建视图',
      isEdit: false,
      viewForm: {
        name: '',
        description: ''
      },
      formRules: {
        name: [
          { required: true, message: '请输入视图名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ]
      },
      saveLoading: false,
      
      // 删除相关
      deleteDialogVisible: false,
      viewToDelete: null,
      deleteLoading: false
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user || {};
    }
  },
  created() {
    this.loadViews();
  },
  methods: {
    // 加载视图列表
    async loadViews() {
      this.loading = true;
      try {
        const response = await axios.get('/api/task-views');
        this.views = response.data;
        this.loading = false;
      } catch (error) {
        this.$message.error('加载视图列表失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loading = false;
      }
    },
    
    // 显示添加对话框
    showAddDialog() {
      this.isEdit = false;
      this.dialogTitle = '创建视图';
      this.dialogVisible = true;
    },
    
    // 编辑视图
    editView(view) {
      this.isEdit = true;
      this.dialogTitle = '编辑视图';
      
      // 复制视图数据到表单
      this.viewForm = {
        id: view.id,
        name: view.name,
        description: view.description || ''
      };
      
      this.dialogVisible = true;
    },
    
    // 保存视图
    saveView() {
      this.$refs.viewForm.validate(async valid => {
        if (!valid) return;
        
        this.saveLoading = true;
        
        try {
          let response;
          
          if (this.isEdit) {
            // 更新视图
            response = await axios.put(`/api/task-views/${this.viewForm.id}`, this.viewForm);
            
            // 更新本地数据
            const index = this.views.findIndex(v => v.id === this.viewForm.id);
            if (index !== -1) {
              this.$set(this.views, index, response.data);
            }
            
            this.$message.success('视图更新成功');
          } else {
            // 创建视图
            response = await axios.post('/api/task-views', this.viewForm);
            
            // 添加到本地数据
            this.views.push(response.data);
            
            this.$message.success('视图创建成功');
          }
          
          this.dialogVisible = false;
          this.saveLoading = false;
        } catch (error) {
          this.$message.error('保存视图失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
          this.saveLoading = false;
        }
      });
    },
    
    // 重置表单
    resetForm() {
      if (this.$refs.viewForm) {
        this.$refs.viewForm.resetFields();
      }
      
      this.viewForm = {
        name: '',
        description: ''
      };
    },
    
    // 确认删除
    confirmDelete(view) {
      this.viewToDelete = view;
      this.deleteDialogVisible = true;
    },
    
    // 删除视图
    async deleteView() {
      if (!this.viewToDelete) return;
      
      this.deleteLoading = true;
      
      try {
        await axios.delete(`/api/task-views/${this.viewToDelete.id}`);
        
        // 从本地数据中移除
        const index = this.views.findIndex(v => v.id === this.viewToDelete.id);
        if (index !== -1) {
          this.views.splice(index, 1);
        }
        
        this.$message.success('视图删除成功');
        this.deleteDialogVisible = false;
        this.deleteLoading = false;
      } catch (error) {
        this.$message.error('删除视图失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.deleteLoading = false;
      }
    },
    
    // 查看视图任务
    viewTasks(view) {
      this.$router.push({
        path: '/system/task-manager',
        query: { view_id: view.id }
      });
    },
    
    // 判断是否可以编辑视图
    canEdit(view) {
      // 只有管理员或视图创建者可以编辑
      return this.currentUser.is_admin || view.user_id === this.currentUser.id;
    },
    
    // 判断是否可以删除视图
    canDelete(view) {
      // 只有管理员或视图创建者可以删除
      return this.currentUser.is_admin || view.user_id === this.currentUser.id;
    },
    
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '';
      
      // 创建日期对象
      const date = new Date(dateString);
      
      // 获取UTC时间并添加8小时（东八区）
      const utcTime = date.getTime();
      const beijingTime = new Date(utcTime + 8 * 60 * 60 * 1000);
      
      // 格式化为本地时间字符串
      return beijingTime.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
      });
    }
  }
};
</script>

<style scoped>
.task-view-management {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  flex: 1;
  margin-right: 20px;
}

.header-right {
  flex-shrink: 0;
}

.page-title {
  font-size: 24px;
  margin-bottom: 8px;
}

.page-description {
  color: #606266;
  font-size: 14px;
}

.view-name {
  font-weight: bold;
  color: #303133;
}

.description-text {
  color: #606266;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.warning-text {
  color: #E6A23C;
  font-weight: bold;
}

.action-buttons {
  display: flex;
  justify-content: space-around;
  align-items: center;
  flex-wrap: nowrap;
  gap: 8px;
}

.action-buttons .el-button {
  margin: 0;
  padding: 7px;
}

.action-buttons .el-button + .el-button {
  margin-left: 0;
}

/* 表格样式 */
.el-table {
  margin-top: 15px;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.el-table >>> th {
  background-color: #f5f7fa !important;
  color: #606266;
  font-weight: bold;
  font-size: 14px;
  padding: 12px 0;
}

.el-table >>> .el-table__header-wrapper {
  border-bottom: 1px solid #EBEEF5;
}
</style> 