Nginx高并发配置思路
###########################################

Nginx高并发配置思路（轻松应对1万并发量）

此篇文档来自网络： https://www.cnblogs.com/sunjianguo/p/8298283.html

测试机器为腾讯云服务器1核1G内存，swap分区2G，停用除SSH外的所有服务，仅保留nginx，优化思路主要包括两个层面：系统层面+nginx层面。

系统层面
===============

#. 调整同时打开文件数量

    .. code-block:: bash

        ulimit -n 20480

#. TCP最大连接数（somaxconn）

    .. code-block:: bash

        echo 10000 > /proc/sys/net/core/somaxconn

#. TCP连接立即回收、回用（recycle、reuse）

    .. code-block:: bash

        echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
        echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle

#. 不做TCP洪水抵御

.. code-block:: bash

    echo 0 > /proc/sys/net/ipv4/tcp_syncookies


也可以直接使用优化后的配置，在/etc/sysctl.conf中加入：

::

    net.core.somaxconn = 20480
    net.core.rmem_default = 262144
    net.core.wmem_default = 262144
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.ipv4.tcp_rmem = 4096 4096 16777216
    net.ipv4.tcp_wmem = 4096 4096 16777216
    net.ipv4.tcp_mem = 786432 2097152 3145728
    net.ipv4.tcp_max_syn_backlog = 16384
    net.core.netdev_max_backlog = 20000
    net.ipv4.tcp_fin_timeout = 15
    net.ipv4.tcp_max_syn_backlog = 16384
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_max_orphans = 131072
    net.ipv4.tcp_syncookies = 0

使用：sysctl -p 生效

net.ipv4.tcp_syncookies = 1表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；

net.ipv4.tcp_tw_reuse = 1表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；

net.ipv4.tcp_tw_recycle = 1表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。

net.ipv4.tcp_fin_timeout 修改系統默认的TIMEOUT时间


.. code-block:: bash

    sysctl -p

nginx层面
============

修改nginx配置文件，nginx.conf

增加work_rlimit_nofile和worker_connections数量，并禁用keepalive_timeout。

::

    worker_processes  1;
    worker_rlimit_nofile 20000;

    events {
        use epoll;
        worker_connections 20000;
        multi_accept on;
    }

    http {
    　　keepalive_timeout 0;
    }


.. code-block:: bash

    /usr/local/nginx/sbin/nginx -s reload


使用ab压力测试

.. code-block:: bash

    ab -c 10000 -n 150000 http://127.0.0.1/index.html

测试结果：

::

    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking 127.0.0.1 (be patient)
    Completed 15000 requests
    Completed 30000 requests
    Completed 45000 requests
    Completed 60000 requests
    Completed 75000 requests
    Completed 90000 requests
    Completed 105000 requests
    Completed 120000 requests
    Completed 135000 requests
    Completed 150000 requests
    Finished 150000 requests


    Server Software:        nginx/1.8.0
    Server Hostname:        127.0.0.1
    Server Port:            80

    Document Path:          /index.html
    Document Length:        612 bytes

    Concurrency Level:      10000
    Time taken for tests:   19.185 seconds
    Complete requests:      150000
    Failed requests:        0
    Write errors:           0
    Total transferred:      131180388 bytes
    HTML transferred:       95121324 bytes
    Requests per second:    7818.53 [#/sec] (mean)
    Time per request:       1279.013 [ms] (mean)
    Time per request:       0.128 [ms] (mean, across all concurrent requests)
    Transfer rate:          6677.33 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0  650 547.9    522    7427
    Processing:   212  519 157.4    496     958
    Waiting:        0  404 139.7    380     845
    Total:        259 1168 572.1   1066    7961

    Percentage of the requests served within a certain time (ms)
      50%   1066
      66%   1236
      75%   1295
      80%   1320
      90%   1855
      95%   2079
      98%   2264
      99%   2318
     100%   7961 (longest request)
