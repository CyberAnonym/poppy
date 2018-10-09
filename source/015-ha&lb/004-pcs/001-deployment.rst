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