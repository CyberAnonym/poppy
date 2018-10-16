multipath
###################

这里我们先通过两个地址连接了iscsi 存储，通过两个目标IP，连接同一个target，在本地生成了sda 和sdb，sda和sdb是拥有同样的wwid的


.. code-block:: bash

    [root@node1 ~]# /usr/lib/udev/scsi_id -u -g /dev/sda
    360014059c2719519e0f4445afbb30030
    [root@node1 ~]#
    [root@node1 ~]# /usr/lib/udev/scsi_id -u -g /dev/sdb
    360014059c2719519e0f4445afbb30030



Install multipath and load module
=====================================

Install multipath

.. code-block:: bash

    yum install device-mapper-multipath -y


load module

.. code-block:: bash

    modprobe dm_multipath

check the module is load already

.. code-block:: bash

    lsmod|grep multipath

set load mudule automatic.

.. code-block:: bash

    echo 'modprobe dm_multipath' >> /etc/rc.d/rc.local
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
