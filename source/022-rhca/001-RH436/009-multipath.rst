第九章：多路径
######################
 多路径简单来说就是通过多个路径、也就是多块网卡去连接存储，比如我们通过目标存储上的两块网卡上的两个ip去连接目标的iscis存储，那么我们本地会得到sda和sdb,然后我们把sda和sdb做多路径，整成一块盘。

这样不仅在与后端服务器的进行数据的传输的时候，是通过两块网卡，可以提高速度，而且当其中一块网卡网络出故障的时候，我们还有另一块网卡，也就是另一条线路，存储依然可以使用，一种高可用的效果。


本次学习中，我们依然用node4作为后端存储，node4用两个ip，我们来做多路径。


为node4配置第二个IP地址
================================

.. code-block:: bash

    nmcli connection modify 'System eth0' +ipv4.address '192.168.122.41/24'
    nmcli connection up 'System eth0'


.. note::

    node4当前是已经配置好了iscsi的，在 上一章节配置的。



各个节点通过新ip连接iscsi
==================================

这里我们在server1上通过3node命令吧，由于许久还是觉得在文档里这样写，3node是我写的一个脚本，3node后面接的命令，会通过ssh在node1 node2 node3上都执行。

.. code-block:: bash

    [root@server1 ~]# 3node iscsiadm -m discovery -t st -p 192.168.122.41   #在三个节点上通过新ip去发现target
    192.168.122.41:3260,1 iqn.2018-08.com.example:node4
    192.168.122.41:3260,1 iqn.2018-08.com.example:node4
    192.168.122.41:3260,1 iqn.2018-08.com.example:node4
    [root@server1 ~]#
    [root@server1 ~]# 3node iscsiadm -m node -l #登录
    Logging in to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] (multiple)
    Login to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] successful.
    Logging in to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] (multiple)
    Login to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] successful.
    Logging in to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] (multiple)
    Login to [iface: default, target: iqn.2018-08.com.example:node4, portal: 192.168.122.41,3260] successful.

    root@server1 ~]# 3node "hostname && lsblk|grep sd"  #查看是否挂载了新的磁盘sdb
    node1
    sda             8:0    0   20G  0 disk
    └─sda1          8:1    0   20G  0 part
    sdb             8:16   0   20G  0 disk
    └─sdb1          8:17   0   20G  0 part
    node2
    sda             8:0    0   20G  0 disk
    └─sda1          8:1    0   20G  0 part
    sdb             8:16   0   20G  0 disk
    └─sdb1          8:17   0   20G  0 part
    node3
    sda             8:0    0   20G  0 disk
    └─sda1          8:1    0   20G  0 part /var/www/html
    sdb             8:16   0   20G  0 disk
    └─sdb1          8:17   0   20G  0 part

通过上面的操作和结果反馈，我们看到ndoe1 node2 node3上都连接了新的sdb。

