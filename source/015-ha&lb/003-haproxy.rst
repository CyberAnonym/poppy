haproxy
###################

相关实验命令如下：

.. code-block:: bash

    tar xf /samba/packages/linux/haproxy-1.4.20.tar.gz -C /usr/local/src/  #解压软件包
    cd /usr/local/src/
    cd haproxy-1.4.20/
    make TARGET=linux26 PREFIX=/usr/local/haproxy install   #安装
    cd /usr/local/haproxy/
    mkdir conf logs
    cd conf/
    [root@c1 haproxy]# vim conf/haproxy.cfg       #编写配置文件
    global

      daemon

      maxconn 256

    defaults

      mode http

      timeout connect 5000ms

      timeout client 50000ms

      timeout server 50000ms

    listen http-in

      bind *:808

      server server1 c3:80 maxconn 32
      server server2 c4:80 maxconn 32
    [root@c1 haproxy]# ./sbin/haproxy -f conf/haproxy.cfg   ##启动服务


然后就可以在另一台机器上访问这个地址了，发现成功负载均衡了。

.. code-block:: bash

    [root@file ~]# curl c1:808
    web1
    [root@file ~]# curl c1:808
    web2
    [root@file ~]# curl c1:808
    web1
    [root@file ~]# curl c1:808
    web2


这里haproxy对后端服务是有健康检测的，如果后端服务不可用了，就不会调度到后端的服务上去了，后端服务重新可用后，就会分配请的请求到后端服务去。这里我们用的版本：HA-Proxy version 1.5.18 2016/05/10