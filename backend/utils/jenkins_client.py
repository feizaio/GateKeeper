import requests
import time
import logging
import urllib.parse
import re
import json

class JenkinsClient:
    """Jenkins API客户端"""
    
    def __init__(self, jenkins_url, username, api_token):
        """初始化Jenkins客户端
        
        Args:
            jenkins_url: Jenkins服务器URL
            username: Jenkins用户名
            api_token: Jenkins API Token
        """
        self.jenkins_url = jenkins_url.rstrip('/')
        self.username = username
        self.api_token = api_token
        self.auth = (username, api_token)
        self.logger = logging.getLogger(__name__)
    
    def get_jenkins_version(self):
        """获取Jenkins版本信息
        
        Returns:
            str: Jenkins版本号
        """
        try:
            url = f"{self.jenkins_url}/api/json"
            self.logger.info(f"获取Jenkins版本信息: {url}")
            
            response = requests.get(url, auth=self.auth)
            response.raise_for_status()
            
            return response.json().get('version', 'Unknown')
        except Exception as e:
            self.logger.error(f"获取Jenkins版本失败: {str(e)}")
            return None
    
    def get_job_info(self, job_name):
        """获取Jenkins任务信息
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            
        Returns:
            dict: 任务信息
        """
        try:
            # 处理嵌套路径，将 folder/job 转换为 job/folder/job 的URL路径
            job_path = job_name.replace('/', '/job/')
            
            # URL编码任务路径，处理中文和特殊字符
            encoded_job_path = urllib.parse.quote(job_path)
            url = f"{self.jenkins_url}/job/{encoded_job_path}/api/json"
            
            self.logger.info(f"获取Jenkins任务信息: {url}")
            
            response = requests.get(url, auth=self.auth)
            response.raise_for_status()
            
            return response.json()
        except Exception as e:
            self.logger.error(f"获取Jenkins任务信息失败: {str(e)}")
            raise
    
    def get_job_parameters(self, job_name):
        """获取Jenkins任务的参数列表
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            
        Returns:
            list: 参数列表
        """
        try:
            job_info = self.get_job_info(job_name)
            
            # 检查是否有参数化构建
            if 'property' in job_info:
                for prop in job_info['property']:
                    if 'parameterDefinitions' in prop:
                        return prop['parameterDefinitions']
            
            return []
        except Exception as e:
            self.logger.error(f"获取Jenkins任务参数失败: {str(e)}")
            return []
    
    def build_job(self, job_name, parameters=None):
        """触发Jenkins构建
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            parameters: 构建参数字典
            
        Returns:
            tuple: (构建号, 队列URL)
        """
        try:
            # 处理嵌套路径，将 folder/job 转换为 job/folder/job 的URL路径
            job_path = job_name.replace('/', '/job/')
            
            # URL编码任务路径，处理中文和特殊字符
            encoded_job_path = urllib.parse.quote(job_path)
            
            # 详细调试日志
            self.logger.info(f"===== Jenkins构建调试信息 =====")
            self.logger.info(f"任务名: {job_name}")
            self.logger.info(f"任务路径: {job_path}")
            self.logger.info(f"编码后: {encoded_job_path}")
            self.logger.info(f"参数类型: {type(parameters)}")
            self.logger.info(f"参数值: {parameters}")
            
            # 首先检查任务是否需要参数
            job_params = self.get_job_parameters(job_name)
            if job_params:
                self.logger.info(f"任务需要参数: {job_params}")
                # 强制使用buildWithParameters API
                url = f"{self.jenkins_url}/job/{encoded_job_path}/buildWithParameters"
                self.logger.info(f"任务有参数定义，强制使用buildWithParameters端点")
                
                # 确保参数是字典类型
                params_to_send = {}
                if parameters:
                    if isinstance(parameters, dict):
                        params_to_send = parameters
                    elif isinstance(parameters, str):
                        try:
                            params_to_send = json.loads(parameters)
                        except:
                            # 如果无法解析为JSON，使用空参数
                            self.logger.warning(f"无法解析参数字符串: {parameters}")
                
                self.logger.info(f"发送参数: {params_to_send}")
                
                # 发送请求
                self.logger.info(f"请求URL: {url}")
                response = requests.post(url, auth=self.auth, params=params_to_send)
                self.logger.info(f"响应状态码: {response.status_code}")
                self.logger.info(f"响应内容: {response.text[:200]}...")
                response.raise_for_status()
            else:
                # 任务不需要参数，使用build API
                self.logger.info("任务无参数定义，使用build端点")
                url = f"{self.jenkins_url}/job/{encoded_job_path}/build"
                
                # 发送请求
                self.logger.info(f"请求URL: {url}")
                response = requests.post(url, auth=self.auth)
                self.logger.info(f"响应状态码: {response.status_code}")
                self.logger.info(f"响应内容: {response.text[:200]}...")
                response.raise_for_status()
            
            # 从Location头获取队列URL
            queue_url = response.headers.get('Location')
            self.logger.info(f"响应头: {dict(response.headers)}")
            
            if not queue_url:
                self.logger.error("Jenkins响应中没有Location头")
                return None, None
            
            self.logger.info(f"Jenkins构建已加入队列: {queue_url}")
            
            # 从队列URL中提取构建号
            build_number = self.get_build_number_from_queue(queue_url)
            return build_number, queue_url
        except Exception as e:
            self.logger.error(f"触发Jenkins构建失败: {str(e)}")
            self.logger.exception("详细错误信息:")
            raise
    
    def get_build_number_from_queue(self, queue_url):
        """从队列URL获取构建号
        
        Args:
            queue_url: Jenkins队列URL
            
        Returns:
            int: 构建号
        """
        try:
            # 从队列URL提取队列ID
            queue_id_match = re.search(r'/queue/item/(\d+)/?', queue_url)
            if not queue_id_match:
                self.logger.error(f"无法从队列URL提取队列ID: {queue_url}")
                return None
            
            queue_id = queue_id_match.group(1)
            queue_api_url = f"{self.jenkins_url}/queue/item/{queue_id}/api/json"
            
            # 轮询队列API，等待构建开始
            max_attempts = 30
            attempt = 0
            
            while attempt < max_attempts:
                try:
                    response = requests.get(queue_api_url, auth=self.auth)
                    response.raise_for_status()
                    queue_info = response.json()
                    
                    # 检查是否已经分配了构建号
                    if 'executable' in queue_info and 'number' in queue_info['executable']:
                        build_number = queue_info['executable']['number']
                        self.logger.info(f"获取到构建号: {build_number}")
                        return build_number
                    
                    # 如果任务被取消
                    if 'cancelled' in queue_info and queue_info['cancelled']:
                        self.logger.warning("构建任务被取消")
                        return None
                    
                    # 如果任务被阻塞
                    if 'blocked' in queue_info and queue_info['blocked']:
                        self.logger.info("构建任务被阻塞，等待中...")
                except Exception as e:
                    self.logger.warning(f"轮询队列状态出错: {str(e)}")
                
                # 等待一段时间后再次尝试
                time.sleep(2)
                attempt += 1
            
            self.logger.warning(f"等待构建开始超时，尝试次数: {max_attempts}")
            return None
        except Exception as e:
            self.logger.error(f"从队列获取构建号失败: {str(e)}")
            return None
    
    def get_build_info(self, job_name, build_number):
        """获取构建信息
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            build_number: 构建号
            
        Returns:
            dict: 构建信息
        """
        try:
            # 处理嵌套路径，将 folder/job 转换为 job/folder/job 的URL路径
            job_path = job_name.replace('/', '/job/')
            
            # URL编码任务路径，处理中文和特殊字符
            encoded_job_path = urllib.parse.quote(job_path)
            url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/api/json"
            
            self.logger.info(f"获取Jenkins构建信息: {url}")
            
            response = requests.get(url, auth=self.auth)
            response.raise_for_status()
            
            return response.json()
        except Exception as e:
            self.logger.error(f"获取Jenkins构建信息失败: {str(e)}")
            raise
    
    def get_build_log(self, job_name, build_number):
        """获取构建日志
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            build_number: 构建号
            
        Returns:
            str: 构建日志
        """
        try:
            # 处理嵌套路径，将 folder/job 转换为 job/folder/job 的URL路径
            job_path = job_name.replace('/', '/job/')
            
            # URL编码任务路径，处理中文和特殊字符
            encoded_job_path = urllib.parse.quote(job_path)
            url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/consoleText"
            
            self.logger.info(f"获取Jenkins构建日志: {url}")
            
            response = requests.get(url, auth=self.auth)
            response.raise_for_status()
            
            return response.text
        except Exception as e:
            self.logger.error(f"获取Jenkins构建日志失败: {str(e)}")
            raise
    
    def get_build_status(self, job_name, build_number):
        """获取构建状态
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            build_number: 构建号
            
        Returns:
            str: 构建状态
        """
        try:
            build_info = self.get_build_info(job_name, build_number)
            
            if 'result' in build_info:
                return build_info['result']
            
            # 构建还在进行中
            if build_info.get('building', False):
                return 'BUILDING'
            
            return 'UNKNOWN'
        except Exception as e:
            self.logger.error(f"获取Jenkins构建状态失败: {str(e)}")
            raise
    
    def stop_build(self, job_name, build_number):
        """停止构建
        
        Args:
            job_name: Jenkins任务名称（可以是 folder/job 格式的嵌套路径）
            build_number: 构建号
            
        Returns:
            bool: 是否成功
        """
        try:
            # 处理嵌套路径，将 folder/job 转换为 job/folder/job 的URL路径
            job_path = job_name.replace('/', '/job/')
            
            # URL编码任务路径，处理中文和特殊字符
            encoded_job_path = urllib.parse.quote(job_path)
            
            # 尝试两种终止方法
            success = False
            
            # 方法1: 使用标准stop API
            try:
                url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/stop"
                self.logger.info(f"尝试停止Jenkins构建(方法1): {url}")
                
                response = requests.post(url, auth=self.auth)
                response.raise_for_status()
                success = True
                self.logger.info("方法1成功停止构建")
            except Exception as e:
                self.logger.warning(f"方法1停止构建失败: {str(e)}")
            
            # 如果方法1失败，尝试方法2: 使用kill API
            if not success:
                try:
                    url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/kill"
                    self.logger.info(f"尝试停止Jenkins构建(方法2): {url}")
                    
                    response = requests.post(url, auth=self.auth)
                    response.raise_for_status()
                    success = True
                    self.logger.info("方法2成功停止构建")
                except Exception as e:
                    self.logger.warning(f"方法2停止构建失败: {str(e)}")
            
            # 如果前两种方法都失败，尝试方法3: 使用term API
            if not success:
                try:
                    url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/term"
                    self.logger.info(f"尝试停止Jenkins构建(方法3): {url}")
                    
                    response = requests.post(url, auth=self.auth)
                    response.raise_for_status()
                    success = True
                    self.logger.info("方法3成功停止构建")
                except Exception as e:
                    self.logger.warning(f"方法3停止构建失败: {str(e)}")
            
            # 如果前三种方法都失败，尝试方法4: 使用停止按钮表单提交
            if not success:
                try:
                    # 获取CSRF令牌
                    crumb_url = f"{self.jenkins_url}/crumbIssuer/api/json"
                    crumb_response = requests.get(crumb_url, auth=self.auth)
                    crumb_data = crumb_response.json()
                    
                    headers = {
                        crumb_data.get('crumbRequestField'): crumb_data.get('crumb')
                    }
                    
                    # 使用表单提交方式停止构建
                    url = f"{self.jenkins_url}/job/{encoded_job_path}/{build_number}/stop"
                    self.logger.info(f"尝试停止Jenkins构建(方法4): {url}")
                    
                    response = requests.post(url, auth=self.auth, headers=headers)
                    response.raise_for_status()
                    success = True
                    self.logger.info("方法4成功停止构建")
                except Exception as e:
                    self.logger.warning(f"方法4停止构建失败: {str(e)}")
            
            if success:
                return True
            else:
                self.logger.error("所有停止构建方法都失败")
                return False
                
        except Exception as e:
            self.logger.error(f"停止Jenkins构建失败: {str(e)}")
            raise
            
    def get_all_jobs(self):
        """获取所有Jenkins任务，包括嵌套文件夹中的任务
        
        Returns:
            list: 任务列表
        """
        try:
            url = f"{self.jenkins_url}/api/json"
            self.logger.info(f"获取所有Jenkins任务: {url}")
            
            # 获取更多信息，包括jobs数组中的jobs字段，用于处理嵌套结构
            params = {'tree': 'jobs[name,url,color,jobs[name,url,color]]'}
            response = requests.get(url, auth=self.auth, params=params)
            response.raise_for_status()
            
            jobs_data = response.json().get('jobs', [])
            result = []
            
            # 处理顶层任务和文件夹
            for job in jobs_data:
                # 检查是否是文件夹（有jobs字段）
                if 'jobs' in job:
                    folder_name = job.get('name', '')
                    # 处理文件夹中的任务
                    for nested_job in job.get('jobs', []):
                        # 创建包含文件夹路径的任务信息
                        result.append({
                            'name': f"{folder_name}/{nested_job.get('name', '')}",  # 格式: folder/job
                            'url': nested_job.get('url', ''),
                            'color': nested_job.get('color', ''),
                            'folder': folder_name  # 添加文件夹信息
                        })
                else:
                    # 顶层任务直接添加
                    result.append(job)
            
            return result
        except Exception as e:
            self.logger.error(f"获取所有Jenkins任务失败: {str(e)}")
            return [] 