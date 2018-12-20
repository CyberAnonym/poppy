redis
######
redis下载地址： http://download.redis.io/releases/

本次安装用了两台服务器， 一台主机名为redis1.alv.pub ip是192.168.3.21 ，另一台是redis2.alv.pub，ip是192.168.3.22

两台服务器ip都可以通过短主机名redis1 redis2解析到。

redis cluster 安装
===========================

::

    cd /usr/local/src
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
    mkdir 7001  #
    #创建7000节点为例，拷贝到7000目录
    cp /usr/local/src/redis-5.0.0/redis.conf  ./7001/


对7001目录的配置文件修改对应的配置

::

    vim /usr/local/redis_cluster/7001/redis.conf
    daemonize    yes                          //redis后台运行
    pidfile  /var/run/redis_7001.pid          //pidfile文件对应7000,7001,7002
    port  7001                                //端口7000,7001,7002
    cluster-enabled  yes                      //开启集群  把注释#去掉
    cluster-config-file  nodes_7001.conf      //集群的配置  配置文件首次启动自动生成 7000,7001,7002
    cluster-node-timeout  5000                //请求超时  设置5秒够了
    appendonly  yes                           //aof日志开启  有需要就开启，它会每次写操作都记录一条日志
    bind 0.0.0.0                    #监听对应的地址



然后将7001目录，拷贝为7002 和7003，并拷贝到另一台服务器redis2上去，在redis2上目录名为7004 7005 7006

::

    cp -r /usr/local/redis_cluster/7001/ /usr/local/redis_cluster/7002
    cp -r /usr/local/redis_cluster/7001/ /usr/local/redis_cluster/7003
    ssh redis2 'mkdir -p /usr/local/redis_cluster'
    scp -r /usr/local/redis_cluster/7001/ redis2:/usr/local/redis_cluster/7004
    scp -r /usr/local/redis_cluster/7001/ redis2:/usr/local/redis_cluster/7005
    scp -r /usr/local/redis_cluster/7001/ redis2:/usr/local/redis_cluster/7006



然后修改配置

::

    for i in 2 3;do sed -i "s/7001/700$i/" /usr/local/redis_cluster/700$i/redis.conf;done
    ssh redis2 'for i in 4 5 6;do sed -i "s/7001/700$i/" /usr/local/redis_cluster/700$i/redis.conf;done'


两台机启动各节点(两台服务器方式一样)
-------------------------------------------

::

    for i in {1..3};do redis-server /usr/local/redis_cluster/700$i/redis.conf;done
    ssh redis2 'for i in {4..6};do redis-server /usr/local/redis_cluster/700$i/redis.conf;done'


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
    tcp        0      0 192.168.3.21:7001       0.0.0.0:*               LISTEN      2507/redis-server 1
    tcp        0      0 192.168.3.21:7002       0.0.0.0:*               LISTEN      2512/redis-server 1
    tcp        0      0 192.168.3.21:7003       0.0.0.0:*               LISTEN      2517/redis-server 1

redis2服务器上

::

    [root@redis2 ~]# netstat -anplut|grep redis
    tcp        0      0 192.168.3.22:7004       0.0.0.0:*               LISTEN      2401/redis-server 1
    tcp        0      0 192.168.3.22:7005       0.0.0.0:*               LISTEN      2406/redis-server 1
    tcp        0      0 192.168.3.22:7006       0.0.0.0:*               LISTEN      2411/redis-server 1

::

    redis-cli --cluster create 192.168.3.21:7001 192.168.3.21:7002 192.168.3.21:7003  192.168.3.22:7004 192.168.3.22:7005 192.168.3.22:7006 --cluster-replicas 1

执行完上面这条命令，输入一个yes，回车，接下来这串口就处于等待状态了，等待我去做一些其他的操作，这个串口才会完成。

然后再开个窗口，去执行redis客户端命令, 参考下面的内容

::

    redis-cli -h 192.168.3.21  -p 7001
    192.168.3.21:7001> CLUSTER MEET 192.168.3.21 7001
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.21 7002
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.21 7003
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.21 7004
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.21 7005
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.22 7004
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.22 7005
    OK
    192.168.3.21:7001> CLUSTER MEET 192.168.3.22 7006
    OK
    192.168.3.21:7001> exit
    [root@redis2 ~]# redis-cli -h 192.168.3.21  -p 7002
    ...
    ...


查看集群信息

::

    [root@redis1 ~]# redis-cli --cluster check redis1:7001
    redis1:7001 (251f6d85...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7006 (0ec2de8b...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7005 (77b2b0b6...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7004 (dae4dda4...) -> 0 keys | 2730 slots | 0 slaves.
    192.168.3.21:7002 (7f6fa2cb...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.21:7003 (e8f72fee...) -> 0 keys | 2730 slots | 0 slaves.
    [OK] 0 keys in 6 masters.
    0.00 keys per slot on average.
    >>> Performing Cluster Check (using node redis1:7001)
    M: 251f6d85832207c430927fa2fa5376645b44caef redis1:7001
       slots:[0-2730] (2731 slots) master
    M: 0ec2de8b185509ed458196b467369871bbe7d1b6 192.168.3.22:7006
       slots:[13653-16383] (2731 slots) master
    M: 77b2b0b6de46c5dc17953225488354ea82ca4165 192.168.3.22:7005
       slots:[8192-10922] (2731 slots) master
    M: dae4dda4c37da979422b07cd50c88edddd0ed64b 192.168.3.22:7004
       slots:[2731-5460] (2730 slots) master
    M: 7f6fa2cb96dc0b3596b41962265afd035b4a2022 192.168.3.21:7002
       slots:[5461-8191] (2731 slots) master
    M: e8f72fee887987fd0b0902262aa55c64c38f472e 192.168.3.21:7003
       slots:[10923-13652] (2730 slots) master
    [OK] All nodes agree about slots configuration.
    >>> Check for open slots...
    >>> Check slots coverage...
    [OK] All 16384 slots covered.





查看集群key、slot、slave分布信息#

::

    [root@redis1 ~]# redis-cli --cluster info 192.168.3.21:7001
    192.168.3.21:7001 (251f6d85...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7006 (0ec2de8b...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7005 (77b2b0b6...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.22:7004 (dae4dda4...) -> 0 keys | 2730 slots | 0 slaves.
    192.168.3.21:7002 (7f6fa2cb...) -> 0 keys | 2731 slots | 0 slaves.
    192.168.3.21:7003 (e8f72fee...) -> 0 keys | 2730 slots | 0 slaves.
    [OK] 0 keys in 6 masters.
