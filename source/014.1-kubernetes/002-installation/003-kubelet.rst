kubectl
############
kubectl最佳实战

kubelet端口解析
======================

::

    10250  --port:           kubelet服务监听的端口,api会检测他是否存活
    10248  --healthz-port:   健康检查服务的端口
    10255  --read-only-port: 只读端口，可以不用验证和授权机制，直接访问
    4194   --cadvisor-port:  当前节点 cadvisor 运行的端口


kubelet参数手头书
===========================

::

    参数      	解释	                    默认值
    --address	kubelet 服务监听的地址	0.0.0.0
    --port	kubelet 服务监听的端口	10250
    --read-only-port	只读端口，可以不用验证和授权机制，直接访问	10255
    --allow-privileged	是否允许容器运行在 privileged 模式	false
    --api-servers	以逗号分割的 API Server 地址，用于和集群中数据交互	[]
    --cadvisor-port	当前节点 cadvisor 运行的端口	4194
    --config 本地 manifest	文件的路径或者目录	""
    --file-check-frequency	轮询本地 manifest 文件的时间间隔	20s
    --container-runtime	后端容器 runtime，支持 docker 和 rkt	docker
    --enable-server	是否启动 kubelet HTTP server	true
    --healthz-bind-address	健康检查服务绑定的地址，设置成 0.0.0.0 可以监听在所有网络接口	127.0.0.1
    --healthz-port	健康检查服务的端口	10248
    --hostname-override	指定 hostname，如果非空会使用这个值作为节点在集群中的标识	""
    --log-dir	日志文件，如果非空，会把 log 写到该文件	""
    --logtostderr	是否打印 log 到终端	true
    --max-open-files	允许 kubelet 打开文件的最大值	1000000
    --max-pods	允许 kubelet 运行 pod 的最大值	110
    --pod-infra-container-image	基础镜像地址，每个 pod 最先启动的容器，会配置共享的网络	gcr.io/google_containers/pause-amd64:3.0
    --root-dir	kubelet 保存数据的目录	/var/lib/kubelet
    --runonce	从本地 manifest 或者 URL 指定的 manifest 读取并运行结束就退出，和 --api-servers 、--enable-server 参数不兼容
    --v	日志 level	0