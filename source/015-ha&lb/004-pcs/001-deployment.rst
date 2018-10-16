部署pcs集群
######################




安装pcs
============

.. code-block:: bash

    yum install pcs -y


启动pcs
=============

.. code-block:: bash

    systemctl enable pcsd
    systemctl start pcsd


创建集群
===================

先为pcs设置统一的密码
-----------------------------

这里我们有三个节点node1 node2 node3

.. code-block:: bash

    for i in `seq 1 3`;do ssh node$i "echo redhat|passwd --stdin hacluster";done


添加验证
---------------
这里我们在node1上操作

.. code-block:: bash

    pcs cluster auth node1 node2 node3

然后打开浏览器访问，比如我们访问node1,， https://node1:2224

使用用户名hacluster，密码redhat。



常用操作
================


查看集群状态
-------------------

.. code-block:: bash

    crm_mon -1


设置指定节点node1为故障节点（维护模式）
--------------------------------------------

.. code-block:: bash

    pcs cluster standby node1

恢复指定节点node1
------------------------

.. code-block:: bash

    pcs cluster unstandby node1



停止当前集群节点
-------------------------

.. code-block:: bash

    pcs cluster stop


启动当前集群节点
------------------------

.. code-block:: bash

    pcs cluster start

停止所有集群节点
------------------------

.. code-block:: bash

    pcs cluster stop --all

启动所有集群节点
-------------------------

.. code-block:: bash

    pcs cluster start --all


将资源vip移动的指定节点node3
----------------------------------

.. code-block:: bash

    pcs resource move vip node3

查看资源组列表
-------------------

.. code-block:: bash

    pcs resource group list

查看指定资源信息
-----------------------
这里我们查看名为vip的资源的信息。

.. code-block:: bash

    pcs resource show vip

查看节点id和票数
-------------------------

.. code-block:: bash

    [root@node2 ~]# corosync-quorumtool -l

    Membership information
    ----------------------
        Nodeid      Votes Name
             1          1 node1
             2          1 node2 (local)
             3          1 node3
             4          1 node4

修改指定节点的票数
------------------------

.. code-block:: bash

    $ vim /etc/corosync/corosync.conf
      node {
            ring0_addr: node3
            nodeid: 3
            quorum_votes: 3
           }


开启日志文件并指定日志文件路径
------------------------------------------

.. code-block:: bash

    logging {
    to_syslog: yes
    to_file: yes
    logfile: /var/log/cluster/cluster.lo
    }

使配置文件生效
------------------

.. code-block:: bash

    pcs cluster reload corosync --all




从集群里删除指定节点
-----------------------------

.. code-block:: bash

    pcs cluster node remove node4


安装fence
-----------------

.. code-block:: bash

    yum install fence-virt* -y

创建fence的key
----------------------

.. code-block:: bash

    dd if=/dev/zero of=/etc/cluster/fence_kvm.key bs=1024 count=4

设置fence
-------------------

.. code-block:: bash

    fence_vpcs cluster node remove node3irtd -c


通过fence重启指定服务器
---------------------------------

.. code-block:: bash

    fence_xvm -o reboot -H node2



资源的约束条件
=======================

限制---资源的约束条件

    colocation---保证所有的资源在同一台机器上运行
    location---保证哪个节点优先运行资源
    order---保证资源的自动顺序

把多个资源放在一个group里，往group存放的顺序很重要

    放在同一个group里的资源 使用会保持在同一台机器运行

    使用group的话，实现了两种约束条件

        colocation
        order




如果我们想把资源从一台机器移动到另一台机器上的话，我们只要移动vip就可以了，也就是group里的第一个资源。 group内的其他资源，始终会跟随第一个资源。
