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

这里的sda和sdb实际上是同一个盘，通过wwid可以确认。 执行下面的命令，确认这两个磁盘的wwid是一样的，所以这两个盘是同一个盘。

.. code-block:: bash

    /usr/lib/udev/scsi_id -u -g  /dev/sda1
    /usr/lib/udev/scsi_id -u -g  /dev/sda2


然后，我们就来给这两个盘做一个多路径，类似于网络聚合。


安装多路径
================
每个节点上我们都来装一下。

.. code-block:: bash

    [root@server1 ~]# 3node yum install device-mapper-multipath.x86_64 -y

加载多路径模块
=======================

.. code-block:: bash

    lsmod |grep multi  #Check if multipath module has been loaded.
    modproble dm_multipath # load multipath module.

set automatic load multipath module
=========================================

.. code-block:: bash

    echo 'modproble dm_multipath' >> /etc/rc.d/rc.local
    chmod +x /etc/rc.d/rc.local




check multipath configuration file
================================================

.. code-block:: bash

    multipath


create a multipath file
==================================

.. code-block:: bash

    cp /usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf /etc/

start and enable multipathd
------------------------------------

.. code-block:: bash

    systemctl restart multipathd
    systemctl is-active multipathd
    systemctl enable multipathd

multipath会自动发现wwid相同的设置，然后自动的给我们做多路径。


check multipath
============================

.. code-block:: bash

    [root@node1 ~]# multipath -l
    Oct 12 17:38:31 | vda: No fc_host device for 'host-1'
    Oct 12 17:38:31 | vda: No fc_host device for 'host-1'
    Oct 12 17:38:31 | vda: No fc_remote_port device for 'rport--1:-1-0'
    mpatha (360014059c2719519e0f4445afbb30030) dm-2 LIO-ORG ,iscsi_store
    size=10.0G features='0' hwhandler='0' wp=rw
    |-+- policy='service-time 0' prio=0 status=active
    | `- 2:0:0:0 sda 8:0   active undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      `- 3:0:0:0 sdb 8:16  active undef running



manage configuration file
======================================

默认配置里，user_friendly_names yes 表示使用友好的名字，让我们自己能够方便去识别。

.. code-block:: bash

    $ vim /etc/multipath.conf
    defaults {
            user_friendly_names yes
            find_multipaths yes
    }

blacklist 里配置的是不配置多路径的磁盘。比如我们写devnode "^[vs]d[a-z]"  ，那么vd开头的如vda到vdz开头的磁盘和sda到sdz开头的磁盘，都不会做多路径。


::

    blacklist {
           wwid 26353900f02796769
            devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
            devnode "^[vs]d[a-z]"
    }

blacklist_exceptions 里配置就是在blacklist里已经配置包含了的磁盘，但我们又要用的，就在这里写出来。

::

    blacklist_exceptions {

            devnode "sd[a-z]"
    }



配置multipath的别名

::

    [root@node1 ~]# multipath -l
    mpatha (360014059c2719519e0f4445afbb30030) dm-2 LIO-ORG ,iscsi_store
    size=10.0G features='0' hwhandler='0' wp=rw
    |-+- policy='service-time 0' prio=0 status=active
    | `- 2:0:0:0 sdb 8:16 active undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      `- 3:0:0:0 sda 8:0  active undef running
    [root@node1 ~]# vim /etc/multipath.conf
    multipaths {
            multipath {
                    wwid                    360014059c2719519e0f4445afbb30030
                    alias                   alvin_disk
            }
    }
    [root@node1 ~]# systemctl restart multipathd
    [root@node1 ~]# multipath -l
    alvin_disk (360014059c2719519e0f4445afbb30030) dm-2 LIO-ORG ,iscsi_store
    size=10.0G features='0' hwhandler='0' wp=rw
    |-+- policy='service-time 0' prio=0 status=active
    | `- 2:0:0:0 sdb 8:16 active undef running
    `-+- policy='service-time 0' prio=0 status=enabled
      `- 3:0:0:0 sda 8:0  active undef running


查看默认配置,可以查看各种各样的一些厂商的一些设备。

::

    multipathd -k
    show
    show config


为multipacth磁盘分区
==============================

::

    fdisk /dev/mapper/alvin_disk
    mkfs.ext4 /dev/mapper/alvin_disk1
    mount /dev/mapper/alvin_disk1 /mnt/
