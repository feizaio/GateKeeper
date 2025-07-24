<template>
  <div class="task-manager">
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">任务管理</h2>
        <div class="page-description">管理和执行自动化任务，包括Jenkins任务</div>
      </div>
      <div class="header-right" v-if="currentUser.is_admin">
        <el-button type="primary" icon="el-icon-plus" @click="showAddDialog">添加任务</el-button>
      </div>
    </div>

    <!-- 工具栏 -->
    <div class="actions-toolbar">
      <div class="toolbar-left">
        <el-radio-group v-model="statusFilter" size="small" @change="handleFilterChange">
          <el-radio-button label="all">全部</el-radio-button>
          <el-radio-button label="enabled">已启用</el-radio-button>
          <el-radio-button label="disabled">已禁用</el-radio-button>
        </el-radio-group>
        
        <el-select 
          v-model="viewFilter" 
          placeholder="选择视图" 
          size="small" 
          @change="handleFilterChange"
          clearable
          class="view-filter"
        >
          <el-option label="全部视图" value="all"></el-option>
          <el-option label="未分类" value="none"></el-option>
          <el-option
            v-for="view in taskViews"
            :key="view.id"
            :label="view.name"
            :value="view.id"
          ></el-option>
        </el-select>
        
        <el-button 
          type="text" 
          icon="el-icon-s-operation" 
          @click="$router.push('/system/task-views')"
          class="manage-views-btn"
        >
          管理视图
        </el-button>
      </div>
      <div class="toolbar-right">
        <el-input
          placeholder="搜索任务"
          v-model="searchQuery"
          class="search-input"
          prefix-icon="el-icon-search"
          clearable
          size="small"
        ></el-input>
      </div>
    </div>
    
    <!-- 任务列表 -->
    <el-table
      :data="filteredTasks"
      style="width: 100%"
      v-loading="loading"
      border
      stripe
      :default-sort="{prop: 'updated_at', order: 'descending'}"
      :row-class-name="tableRowClassName"
      highlight-current-row
    >
      <el-table-column prop="name" label="任务名称" min-width="110">
        <template slot-scope="scope">
          <router-link :to="`/system/task-detail/${scope.row.id}`" class="task-name-link">
            {{ scope.row.name }}
          </router-link>
        </template>
      </el-table-column>
      <el-table-column prop="view_id" label="所属视图" width="180" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.view_id" type="success" size="medium">
            {{ getViewName(scope.row.view_id) }}
          </el-tag>
          <span v-else class="no-data-text">未分类</span>
        </template>
      </el-table-column>
      <el-table-column prop="task_type" label="类型" width="120" align="center">
        <template slot-scope="scope">
          <el-tag :type="getTaskTypeTag(scope.row.task_type)" size="medium">
            {{ getTaskTypeLabel(scope.row.task_type) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" min-width="180">
        <template slot-scope="scope">
          <span class="description-text">{{ scope.row.description || '无描述' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="80" align="center">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.is_enabled"
            active-color="#13ce66"
            inactive-color="#ff4949"
            :disabled="!canEdit(scope.row)"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column prop="updated_at" label="更新时间" width="160" sortable align="center">
        <template slot-scope="scope">
          {{ formatDate(scope.row.updated_at) }}
        </template>
      </el-table-column>
      <el-table-column prop="last_success_time" label="上次成功时间" width="160" sortable align="center">
        <template slot-scope="scope">
          <span v-if="scope.row.last_success_time">{{ formatDate(scope.row.last_success_time) }}</span>
          <span v-else class="no-data-text">暂无成功记录</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right" align="center">
        <template slot-scope="scope">
          <div class="action-buttons">
            <!-- 查看详情按钮 - 所有人可见 -->
            <el-tooltip content="查看详情" placement="top">
              <el-button
                size="mini"
                type="info"
                icon="el-icon-view"
                circle
                @click="$router.push(`/system/task-detail/${scope.row.id}`)"
              ></el-button>
            </el-tooltip>
            
            <!-- 执行任务按钮 - 需要执行权限 -->
            <el-tooltip content="执行任务" placement="top" :disabled="!canExecute(scope.row) || !scope.row.is_enabled">
              <el-button
                size="mini"
                type="primary"
                icon="el-icon-video-play"
                circle
                @click="executeTask(scope.row)"
                :disabled="!canExecute(scope.row) || !scope.row.is_enabled"
                v-if="canExecute(scope.row)"
              ></el-button>
            </el-tooltip>
            
            <!-- 编辑任务按钮 - 需要编辑权限 -->
            <el-tooltip content="编辑任务" placement="top" v-if="canEdit(scope.row)">
              <el-button
                size="mini"
                type="warning"
                icon="el-icon-edit"
                circle
                @click="editTask(scope.row)"
              ></el-button>
            </el-tooltip>
            
            <!-- 删除任务按钮 - 需要删除权限 -->
            <el-tooltip content="删除任务" placement="top" v-if="canDelete(scope.row)">
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
    
    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="totalTasksCount"
        background
      ></el-pagination>
    </div>
    
    <!-- 添加/编辑任务对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="50%"
      @closed="resetForm"
    >
      <el-form :model="taskForm" :rules="formRules" ref="taskForm" label-width="100px">
        <el-form-item label="任务名称" prop="name">
          <el-input v-model="taskForm.name" placeholder="请输入任务名称"></el-input>
        </el-form-item>
        <el-form-item label="任务类型" prop="task_type">
          <el-select v-model="taskForm.task_type" placeholder="请选择任务类型" style="width: 100%">
            <el-option label="Jenkins任务" value="jenkins"></el-option>
            <el-option label="脚本任务" value="script"></el-option>
            <el-option label="命令任务" value="command"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="描述">
          <el-input type="textarea" v-model="taskForm.description" placeholder="请输入任务描述"></el-input>
        </el-form-item>
        
        <el-form-item label="所属视图">
          <el-select v-model="taskForm.view_id" placeholder="选择视图" clearable style="width: 100%">
            <el-option label="无视图" :value="null"></el-option>
            <el-option
              v-for="view in taskViews"
              :key="view.id"
              :label="view.name"
              :value="view.id"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <!-- Jenkins任务特有字段 -->
        <template v-if="taskForm.task_type === 'jenkins'">
          <el-form-item label="Jenkins URL" prop="jenkins_url">
            <el-input v-model="taskForm.jenkins_url" placeholder="例如: http://jenkins.example.com:8080"></el-input>
          </el-form-item>
          <el-form-item label="任务名称" prop="jenkins_job_name">
            <el-input v-model="taskForm.jenkins_job_name" placeholder="Jenkins任务名称">
              <el-button slot="append" @click="loadJenkinsJobs" :loading="loadingJenkinsJobs">
                <i class="el-icon-refresh"></i> 获取任务
              </el-button>
            </el-input>
            <el-select 
              v-if="jenkinsJobs.length > 0" 
              v-model="taskForm.jenkins_job_name" 
              placeholder="选择Jenkins任务" 
              style="width: 100%; margin-top: 5px;"
              filterable
              @change="onJenkinsJobSelected"
            >
              <el-option 
                v-for="job in jenkinsJobs" 
                :key="job.name" 
                :label="job.name" 
                :value="job.name"
              >
                <!-- 显示嵌套文件夹结构 -->
                <div v-if="job.folder" class="nested-job">
                  <span class="folder-name">{{ job.folder }}</span>
                  <i class="el-icon-arrow-right folder-separator"></i>
                  <span class="job-name">{{ job.name.split('/').pop() }}</span>
                </div>
                <span v-else>{{ job.name }}</span>
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="用户名" prop="jenkins_username">
            <el-input v-model="taskForm.jenkins_username" placeholder="Jenkins用户名"></el-input>
          </el-form-item>
          <el-form-item label="API Token" prop="jenkins_api_token">
            <el-input v-model="taskForm.jenkins_api_token" placeholder="Jenkins API Token" show-password></el-input>
          </el-form-item>
          
          <!-- Jenkins参数设置 -->
          <el-form-item label="任务参数">
            <div class="jenkins-params">
              <div v-for="(param, index) in jenkinsParams" :key="index" class="param-item">
                <el-input v-model="param.name" placeholder="参数名" class="param-name"></el-input>
                <el-input v-model="param.value" placeholder="参数值" class="param-value"></el-input>
                <el-button type="danger" icon="el-icon-delete" circle @click="removeParam(index)" size="mini"></el-button>
              </div>
              <el-button type="primary" icon="el-icon-plus" size="small" @click="addParam">添加参数</el-button>
            </div>
          </el-form-item>
        </template>
        
        <!-- 脚本任务特有字段 -->
        <template v-if="taskForm.task_type === 'script'">
          <el-form-item label="脚本类型" prop="script_type">
            <el-select v-model="taskForm.script_type" placeholder="请选择脚本类型" style="width: 100%">
              <el-option label="Python" value="python"></el-option>
              <el-option label="Bash" value="bash"></el-option>
              <el-option label="PowerShell" value="powershell"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="脚本内容" prop="script_content">
            <el-input
              type="textarea"
              v-model="taskForm.script_content"
              :rows="10"
              placeholder="请输入脚本内容"
            ></el-input>
          </el-form-item>
        </template>
        
        <!-- 命令任务特有字段 -->
        <template v-if="taskForm.task_type === 'command'">
          <el-form-item label="命令内容" prop="command">
            <el-input
              type="textarea"
              v-model="taskForm.command"
              :rows="5"
              placeholder="请输入命令内容"
            ></el-input>
          </el-form-item>
        </template>
        
        <el-form-item label="启用状态">
          <el-switch v-model="taskForm.is_enabled"></el-switch>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveTask" :loading="saveLoading">保存</el-button>
      </span>
    </el-dialog>
    
    <!-- 删除确认对话框 -->
    <el-dialog
      title="确认删除"
      :visible.sync="deleteDialogVisible"
      width="30%">
      <p>确定要删除任务 "{{ taskToDelete ? taskToDelete.name : '' }}" 吗？</p>
      <p class="warning-text">此操作将永久删除该任务及其所有执行记录，且不可恢复！</p>
      <span slot="footer" class="dialog-footer">
        <el-button @click="deleteDialogVisible = false">取消</el-button>
        <el-button type="danger" @click="deleteTask" :loading="deleteLoading">确定删除</el-button>
      </span>
    </el-dialog>
    
    <!-- 参数编辑对话框 -->
    <el-dialog
      title="编辑任务参数"
      :visible.sync="paramsDialogVisible"
      width="750px"
      @close="cancelExecute"
    >
      <div v-if="currentTask && currentTask.task_type === 'jenkins'">
        <div class="params-editor">
          <div v-for="(param, index) in executionParams" :key="index" class="param-item">
            <el-form :inline="false" class="param-form">
              <el-form-item :label="param.name">
                <!-- 选择类型参数 -->
                <el-select 
                  v-if="param.type === 'ChoiceParameterDefinition'" 
                  v-model="param.value" 
                  :placeholder="`选择${param.name}参数值`"
                  style="width: 100%"
                >
                  <el-option 
                    v-for="choice in param.choices" 
                    :key="choice" 
                    :label="choice" 
                    :value="choice"
                  ></el-option>
                </el-select>
                <!-- 布尔类型参数 -->
                <el-switch 
                  v-else-if="param.type === 'BooleanParameterDefinition'"
                  v-model="param.value"
                  active-text="是"
                  inactive-text="否"
                ></el-switch>
                <!-- 默认文本类型参数 -->
                <el-input 
                  v-else
                  v-model="param.value" 
                  type="textarea" 
                  :rows="5"
                  :placeholder="`输入${param.name}参数值`"
                  class="param-textarea"
                ></el-input>
              </el-form-item>
              <el-form-item v-if="param.description" label="描述">
                <el-tooltip :content="param.description" placement="top">
                  <span class="param-description">{{ param.description }}</span>
                </el-tooltip>
              </el-form-item>
            </el-form>
          </div>
          <div v-if="executionParams.length === 0" class="no-params">
            <i class="el-icon-info"></i>
            <p>该任务没有定义参数</p>
          </div>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="cancelExecute">取消</el-button>
        <el-button type="primary" @click="confirmExecute" :loading="executeLoading">确认执行</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TaskManager',
  data() {
    return {
      tasks: [],
      loading: false,
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      totalTasks: 0,
      totalFilteredTasks: 0,
      taskViews: [],
      viewFilter: 'all',
      
      // 对话框相关
      dialogVisible: false,
      dialogTitle: '添加任务',
      isEdit: false,
      taskForm: {
        name: '',
        task_type: 'jenkins',
        description: '',
        is_enabled: true,
        view_id: null,
        jenkins_url: '',
        jenkins_job_name: '',
        jenkins_username: '',
        jenkins_api_token: '',
        jenkins_parameters: {},
        script_type: '',
        script_content: '',
        command: ''
      },
      formRules: {
        name: [
          { required: true, message: '请输入任务名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        task_type: [
          { required: true, message: '请选择任务类型', trigger: 'change' }
        ],
        jenkins_url: [
          { required: true, message: 'Jenkins URL不能为空', trigger: 'blur' }
        ],
        jenkins_job_name: [
          { required: true, message: 'Jenkins任务名称不能为空', trigger: 'blur' }
        ],
        script_type: [
          { required: true, message: '请选择脚本类型', trigger: 'change' }
        ],
        script_content: [
          { required: true, message: '脚本内容不能为空', trigger: 'blur' }
        ],
        command: [
          { required: true, message: '命令内容不能为空', trigger: 'blur' }
        ]
      },
      saveLoading: false,
      
      // Jenkins相关
      jenkinsJobs: [],
      loadingJenkinsJobs: false,
      loadingJobParameters: false,
      
      // 删除相关
      deleteDialogVisible: false,
      taskToDelete: null,
      deleteLoading: false,

      // Jenkins参数相关
      jenkinsParams: [], // 用于UI展示的Jenkins参数数组
      
      // 参数对话框相关
      paramsDialogVisible: false,
      executionParams: [],
      jobParameters: [],
      currentTask: null,
      executeLoading: false,

      // 添加状态过滤
      statusFilter: 'all',

      // 任务权限
      taskPermissions: {},
    };
  },
  watch: {
    'taskForm.jenkins_job_name': function(newVal, oldVal) {
      if (newVal && newVal !== oldVal) {
        this.onJenkinsJobSelected(newVal);
      }
    }
  },
  computed: {
    filteredTasks() {
      if (!this.searchQuery && this.statusFilter === 'all' && this.viewFilter === 'all') {
        // 应用分页
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.tasks.slice(start, end);
      }
      
      let filtered = this.tasks;
      
      // 先按状态过滤
      if (this.statusFilter === 'enabled') {
        filtered = filtered.filter(task => task.is_enabled);
      } else if (this.statusFilter === 'disabled') {
        filtered = filtered.filter(task => !task.is_enabled);
      }
      
      // 按视图过滤
      if (this.viewFilter !== 'all') {
        if (this.viewFilter === 'none') {
          // 过滤没有视图的任务
          filtered = filtered.filter(task => !task.view_id);
        } else {
          // 过滤特定视图的任务
          filtered = filtered.filter(task => task.view_id === this.viewFilter);
        }
      }
      
      // 再按搜索条件过滤
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(task => 
          task.name.toLowerCase().includes(query) || 
          (task.description && task.description.toLowerCase().includes(query)) ||
          this.getTaskTypeLabel(task.task_type).toLowerCase().includes(query)
        );
      }
      
      // 保存过滤后的总数量
      this.totalFilteredTasks = filtered.length;
      
      // 应用分页
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      return filtered.slice(start, end);
    },
    
    // 获取过滤后的总任务数
    totalTasksCount() {
      return this.totalFilteredTasks || this.tasks.length;
    },
    currentUser() {
      return this.$store.state.user || {};
    }
  },
  created() {
    this.loadTasks();
    this.loadTaskPermissions();
    this.loadTaskViews();
    
    // 检查是否有视图ID参数
    if (this.$route.query.view_id) {
      this.viewFilter = parseInt(this.$route.query.view_id);
    }
  },
  methods: {
    // 加载任务列表
    async loadTasks() {
      this.loading = true;
      try {
        const response = await axios.get('/api/tasks');
        this.tasks = response.data;
        this.totalTasks = this.tasks.length;
        this.loading = false;
      } catch (error) {
        this.$message.error('加载任务列表失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.loading = false;
      }
    },
    
    // 添加参数
    addParam() {
      this.jenkinsParams.push({ name: '', value: '' });
    },
    
    // 移除参数
    removeParam(index) {
      this.jenkinsParams.splice(index, 1);
    },
    
    // 将参数数组转换为对象
    paramsToObject() {
      const result = {};
      this.jenkinsParams.forEach(param => {
        if (param.name && param.name.trim()) {
          result[param.name.trim()] = param.value;
        }
      });
      return result;
    },
    
    // 将参数对象转换为数组
    paramsToArray(paramsObj) {
      const result = [];
      if (paramsObj && typeof paramsObj === 'object') {
        Object.keys(paramsObj).forEach(key => {
          result.push({
            name: key,
            value: paramsObj[key]
          });
        });
      }
      return result;
    },
    
    // 显示添加对话框
    showAddDialog() {
      this.isEdit = false;
      this.dialogTitle = '添加任务';
      this.jenkinsParams = []; // 清空参数
      this.dialogVisible = true;
    },
    
    // 编辑任务
    editTask(task) {
      this.isEdit = true;
      this.dialogTitle = '编辑任务';
      
      // 复制任务数据到表单
      this.taskForm = {
        id: task.id,
        name: task.name,
        task_type: task.task_type,
        description: task.description || '',
        is_enabled: task.is_enabled,
        view_id: task.view_id,
        jenkins_url: task.jenkins_url || '',
        jenkins_job_name: task.jenkins_job_name || '',
        jenkins_username: task.jenkins_username || '',
        jenkins_api_token: task.jenkins_api_token || '',
        jenkins_parameters: task.jenkins_parameters || {},
        script_type: task.script_type || '',
        script_content: task.script_content || '',
        command: task.command || ''
      };
      
      // 将参数对象转换为数组，用于UI展示
      this.jenkinsParams = this.paramsToArray(task.jenkins_parameters);
      
      this.dialogVisible = true;
    },
    
    // 保存任务
    saveTask() {
      this.$refs.taskForm.validate(async valid => {
        if (!valid) return;
        
        // 处理Jenkins参数
        if (this.taskForm.task_type === 'jenkins') {
          this.taskForm.jenkins_parameters = this.paramsToObject();
        }
        
        this.saveLoading = true;
        
        try {
          let response;
          
          if (this.isEdit) {
            // 更新任务
            response = await axios.put(`/api/tasks/${this.taskForm.id}`, this.taskForm);
            
            // 更新本地数据
            const index = this.tasks.findIndex(t => t.id === this.taskForm.id);
            if (index !== -1) {
              this.$set(this.tasks, index, response.data);
            }
            
            this.$message.success('任务更新成功');
          } else {
            // 创建任务
            response = await axios.post('/api/tasks', this.taskForm);
            
            // 添加到本地数据
            this.tasks.push(response.data);
            this.totalTasks = this.tasks.length;
            
            this.$message.success('任务创建成功');
          }
          
          this.dialogVisible = false;
          this.saveLoading = false;
        } catch (error) {
          this.$message.error('保存任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
          this.saveLoading = false;
        }
      });
    },
    
    // 重置表单
    resetForm() {
      if (this.$refs.taskForm) {
        this.$refs.taskForm.resetFields();
      }
      
      this.taskForm = {
        name: '',
        task_type: 'jenkins',
        description: '',
        is_enabled: true,
        view_id: null,
        jenkins_url: '',
        jenkins_job_name: '',
        jenkins_username: '',
        jenkins_api_token: '',
        jenkins_parameters: {},
        script_type: '',
        script_content: '',
        command: ''
      };
      
      this.jenkinsParams = [];
      this.jenkinsJobs = [];
    },
    
    // 确认删除
    confirmDelete(task) {
      this.taskToDelete = task;
      this.deleteDialogVisible = true;
    },
    
    // 删除任务
    async deleteTask() {
      if (!this.taskToDelete) return;
      
      this.deleteLoading = true;
      
      try {
        await axios.delete(`/api/tasks/${this.taskToDelete.id}`);
        
        // 从本地数据中移除
        const index = this.tasks.findIndex(t => t.id === this.taskToDelete.id);
        if (index !== -1) {
          this.tasks.splice(index, 1);
          this.totalTasks = this.tasks.length;
        }
        
        this.$message.success('任务删除成功');
        this.deleteDialogVisible = false;
        this.deleteLoading = false;
      } catch (error) {
        this.$message.error('删除任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.deleteLoading = false;
      }
    },
    
    // 执行任务
    async executeTask(task) {
      this.currentTask = task;
      
      if (task.task_type === 'jenkins') {
        // 获取任务参数
        try {
          this.executeLoading = true;
          
          // 获取Jenkins任务参数
          const params = {
            url: task.jenkins_url,
            username: task.jenkins_username || '',
            api_token: task.jenkins_api_token || '',
            job_name: task.jenkins_job_name
          };
          
          const response = await axios.get('/api/jenkins/job/parameters', { params });
          
          // 处理响应
          if (response.data && Array.isArray(response.data)) {
            this.jobParameters = response.data;
            
            // 准备执行参数，使用任务默认参数
            this.executionParams = [];
            const defaultParams = task.jenkins_parameters || {};
            
            // 将任务参数与默认值合并
            response.data.forEach(param => {
              this.executionParams.push({
                name: param.name,
                value: defaultParams[param.name] || param.default_value || '',
                description: param.description || '',
                type: param.type || 'string',
                choices: param.choices || [] // 添加选项数组
              });
            });
            
            // 显示参数对话框
            this.paramsDialogVisible = true;
            this.executeLoading = false; // 重要：在显示对话框时重置loading状态
          } else {
            // 没有参数，直接执行
            this.confirmExecute();
          }
        } catch (error) {
          console.error('获取任务参数失败:', error);
          this.$message.error('获取任务参数失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
          this.executeLoading = false;
        }
      } else {
        // 非Jenkins任务，直接执行
        this.confirmExecute();
      }
    },
    
    // 取消执行
    cancelExecute() {
      this.paramsDialogVisible = false;
      this.executeLoading = false;
      this.executionParams = [];
      this.currentTask = null;
    },
    
    // 确认执行
    async confirmExecute() {
      if (!this.currentTask) return;
      
      try {
        this.executeLoading = true;
        
        // 构建参数
        const parameters = {};
        if (this.executionParams.length > 0) {
          this.executionParams.forEach(param => {
            parameters[param.name] = param.value;
          });
        }
        
        // 发送执行请求
        const response = await axios.post(`/api/tasks/${this.currentTask.id}/execute`, 
          { parameters: Object.keys(parameters).length > 0 ? parameters : undefined }, 
          {
            headers: {
              'Content-Type': 'application/json'
            }
          }
        );
        
        this.$message.success('任务已提交执行');
        
        // 关闭对话框
        this.paramsDialogVisible = false;
        
        // 跳转到执行详情页
        this.$router.push(`/system/task-execution/${response.data.execution_id}`);
      } catch (error) {
        this.$message.error('执行任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      } finally {
        this.executeLoading = false;
        this.currentTask = null;
      }
    },
    
    // 加载Jenkins任务
    async loadJenkinsJobs() {
      if (!this.taskForm.jenkins_url) {
        this.$message.warning('请先输入Jenkins URL');
        return;
      }
      
      try {
        this.loadingJenkinsJobs = true;
        
        // 构建请求参数
        const params = {
          url: this.taskForm.jenkins_url,
          username: this.taskForm.jenkins_username || '',
          api_token: this.taskForm.jenkins_api_token || ''
        };
        
        // 发送请求
        const response = await axios.get('/api/jenkins/jobs', { params });
        
        // 处理响应
        if (response.data && Array.isArray(response.data)) {
          this.jenkinsJobs = response.data.map(job => ({
            name: job.name,
            url: job.url,
            folder: job.folder // 添加folder属性
          }));
          
          if (this.jenkinsJobs.length === 0) {
            this.$message.warning('未找到任何Jenkins任务');
          }
        } else {
          this.$message.warning('获取Jenkins任务列表格式不正确');
          this.jenkinsJobs = [];
        }
      } catch (error) {
        console.error('加载Jenkins任务失败:', error);
        this.$message.error('加载Jenkins任务失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
        this.jenkinsJobs = [];
      } finally {
        this.loadingJenkinsJobs = false;
      }
    },
    
    // 当选择Jenkins任务后加载任务参数
    async onJenkinsJobSelected(jobName) {
      if (!jobName) return;
      
      try {
        this.loadingJobParameters = true;
        
        // 构建请求参数
        const params = {
          url: this.taskForm.jenkins_url,
          username: this.taskForm.jenkins_username || '',
          api_token: this.taskForm.jenkins_api_token || '',
          job_name: jobName
        };
        
        // 发送请求
        const response = await axios.get('/api/jenkins/job/parameters', { params });
        
        // 处理响应
        if (response.data && Array.isArray(response.data)) {
          // 清空现有参数
          this.jenkinsParams = [];
          
          // 如果有参数，添加到参数列表
          if (response.data.length > 0) {
            response.data.forEach(param => {
              this.jenkinsParams.push({
                name: param.name,
                value: param.default_value || ''
              });
            });
            
            this.$message.success(`成功获取到 ${response.data.length} 个任务参数`);
          }
        }
      } catch (error) {
        console.error('加载Jenkins任务参数失败:', error);
        this.$message.error('加载任务参数失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      } finally {
        this.loadingJobParameters = false;
      }
    },
    
    // 处理任务状态变更
    async handleStatusChange(task) {
      try {
        await axios.put(`/api/tasks/${task.id}`, {
          is_enabled: task.is_enabled
        });
        
        this.$message.success(`任务已${task.is_enabled ? '启用' : '禁用'}`);
      } catch (error) {
        // 恢复原状态
        task.is_enabled = !task.is_enabled;
        this.$message.error('更新任务状态失败: ' + (error.response && error.response.data && error.response.data.error || error.message));
      }
    },
    
    // 分页相关方法
    handleSizeChange(val) {
      this.pageSize = val;
      // 重置为第一页
      this.currentPage = 1;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
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
    },
    
    // 获取任务类型标签
    getTaskTypeLabel(type) {
      const types = {
        'jenkins': 'Jenkins任务',
        'script': '脚本任务',
        'command': '命令任务'
      };
      return types[type] || type;
    },
    
    // 获取任务类型标签样式
    getTaskTypeTag(type) {
      const types = {
        'jenkins': 'primary',
        'script': 'success',
        'command': 'warning'
      };
      return types[type] || '';
    },
    
    // 加载任务权限
    async loadTaskPermissions() {
      try {
        const response = await axios.get('/api/tasks/permissions');
        
        // 将权限数据转换为以任务ID为键的对象
        const permissions = {};
        if (response.data && Array.isArray(response.data)) {
          response.data.forEach(perm => {
            permissions[perm.task_id] = {
              can_view: perm.can_view,
              can_execute: perm.can_execute,
              can_terminate: perm.can_terminate,
              can_delete: perm.can_delete
            };
          });
        }
        
        this.taskPermissions = permissions;
      } catch (error) {
        console.error('加载任务权限失败:', error);
      }
    },
    
    // 加载任务视图
    async loadTaskViews() {
      try {
        const response = await axios.get('/api/task-views');
        this.taskViews = response.data;
      } catch (error) {
        console.error('加载任务视图失败:', error);
        this.$message.error('加载任务视图失败');
      }
    },
    
    // 根据视图ID获取视图名称
    getViewName(viewId) {
      const view = this.taskViews.find(v => v.id === viewId);
      return view ? view.name : '未知视图';
    },
    
    // 判断是否可以查看任务
    canView(task) {
      // 管理员或任务创建者可以查看
      if (this.currentUser.is_admin || task.user_id === this.currentUser.id) {
        return true;
      }
      
      // 检查是否有查看权限
      const perm = this.taskPermissions[task.id];
      return perm && perm.can_view;
    },
    
    // 判断是否可以编辑任务
    canEdit(task) {
      // 只有管理员或任务创建者可以编辑
      return this.currentUser.is_admin || task.user_id === this.currentUser.id;
    },
    
    // 判断是否可以执行任务
    canExecute(task) {
      // 管理员或任务创建者可以执行
      if (this.currentUser.is_admin || task.user_id === this.currentUser.id) {
        return true;
      }
      
      // 检查是否有执行权限
      const perm = this.taskPermissions[task.id];
      return perm && perm.can_execute;
    },
    
    // 判断是否可以删除任务
    canDelete(task) {
      // 管理员可以删除任何任务
      if (this.currentUser.is_admin) {
        return true;
      }
      
      // 任务创建者可以删除自己的任务
      if (task.user_id === this.currentUser.id) {
        return true;
      }
      
      // 检查是否有删除权限
      const perm = this.taskPermissions[task.id];
      return perm && perm.can_delete;
    },
    
    // 表格行样式
    tableRowClassName({ row, rowIndex }) {
      if (row.is_enabled) {
        return 'enabled-row';
      } else {
        return 'disabled-row';
      }
    },

    // 处理过滤器变化
    handleFilterChange() {
      // 重置为第一页
      this.currentPage = 1;
      console.log('过滤条件变更');
    }
  }
};
</script>

<style scoped>
.task-manager {
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

.actions-toolbar {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.toolbar-left {
  flex: 1;
  margin-right: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
}

.toolbar-right {
  flex-shrink: 0;
}

.search-input {
  width: 300px;
}

.view-filter {
  width: 150px;
  margin-left: 15px;
}

.manage-views-btn {
  margin-left: 5px;
  font-size: 13px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
  padding: 10px 0;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.task-name-link {
  color: #409EFF;
  text-decoration: none;
  font-weight: bold;
}

.task-name-link:hover {
  text-decoration: underline;
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
  color: #F56C6C;
  font-weight: bold;
}

.jenkins-params {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.param-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.param-name, .param-value {
  width: 150px; /* Adjust as needed */
}

.params-editor {
  max-height: 400px;
  overflow-y: auto;
}

.param-item {
  margin-bottom: 10px;
  padding: 10px;
  border-bottom: 1px solid #eee;
}

.param-item:last-child {
  border-bottom: none;
}

.param-form {
  display: flex;
  align-items: center;
}

.param-form .el-form-item {
  margin-bottom: 0;
}

.no-params {
  text-align: center;
  padding: 20px;
  color: #909399;
}

.no-params i {
  font-size: 30px;
  margin-bottom: 10px;
}

.param-description {
  color: #606266;
  font-size: 13px;
  line-height: 1.4;
  display: block;
  word-break: break-word;
}

.param-textarea {
  width: 100%;
  font-family: Consolas, Monaco, monospace;
  font-size: 14px;
  line-height: 1.5;
}

.param-textarea >>> .el-textarea__inner {
  border-radius: 4px;
  border-color: #dcdfe6;
  padding: 10px;
  min-height: 120px !important;
  width: 500px !important;
  transition: border-color 0.2s ease;
}

.param-textarea >>> .el-textarea__inner:focus {
  border-color: #409EFF;
}

.param-textarea >>> .el-textarea__inner:hover {
  border-color: #c0c4cc;
}

/* 新增样式 */
.nested-job {
  display: flex;
  align-items: center;
  font-size: 14px;
  color: #606266;
}

.folder-name {
  margin-right: 5px;
}

.folder-separator {
  margin: 0 5px;
  font-size: 12px;
}

.job-name {
  font-weight: bold;
  color: #303133;
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

/* 新增行样式 */
.el-table .enabled-row {
  background-color: #f5fbf8; /* 更柔和的浅绿色背景 */
}

.el-table .disabled-row {
  background-color: #fbf5f5; /* 更柔和的浅红色背景 */
}

/* 鼠标悬停效果 */
.el-table .el-table__row:hover {
  background-color: #eef5ff !important;
  transition: background-color 0.3s;
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

.no-data-text {
  color: #909399;
  font-size: 13px;
  font-style: italic;
}
</style> 