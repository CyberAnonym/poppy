redis
######
redis下载地址： http://download.redis.io/releases/

redis 相关文档： https://blog.csdn.net/shenjianxz/article/details/59775212

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

本次测试我们在一台服务器上进行，这台服务器主机名是 redis1.alv.pub ip是192.168.3.21

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
    pidfile  /var/run/redis_7001.pid          //pidfile文件对应7001,7001,7002
    port  7001                                //端口7001
    cluster-enabled  yes                      //开启集群  把注释#去掉
    cluster-config-file  nodes_7001.conf      //集群的配置  配置文件首次启动自动生成 7001,7002,7003 ...
    cluster-node-timeout  5000                //请求超时  设置5秒够了
    appendonly  yes                           //aof日志开启  有需要就开启，它会每次写操作都记录一条日志
    bind 0.0.0.0                    #监听对应的地址



然后将7001目录，拷贝为7002 和7003，并拷贝到另一台服务器redis2上去，在redis2上目录名为7004 7005 7006

::

    for i in {2..6};do cp -r /usr/local/redis_cluster/7001/ /usr/local/redis_cluster/700$i;done


然后修改配置

::

    for i in {2..6};do sed -i "s/7001/700$i/" /usr/local/redis_cluster/700$i/redis.conf;done


启动各节点
-----------------------

::

    for i in {1..6};do redis-server /usr/local/redis_cluster/700$i/redis.conf;done


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

    [root@redis1 redis_cluster]# netstat -anplut|grep redis
    tcp        0      0 0.0.0.0:17003           0.0.0.0:*               LISTEN      2612/redis-server 0
    tcp        0      0 0.0.0.0:17004           0.0.0.0:*               LISTEN      2676/redis-server 0
    tcp        0      0 0.0.0.0:17005           0.0.0.0:*               LISTEN      2678/redis-server 0
    tcp        0      0 0.0.0.0:17006           0.0.0.0:*               LISTEN      2618/redis-server 0
    tcp        0      0 0.0.0.0:7001            0.0.0.0:*               LISTEN      2605/redis-server 0
    tcp        0      0 0.0.0.0:7002            0.0.0.0:*               LISTEN      2610/redis-server 0
    tcp        0      0 0.0.0.0:7003            0.0.0.0:*               LISTEN      2612/redis-server 0
    tcp        0      0 0.0.0.0:7004            0.0.0.0:*               LISTEN      2676/redis-server 0
    tcp        0      0 0.0.0.0:7005            0.0.0.0:*               LISTEN      2678/redis-server 0
    tcp        0      0 0.0.0.0:7006            0.0.0.0:*               LISTEN      2618/redis-server 0
    tcp        0      0 0.0.0.0:17001           0.0.0.0:*               LISTEN      2605/redis-server 0
    tcp        0      0 0.0.0.0:17002           0.0.0.0:*               LISTEN      2610/redis-server 0




::

    [root@redis1 redis_cluster]# redis-cli --cluster create 192.168.3.21:7001 192.168.3.21:7002 192.168.3.21:7003  192.168.3.21:7004 192.168.3.21:7005 192.168.3.21:7006 --cluster-replicas 1
    >>> Performing hash slots allocation on 6 nodes...
    Master[0] -> Slots 0 - 5460
    Master[1] -> Slots 5461 - 10922
    Master[2] -> Slots 10923 - 16383
    Adding replica 192.168.3.21:7004 to 192.168.3.21:7001
    Adding replica 192.168.3.21:7005 to 192.168.3.21:7002
    Adding replica 192.168.3.21:7006 to 192.168.3.21:7003
    >>> Trying to optimize slaves allocation for anti-affinity
    [WARNING] Some slaves are in the same host as their master
    M: 9c548863676ffd91e975cf681fdc128236315d55 192.168.3.21:7001
       slots:[0-5460] (5461 slots) master
    M: 781bb13a4fd7e2ad90ce67ab1939fc3150c69418 192.168.3.21:7002
       slots:[5461-10922] (5462 slots) master
    M: 0edf2290c0a17bd0febc9fb3f48463597e1d5934 192.168.3.21:7003
       slots:[10923-16383] (5461 slots) master
    S: 93deb1cfc75eb70fda5b0ac3ee71808c72594212 192.168.3.21:7004
       replicates 9c548863676ffd91e975cf681fdc128236315d55
    S: 088f1303739e6fd7e00e2a91cf4a5a4cf8ab715a 192.168.3.21:7005
       replicates 781bb13a4fd7e2ad90ce67ab1939fc3150c69418
    S: 7b919a994dbb400a8ebb0531347193e84f6c10e3 192.168.3.21:7006
       replicates 0edf2290c0a17bd0febc9fb3f48463597e1d5934
    Can I set the above configuration? (type 'yes' to accept): yes
    >>> Nodes configuration updated
    >>> Assign a different config epoch to each node
    >>> Sending CLUSTER MEET messages to join the cluster
    Waiting for the cluster to join
    ..
    >>> Performing Cluster Check (using node 192.168.3.21:7001)
    M: 9c548863676ffd91e975cf681fdc128236315d55 192.168.3.21:7001
       slots:[0-5460] (5461 slots) master
       1 additional replica(s)
    S: 7b919a994dbb400a8ebb0531347193e84f6c10e3 192.168.3.21:7006
       slots: (0 slots) slave
       replicates 0edf2290c0a17bd0febc9fb3f48463597e1d5934
    M: 0edf2290c0a17bd0febc9fb3f48463597e1d5934 192.168.3.21:7003
       slots:[10923-16383] (5461 slots) master
       1 additional replica(s)
    M: 781bb13a4fd7e2ad90ce67ab1939fc3150c69418 192.168.3.21:7002
       slots:[5461-10922] (5462 slots) master
       1 additional replica(s)
    S: 93deb1cfc75eb70fda5b0ac3ee71808c72594212 192.168.3.21:7004
       slots: (0 slots) slave
       replicates 9c548863676ffd91e975cf681fdc128236315d55
    S: 088f1303739e6fd7e00e2a91cf4a5a4cf8ab715a 192.168.3.21:7005
       slots: (0 slots) slave
       replicates 781bb13a4fd7e2ad90ce67ab1939fc3150c69418
    [OK] All nodes agree about slots configuration.
    >>> Check for open slots...
    >>> Check slots coverage...
    [OK] All 16384 slots covered.
    [root@redis1 redis_cluster]#



查看集群信息
-------------------

三个master 三个slave。

::

    [root@redis1 redis_cluster]# redis-cli --cluster check redis1:7001
    redis1:7001 (9c548863...) -> 0 keys | 5461 slots | 1 slaves.
    192.168.3.21:7003 (0edf2290...) -> 0 keys | 5461 slots | 1 slaves.
    192.168.3.21:7002 (781bb13a...) -> 0 keys | 5462 slots | 1 slaves.
    [OK] 0 keys in 3 masters.
    0.00 keys per slot on average.
    >>> Performing Cluster Check (using node redis1:7001)
    M: 9c548863676ffd91e975cf681fdc128236315d55 redis1:7001
       slots:[0-5460] (5461 slots) master
       1 additional replica(s)
    S: 7b919a994dbb400a8ebb0531347193e84f6c10e3 192.168.3.21:7006
       slots: (0 slots) slave
       replicates 0edf2290c0a17bd0febc9fb3f48463597e1d5934
    M: 0edf2290c0a17bd0febc9fb3f48463597e1d5934 192.168.3.21:7003
       slots:[10923-16383] (5461 slots) master
       1 additional replica(s)
    M: 781bb13a4fd7e2ad90ce67ab1939fc3150c69418 192.168.3.21:7002
       slots:[5461-10922] (5462 slots) master
       1 additional replica(s)
    S: 93deb1cfc75eb70fda5b0ac3ee71808c72594212 192.168.3.21:7004
       slots: (0 slots) slave
       replicates 9c548863676ffd91e975cf681fdc128236315d55
    S: 088f1303739e6fd7e00e2a91cf4a5a4cf8ab715a 192.168.3.21:7005
       slots: (0 slots) slave
       replicates 781bb13a4fd7e2ad90ce67ab1939fc3150c69418
    [OK] All nodes agree about slots configuration.
    >>> Check for open slots...
    >>> Check slots coverage...
    [OK] All 16384 slots covered.







查看集群key、slot、slave分布信息#

::

    [root@redis1 redis_cluster]# redis-cli --cluster info 192.168.3.21:7001
    192.168.3.21:7001 (9c548863...) -> 0 keys | 5461 slots | 1 slaves.
    192.168.3.21:7003 (0edf2290...) -> 0 keys | 5461 slots | 1 slaves.
    192.168.3.21:7002 (781bb13a...) -> 0 keys | 5462 slots | 1 slaves.



测试
=======

get 和 set数据
-----------------------

-c 表示以集群的方式登录
-p 表示指定端口

::

    $ redis-cli -c -p 7001


进入命令窗口，直接

::

    set name alvin
    get name


  直接根据hash匹配切换到相应的slot的节点上。

    还是要说明一下，redis集群有16383个slot组成，通过分片分布到多个节点上，读写都发生在master节点。

