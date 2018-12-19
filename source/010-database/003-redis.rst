redis
######
redis下载地址： http://download.redis.io/releases/



redis cluster 安装
===========================

::

    cd /usr/local/
    wget http://download.redis.io/releases/redis-5.0.0.tar.gz
    tar -zxvf redis-5.0.0.tar.gz


编译安装
============

::


    cd redis-5.0.0/
    yum install gcc -y
    make MALLOC=libc && make install


创建redis节点
================

测试我们选择2台服务器，分别为：192.168.3.21，192.168.3.22.每个服务器有3个节点

::

cd /usr/local/
mkdir redis_cluster  #创建集群目录
cd redis_cluster
mkdir 7000 7001 7002  #分别代表三个节点    其对应端口 7000 7001 7002
#创建7000节点为例，拷贝到7000目录
cp /usr/local/redis-5.0.0/redis.conf  ./7000/
#//拷贝到7001目录
cp /usr/local/redis-5.0.0/redis.conf  ./7001/
#//拷贝到7002目录
cp /usr/local/redis-5.0.0/redis.conf  ./7002/


分别对7001，7002、7003文件夹中的3个文件修改对应的配置

daemonize    yes                          //redis后台运行
pidfile  /var/run/redis_7000.pid          //pidfile文件对应7000,7001,7002
port  7000                                //端口7000,7001,7002
cluster-enabled  yes                      //开启集群  把注释#去掉
cluster-config-file  nodes_7000.conf      //集群的配置  配置文件首次启动自动生成 7000,7001,7002
cluster-node-timeout  5000                //请求超时  设置5秒够了
appendonly  yes                           //aof日志开启  有需要就开启，它会每次写操作都记录一条日志
bind 0.0.0.0                    #监听所有地址


然后按照同样的方法，为另一台redis服务器创建 7003 7004 7005



两台机启动各节点(两台服务器方式一样)
-------------------------------------------

7000到7005全部启动

示例7000

redis-server /usr/local/redis_cluster/7000/redis.conf


查看服务
-------------

::

ps -ef | grep redis   #查看是否启动成功

netstat -tnlp | grep redis #可以看到redis监听端口


创建集群
=============

本文安装的是5.0 版本，5.0版本已经不再redis-trib.rb创建集群，所以不用安装ruby啥的了，当时redis-trib.rb的功能，现在已经集成到了redis-cli中，并且可以在有认证的情况执行了，可以通过./redis-cli --cluster help查看使用方式。

环境
------

redis1服务器上 上

::

    [root@redis1 ~]# netstat -anplut|grep redis
    tcp        0      0 127.0.0.1:7000          0.0.0.0:*               LISTEN      3812/redis-server 1
    tcp        0      0 127.0.0.1:7001          0.0.0.0:*               LISTEN      5277/redis-server 1
    tcp        0      0 127.0.0.1:7002          0.0.0.0:*               LISTEN      5282/redis-server 1
    tcp        0      0 127.0.0.1:17000         0.0.0.0:*               LISTEN      3812/redis-server 1
    tcp        0      0 127.0.0.1:17001         0.0.0.0:*               LISTEN      5277/redis-server 1
    tcp        0      0 127.0.0.1:17002         0.0.0.0:*               LISTEN      5282/redis-server 1

redis2服务器上

    [root@redis2 ~]# netstat -anplut|grep redis
    tcp        0      0 127.0.0.1:17003         0.0.0.0:*               LISTEN      4694/redis-server 1
    tcp        0      0 127.0.0.1:17004         0.0.0.0:*               LISTEN      4699/redis-server 1
    tcp        0      0 127.0.0.1:17005         0.0.0.0:*               LISTEN      4704/redis-server 1
    tcp        0      0 127.0.0.1:7003          0.0.0.0:*               LISTEN      4694/redis-server 1
    tcp        0      0 127.0.0.1:7004          0.0.0.0:*               LISTEN      4699/redis-server 1
    tcp        0      0 127.0.0.1:7005          0.0.0.0:*               LISTEN      4704/redis-server 1

::

    redis-cli --cluster create 192.168.3.21:7000 192.168.3.21:7001 192.168.3.21:7002 192.168.3.22:7003 192.168.3.22:7004 192.168.3.22:7005