iscsi
##########


安装软件
===============

.. code-block:: bash

    # yum install targetcli -y

配置iscsi服务
===================

- 现在已经有一块磁盘准备用于iscsi共享了,以下一块200GB的sdb1就是我们用于iscsi共享的磁盘。


.. code-block:: bash

    [root@iscsi ~]# lsblk
    NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sda               8:0    0   500G  0 disk
    ├─sda1            8:1    0   512M  0 part /boot
    └─sda2            8:2    0 499.5G  0 part
      ├─centos-root 253:0    0 497.5G  0 lvm  /
      └─centos-swap 253:1    0     2G  0 lvm  [SWAP]
    sdb               8:16   0   500G  0 disk
    └─sdb1            8:17   0   200G  0 part
    sr0              11:0    1   8.1G  0 rom
    [root@iscsi ~]#

.. code-block:: bash

    [root@iscsi ~]# targetcli
    targetcli shell version 2.1.fb46
    Copyright 2011-2013 by Datera, Inc and others.
    For help on commands, type 'help'.

    /> /
    /> /backstores/block create block1 /dev/sdb1
    Created block storage object block1 using /dev/sdb1.
    /> iscsi/ create iqn.2018-02.pub.alv:remotedisk1
    Created target iqn.2018-02.pub.alv:remotedisk1.
    Created TPG 1.
    Global pref auto_add_default_portal=true
    Created default portal listening on all IPs (0.0.0.0), port 3260.
    /> cd iscsi/iqn.2018-02.pub.alv:remotedisk1/tpg1
    /iscsi/iqn.20...otedisk1/tpg1> acls/ create iqn.2018-02.pub.alv:srv1
    Created Node ACL for iqn.2018-02.pub.alv:srv1
    /iscsi/iqn.20...otedisk1/tpg1> portals/ create 192.168.38.4 3260
    Using default IP port 3260
    Could not create NetworkPortal in configFS #报这个错因为已经创建了一个0.0.0.0:3260的了。
    /iscsi/iqn.20...otedisk1/tpg1>  luns/ create /backstores/block/block1
    Created LUN 0.
    Created LUN 0->0 mapping in node ACL iqn.2018-02.pub.alv:srv1
    /iscsi/iqn.20...otedisk1/tpg1> cd /
    /> exit
    Global pref auto_save_on_exit=true
    Last 10 configs saved in /etc/target/backup.
    Configuration saved to /etc/target/saveconfig.json
    [root@iscsi ~]# systemctl start target
    [root@iscsi ~]# systemctl enable target



Client端验证
===================

- 客户端安装软件

::

    # yum -y install iscsi-initiator-utils

- 启动iscsi服务

.. code-block:: bash

    # systemctl start iscsi

- 设置开机启动服务

.. code-block:: bash


    # systemctl enable iscsi

- 配置ISCSIInitiator名称

    注：此处InitiatorName必须与服务端配置的ACL允许ISCSI客户机连接的名称一致。

.. code-block:: bash

    vi /etc/iscsi/initiatorname.iscsi
    InitiatorName=iqn.2018-02.pub.alv:srv1

- 如果有设置密码还需要修改ISCSIInitiator配置文件 这里我们没有设置密码，所以不需要，不过也描述一下。

.. code-block:: bash

    注意：
    vim /etc/iscsi/iscsid.conf
    #node.session.auth.authmethod = CHAP---去掉注释

    node.session.auth.username为存储服务端

    set auth userid=username配置的username，

    node.session.auth.password= password为存储服务器端

    set auth password=password配置的password。


- 查找ISCSI设备

.. code-block:: bash

    [root@dhcp ~]# iscsiadm -m discovery -t sendtargets -p iscsi.alv.pub

- 连接ISCSI设备 iscsiadm -m node --login

- 查看系统磁盘信息

.. code-block:: bash

    lsblk

- 然后就能看到那块磁盘了，然后就可以使用那块磁盘创建分区使用了。

- 添加开机自动连接ISCSI设备

.. code-block:: bash

    [root@dhcp ~]#  iscsiadm -m node -T  iqn.2018-02.pub.alv:remotedisk1 -p iscsi.alv.pub:3260 -o update -n node.startup -v automatic

- 设置开机挂载网络磁盘

开机挂载：采用写入fstab方式开启启动挂载磁盘

获取磁盘UUID：# blkid /dev/sdb1

.. code-block:: bash

    [root@dhcp ~]# blkid /dev/sdb1
    /dev/sdb1: UUID="a9837161-4c82-4901-aed5-b148c97c0083" TYPE="ext4"

编辑fstab：

.. code-block:: bash

    # vi/etc/fstab
    UUID=a9837161-4c82-4901-aed5-b148c97c0083   /opt    ext4    defaults,_netdev 0 0

ext4：代表文件系统，根据实际灵活变动。

_netdev：代表该挂载的磁盘分区为网络磁盘分区

- iscsid


如果设置了开机自动挂iscsi磁盘，iscsid 服务即使不设置为enable，也会在开机时自动启动，如过关闭该服务，iscsi磁盘将无法正常读写。

客户端其他操作
==================

当环境里有多和target时，需要单独指定target操作

登录指定记录
-------------------

.. code-block:: bash

    iscsiad -m node -T iqn.2018-10.pub.alv:iscsi -p iscsi.alv.pub -l

退出登录指定记录
-------------------------

.. code-block:: bash

    iscsiadm -m node -T iqn.2018-10.pub.alv:iscsi -p iscsi.alv.pub -u

断开所有target
--------------------

.. code-block:: bash

    iscsiadm -m node -u ALL

但是断开之后，重启之后还是会自动连接，我们需要删除记录才不会自动连接

删除指定记录
-----------------

.. code-block:: bash

    iscsiadm -m node -T iqn.2018-10.pub.alv:iscsi -p iscsi.alv.pub -o delete


删除所有记录
---------------

.. code-block:: bash

    iscsiadm -m node -o delete

查看我们和服务器连接的详细信息
------------------------------------

P2显示的内容比P1更详细，P3最详细。

.. code-block:: bash

    iscsiadm -m session -P1
    iscsiadm -m session -P2
    iscsiadm -m session -P3


查看timeout相关信息
-------------------------

.. code-block:: bash

    [root@node1 ~]# iscsiadm -m session -P3|grep -A5 Timeouts
                    Timeouts:
                    *********
                    Recovery Timeout: 120
                    Target Reset Timeout: 30
                    LUN Reset Timeout: 30
                    Abort Timeout: 15

配置timeout相关信息
------------------------

.. code-block:: bash

    [root@node1 ~]# vim /etc/iscsi/iscsid.conf
    node.session.err_timeo.abort_timeout = 30

然后需要重启服务，重新登录target才能生效

.. code-block:: bash

    [root@node1 ~]# systemctl restart iscsi
    [root@node1 ~]# iscsiadm -m node -u all
    Logging out of session [sid: 1, target: iqn.2018-10.example.com:node4, portal: 192.168.122.40,3260]
    Logout of [sid: 1, target: iqn.2018-10.example.com:node4, portal: 192.168.122.40,3260] successful.
    [root@node1 ~]# iscsiadm -m discovery -t st -p node4
    192.168.122.40:3260,1 iqn.2018-10.example.com:node4
    [root@node1 ~]# iscsiadm -m node -l
    Logging in to [iface: default, target: iqn.2018-10.example.com:node4, portal: 192.168.122.40,3260] (multiple)
    Login to [iface: default, target: iqn.2018-10.example.com:node4, portal: 192.168.122.40,3260] successful.
    [root@node1 ~]# iscsiadm -m session -P3|grep -A5 Timeouts
                    Timeouts:
                    *********
                    Recovery Timeout: 120
                    Target Reset Timeout: 30
                    LUN Reset Timeout: 30
                    Abort Timeout: 30


iscsi数据的同步
----------------------

一个iscsi target挂载在多个服务上时，数据是不能实时同步的， iscsi是属于单机版文件系统，只能一个服务器上挂载、写入文件、卸载掉了，另一台服务器上挂载，数据才会同步到另一台服务器上去。


确认磁盘wwid
--------------------

.. code-block:: bash

    /usr/lib/udev/scsi_id -u -g /dev/sda



dlm分布式锁管理
====================



