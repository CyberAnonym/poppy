Linux内核高性能优化【生产环境实例】
#########################################

此文档来自网络：http://blog.51cto.com/yangrong/1567427


话不多说，直接上线上服务器的sysctl.conf文件，当然，这是前辈大牛的功劳：



#---内核优化开始--------



# 内核panic时，1秒后自动重启

kernel.panic = 1



# 允许更多的PIDs (减少滚动翻转问题); may break some programs 32768

kernel.pid_max = 32768



# 内核所允许的最大共享内存段的大小（bytes）

kernel.shmmax = 4294967296



# 在任何给定时刻，系统上可以使用的共享内存的总量（pages）

kernel.shmall = 1073741824



# 设定程序core时生成的文件名格式

kernel.core_pattern = core_%e



# 当发生oom时，自动转换为panic

vm.panic_on_oom = 1



# 表示强制Linux VM最低保留多少空闲内存（Kbytes）

vm.min_free_kbytes = 1048576



# 该值高于100，则将导致内核倾向于回收directory和inode cache

vm.vfs_cache_pressure = 250



# 表示系统进行交换行为的程度，数值（0-100）越高，越可能发生磁盘交换

vm.swappiness = 20



# 仅用10%做为系统cache

vm.dirty_ratio = 10



# 增加系统文件描述符限制 2^20-1

fs.file-max = 1048575



# 网络层优化

# listen()的默认参数,挂起请求的最大数量，默认128

net.core.somaxconn = 1024



# 增加Linux自动调整TCP缓冲区限制

net.core.wmem_default = 8388608

net.core.rmem_default = 8388608

net.core.rmem_max = 16777216

net.core.wmem_max = 16777216



# 进入包的最大设备队列.默认是300

net.core.netdev_max_backlog = 2000



# 开启SYN洪水攻击保护

net.ipv4.tcp_syncookies = 1



# 开启并记录欺骗，源路由和重定向包

net.ipv4.conf.all.log_martians = 1

net.ipv4.conf.default.log_martians = 1



# 处理无源路由的包

net.ipv4.conf.all.accept_source_route = 0

net.ipv4.conf.default.accept_source_route = 0



# 开启反向路径过滤

net.ipv4.conf.all.rp_filter = 1

net.ipv4.conf.default.rp_filter = 1



# 确保无人能修改路由表

net.ipv4.conf.all.accept_redirects = 0

net.ipv4.conf.default.accept_redirects = 0

net.ipv4.conf.all.secure_redirects = 0

net.ipv4.conf.default.secure_redirects = 0



# 增加系统IP端口限制

net.ipv4.ip_local_port_range = 9000 65533



# TTL

net.ipv4.ip_default_ttl = 64



# 增加TCP最大缓冲区大小

net.ipv4.tcp_rmem = 4096 87380 8388608

net.ipv4.tcp_wmem = 4096 32768 8388608



# Tcp自动窗口

net.ipv4.tcp_window_scaling = 1



# 进入SYN包的最大请求队列.默认1024

net.ipv4.tcp_max_syn_backlog = 8192



# 打开TIME-WAIT套接字重用功能，对于存在大量连接的Web服务器非常有效。

net.ipv4.tcp_tw_recycle = 1

net.ipv4.tcp_tw_reuse = 0



# 表示是否启用以一种比超时重发更精确的方法（请参阅 RFC 1323）来启用对 RTT 的计算；为了实现更好的性能应该启用这个选项

net.ipv4.tcp_timestamps = 0



# 表示本机向外发起TCP SYN连接超时重传的次数

net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_synack_retries = 2



# 减少处于FIN-WAIT-2连接状态的时间，使系统可以处理更多的连接。

net.ipv4.tcp_fin_timeout = 10



# 减少TCP KeepAlive连接侦测的时间，使系统可以处理更多的连接。

# 如果某个TCP连接在idle 300秒后,内核才发起probe.如果probe 2次(每次2秒)不成功,内核才彻底放弃,认为该连接已失效.

net.ipv4.tcp_keepalive_time = 300

net.ipv4.tcp_keepalive_probes = 2

net.ipv4.tcp_keepalive_intvl = 2



# 系统所能处理不属于任何进程的TCP sockets最大数量

net.ipv4.tcp_max_orphans = 262144



# 系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。

net.ipv4.tcp_max_tw_buckets = 20000



# arp_table的缓存限制优化

net.ipv4.neigh.default.gc_thresh1 = 128

net.ipv4.neigh.default.gc_thresh2 = 512

net.ipv4.neigh.default.gc_thresh3 = 4096



#------内核优化结束--------

更多linux内核参数解释说明，请看：

http://yangrong.blog.51cto.com/6945369/1321594