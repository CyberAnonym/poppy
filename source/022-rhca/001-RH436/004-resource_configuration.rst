第四章：创建和配置资源
#########################


吧


.. note:: 集群环境里我们要提供web服务必须几个资源？

    三个资源
        #. vip
        #. 存储
        #. 这个服务本身


**这里我们来做个试验，配置一套服务器，配置nfs文件共享，apache**

安装apache
==================

我们先安装在三台node上安装httpd服务。

.. code-block:: bash

    yum install httpd -y

.. warning::

    不要手动去启动服务，让crm（cluster resource manager）去管理服务,让他自动启动。

配置共享存储
====================

然后我们在server1上去配置目录共享。 server1模拟存储服务器。

.. code-block:: bash

    [root@server1 ~]# mkdir -p /www
    [root@server1 ~]# echo 'alvin web service' > /www/index.html

然后设置文件共享

.. code-block:: bash

    [root@server1 ~]# cat /etc/exports
    [root@server1 ~]# echo '/www *(ro,sync)' > /etc/exports
    [root@server1 ~]# exportfs -rav
    exporting *:/www

启动服务

.. code-block:: bash

    [root@server1 ~]# systemctl start nfs-server
    [root@server1 ~]# systemctl enable nfs-server


在dashboard里添加apache和存储
=======================================

当前我们已经有了vip了，然后我们先添加存储

.. image:: ../../../images/ha13.png

然后我们添加httpd服务。

.. image:: ../../../images/ha14.png


然后我们看下集群状态

.. code-block:: bash

    [root@node2 ~]# crm_mon -1
    Last updated: Wed Oct 17 17:20:51 2018
    Last change: Wed Oct 17 17:20:00 2018
    Stack: corosync
    Current DC: node1 (1) - partition with quorum
    Version: 1.1.12-a14efad
    3 Nodes configured
    4 Resources configured


    Online: [ node1 node2 node3 ]

     vip    (ocf::heartbeat:IPaddr2):       Started node1
     fence_xvm_test1        (stonith:fence_xvm):    Started node3
     web_fs (ocf::heartbeat:Filesystem):    Started node2
     web_svc        (systemd:httpd):        Started node1

那么上面的结果中可以看到，我们的vip web_fs web_svc 这三个服务，没有在同一台服务器上，这样就没法提供我们需要的服务。所以我们需要他们在同一台服务器上。

创建组，排列顺序
==============================


这里我们可以先勾选一个或者多个，这里我们是先勾选2个，还有一个服务等下也可以单独再加到组里去。

.. image:: ../../../images/ha15.png


.. note::

    刚才我们演示了勾选两个服务，然后创建组，实际上，如果服务依赖先后顺序的话，那我们还是要注意一下加入组的顺序的，我们可以先用vip服务创建一个组，然后按照顺序将存储加入组，然后将服务httpd加入组。

现在我们将web_svc加入组

.. image:: ../../../images/ha16.png

这样，我们三个服务就都在一个组里了，我们在命令行下看一下，也可以看到，三个服务都在同一个组里了，也都在同一个节点上了，也就是可以协同提供服务了。

.. image:: ../../../images/ha17.png


访问一下

.. code-block:: bash

    [root@node2 ~]# curl 192.168.122.100
    alvin web service


创建mysql高可用环境
===============================
下面，我们来做个mysql的高可用

创业mysql的共享存储
------------------------------

下面我们创建了/db目录，并使用nfs共享，然后设置权限所有者和所属组ID为27，27是mysql用户和组的id，如果不设置这个权限，客户端在挂载之后，mysql会没有权限访问这个目录。

.. code-block:: bash

    [root@server1 ~]# mkdir -p /db
    [root@server1 ~]# echo '/db *(rw,sync)' >> /etc/exports
    [root@server1 ~]# exportfs -rav
    exporting *:/db
    exporting *:/www
    [root@server1 ~]# chown 27:27 /db/
    [root@server1 ~]# ls -ld /db/
    drwxr-xr-x. 2 27 27 6 Oct 17 17:43 /db/

安装mysql服务
----------------------

在三个节点上都安装

.. code-block:: bash

    yum install mariadb-server mariadb -y

创建集群内资源
-------------------

然后我们开始在集群里创建资源，创建vip、存储和服务。


- 创建vip

.. image:: ../../../images/ha18.png

- 创建共享存储

fs就是file system，文件系统的意思，也是存储

.. image:: ../../../images/ha19.png

- 创建mariadb服务

.. image:: ../../../images/ha20.png

| mysql的服务的启动顺序很重要，存储一定要先启动，然后再启动服务，否则服务启动的时候，数据都写到本地磁盘去了，然后你存储后面才挂上去，那就要出问题了。
| 所以我们启动的顺序是，vip,存储，服务。

那么这里我们使用order来管理启动顺序，

这里我先设置一个vip在存储前面启动

.. image:: ../../../images/ha21.png

然后设置一个mysql服务在存储之后启动。


.. image:: ../../../images/ha22.png

然后创建一个组，然后将三个资源都放到这个组，加入组的时候注意顺序，先加vip，然后是存储，然后是服务，加入同一个组确保它们在同一个节点上。


.. image:: ../../../images/ha23.png

然后在命令行里也查看一下，确保都在同一个节点，一切运行正常

.. code-block:: bash

    [root@node1 ~]# crm_mon -1
    Last updated: Thu Oct 18 10:59:32 2018
    Last change: Thu Oct 18 10:55:44 2018
    Stack: corosync
    Current DC: node2 (2) - partition with quorum
    Version: 1.1.12-a14efad
    3 Nodes configured
    7 Resources configured


    Online: [ node1 node2 node3 ]

     fence_xvm_test1        (stonith:fence_xvm):    Started node1
     Resource Group: web_group
         vip        (ocf::heartbeat:IPaddr2):       Started node1
         web_fs     (ocf::heartbeat:Filesystem):    Started node1
         web_svc    (systemd:httpd):        Started node1
     Resource Group: mysql_group
         mysql_vip  (ocf::heartbeat:IPaddr2):       Started node2
         mysql_fs   (ocf::heartbeat:Filesystem):    Started node2
         mysql_svc  (systemd:mariadb):      Started node2

mysql服务在node2上面，所以现在我们去node2上面进入数据库，配置下用户权限,这里我们将root用户的密码设置成了alvin，不做其他设置。

.. code-block:: bash

    [root@node2 ~]# mysql -uroot -p
    Enter password:
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 5
    Server version: 5.5.41-MariaDB MariaDB Server

    Copyright (c) 2000, 2014, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> grant all privileges on *.* to 'root'@'%' identified by 'alvin';
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> exit
    Bye

然后我们在客户端server1上验证一下

.. code-block:: bash

    [root@server1 ~]# mysql -uroot -palvin -h192.168.122.200 -e 'select @@hostname' 2>/dev/null
    +------------+
    | @@hostname |
    +------------+
    | node2      |
    +------------+

验证资源可用性
----------------------

然后我们迁移一下服务实施，我们就迁移那个火车头，mysql_vip,让其他服务跟着它迁移

.. code-block:: bash

    crm_mon -1
    pcs resource move mysql_vip node3
    crm_mon -1

迁移前后我们有查看集群状态，确认mysql需要的三个资源都从node2迁移到node3去了。

然后我们又去客户端验证一下,确认服务以及迁移到node3上去了， 数据库用户依然可用，因为node3上的数据盘是挂载的共享存储。

.. code-block:: bash

    [root@server1 ~]# mysql -uroot -palvin -h192.168.122.200 -e 'select @@hostname'
    +------------+
    | @@hostname |
    +------------+
    | node3      |
    +------------+
