<template>
  <div class="server-list">
    <!-- 只有管理员才能看到添加服务器按钮 -->
    <div class="toolbar" v-if="isAdmin">
      <el-button type="primary" @click="showAddDialog">
        <i class="el-icon-plus"></i> 添加服务器
      </el-button>
    </div>

    <el-table :data="servers" style="width: 100%">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="ip" label="IP地址" />
      <el-table-column prop="type" label="类型">
        <template slot-scope="scope">
          <el-tag :type="scope.row.type === 'Windows' ? 'primary' : 'success'">
            {{ scope.row.type }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.in_use"
                  :type="scope.row.in_use_by_me ? 'warning' : 'danger'">
            {{ scope.row.in_use_by_me ? '我正在使用中' : `${scope.row.in_use_by_username} 正在使用中` }}
          </el-tag>
          <el-tag v-else type="success">空闲</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button 
            type="primary" 
            size="small" 
            @click="connectServer(scope.row)"
            :disabled="scope.row.in_use && !scope.row.in_use_by_me"
            :type="scope.row.type === 'Windows' ? 'primary' : 'success'">
            {{ scope.row.type === 'Windows' ? 'RDP连接' : 'SSH连接' }}
          </el-button>
          <!-- 只有管理员才能看到删除按钮 -->
          <el-button
            v-if="isAdmin"
            type="danger"
            size="small"
            @click="deleteServer(scope.row)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加服务器对话框 -->
    <el-dialog title="添加服务器" :visible.sync="dialogVisible">
      <el-form :model="serverForm" ref="serverForm" :rules="rules">
        <el-form-item label="名称" prop="name">
          <el-input v-model="serverForm.name"></el-input>
        </el-form-item>
        <el-form-item label="IP地址" prop="ip">
          <el-input v-model="serverForm.ip"></el-input>
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="serverForm.type">
            <el-option label="Windows" value="Windows"></el-option>
            <el-option label="Linux" value="Linux"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="serverForm.username"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="serverForm.password"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </div>
    </el-dialog>

    <!-- SSH终端窗口 -->
    <el-dialog title="SSH终端" :visible.sync="sshVisible" fullscreen>
      <div id="terminal" class="terminal"></div>
    </el-dialog>
  </div>
</template>

<script>
import { Terminal } from 'xterm';
import { FitAddon } from 'xterm-addon-fit';
import io from 'socket.io-client';

export default {
  data() {
    return {
      servers: [],
      dialogVisible: false,
      sshVisible: false,
      terminal: null,
      serverForm: {
        name: '',
        ip: '',
        type: 'Windows',
        username: '',
        password: ''
      },
      rules: {
        name: [{ required: true, message: '请输入服务器名称', trigger: 'blur' }],
        ip: [{ required: true, message: '请输入IP地址', trigger: 'blur' }],
        type: [{ required: true, message: '请选择服务器类型', trigger: 'change' }],
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
      },
      activeConnections: {},  // 存储活动连接的 token
      heartbeatTimer: null
    }
  },

  computed: {
    isAdmin() {
      return this.$store.state.user && this.$store.state.user.is_admin;
    }
  },

  methods: {
    async loadServers() {
      try {
        const response = await this.axios.get('/api/servers');
        this.servers = response.data;
      } catch (error) {
        this.$message.error('获取服务器列表失败');
      }
    },

    showAddDialog() {
      this.dialogVisible = true;
      this.serverForm = {
        name: '',
        ip: '',
        type: 'Windows',
        username: '',
        password: ''
      };
    },

    async submitForm() {
      try {
        const valid = await this.$refs.serverForm.validate();
        if (valid) {
          await this.axios.post('/api/servers', this.serverForm);
          this.$message.success('添加服务器成功');
          this.dialogVisible = false;
          this.loadServers();
        }
      } catch (error) {
        this.$message.error('添加服务器失败');
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
      this.sshVisible = true;
      this.$nextTick(() => {
        if (!this.terminal) {
          this.terminal = new Terminal();
          const fitAddon = new FitAddon();
          this.terminal.loadAddon(fitAddon);
          this.terminal.open(document.getElementById('terminal'));
          fitAddon.fit();

          // 获取服务器密码
          this.axios.get(`/api/servers/${server.id}/password`).then(passwordResponse => {
            const password = passwordResponse.data.password;

            // 使用 Socket.IO 连接 SSH
            const socket = io('http://localhost:5000');
            socket.emit('connect_ssh', {
              host: server.ip,
              username: server.username,
              password: password
            });

            socket.on('ssh_output', (data) => {
              this.terminal.write(data.data);
            });

            socket.on('ssh_error', (data) => {
              this.$message.error(data.error);
              this.sshVisible = false;
            });

            socket.on('disconnect', () => {
              this.sshVisible = false;
            });

            this.terminal.onData(data => {
              socket.emit('ssh_input', data);
            });
          }).catch(error => {
            this.$message.error('获取服务器密码失败');
            this.sshVisible = false;
          });
        }
      });
    }
  },

  mounted() {
    this.loadServers();
    // 定期刷新服务器列表
    setInterval(() => {
      this.loadServers();
    }, 5000);
  },

  beforeDestroy() {
    if (this.terminal) {
      this.terminal.dispose();
    }
  }
}
</script>

<style scoped>
.server-list {
  padding: 20px;
}
.toolbar {
  margin-bottom: 20px;
}
.terminal {
  height: 100%;
  background: #000;
}
</style>