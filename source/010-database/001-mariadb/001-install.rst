Install
###############

Getting Started with MariaDB Galera Cluster： https://mariadb.com/kb/en/library/getting-started-with-mariadb-galera-cluster/


Installing MariaDB Galera Cluster with YUM  ： https://mariadb.com/kb/en/library/yum/#installing-mariadb-galera-cluster-with-yum

Installing MariaDB Galera Cluster with apt-get： https://mariadb.com/kb/en/library/installing-mariadb-deb-files/#installing-mariadb-galera-cluster-with-apt-get

配置yum仓库的地址： https://downloads.mariadb.org/mariadb/repositories/#mirror=tuna&distro=CentOS&distro_release=centos7-amd64--centos7&version=10.3

这里我们选择了centos的yum配置， 我们要安装的是mariadb galera cluster


本次安装配置的环境是两台服务器，db1 和db2，组成集群。


配置yum
===============

.. code-block:: bash

    # vim /etc/yum.repos.d/mariadb.repo
    [mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.0/centos7-amd64
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1

这里我们安装的版本是10，目前也不能用更高的版本，官方如此解释： Galera Cluster is included in the default MariaDB packages from 10.1, so the instructions in this section are only required for MariaDB 10.0 and MariaDB 5.5.



安装mariadb
======================
.. code-block:: bash

    sudo yum install MariaDB-Galera-server MariaDB-client galera

编辑mariadb配置文件
============================
这里wsrep_cluster_address这一栏是写的数据库集群内的所有服务器地址

.. code-block:: bash

    [root@db1 ~]# vim /etc/my.cnf.d/server.cnf
    [root@db1 ~]# grep -vE "^#|^$" /etc/my.cnf.d/server.cnf
    [server]
    [mysqld]
    character_set_server=utf8
    lower_case_table_names=1
    max_connect_errors=1000
    [galera]
    wsrep_provider=/usr/lib64/galera/libgalera_smm.so
    wsrep_cluster_address="gcomm://192.168.1.54,192.168.1.55"
    binlog_format=row
    default_storage_engine=InnoDB
    innodb_autoinc_lock_mode=2
    bind-address=0.0.0.0
    wsrep_cluster_name="galera_cluster"
    [embedded]
    [mariadb]
    [mariadb-10.0]


启动数据库
===================

.. code-block:: bash

    # /etc/init.d/mysql start --wsrep-new-cluster   #集群的第一个节点启动时需要加--wsrep-new-cluster 参数，其他节点接下来启动时不需要加。


另一台服务器做好安装和配置
======================================

安装rpm包和配置的命令和上面的一样，这里就省略了，然后启动

第二台服务器启动的命令和第一台不一样,第二台直接执行systemctl start mysql

.. code-block:: bash

    [root@db2 ~]# systemctl start mysql
    [root@db2 ~]# systemctl status mysql
    ● mysql.service - LSB: start and stop MariaDB
       Loaded: loaded (/etc/rc.d/init.d/mysql; bad; vendor preset: disabled)
       Active: active (running) since Mon 2018-09-03 15:57:11 CST; 11s ago
         Docs: man:systemd-sysv-generator(8)
      Process: 1450 ExecStart=/etc/rc.d/init.d/mysql start (code=exited, status=0/SUCCESS)
       CGroup: /system.slice/mysql.service
               ├─1455 /bin/sh /usr/bin/mysqld_safe --datadir=/var/lib/mysql --pid-file=/var/lib/mysql/db2.shenmin.com.pid
               └─1611 /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --wsrep_provider=/usr/lib64/galera/lib...

    Sep 03 15:57:02 db2.shenmin.com rsyncd[1675]: receiving file list
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1674]: sent 35 bytes  received 84 bytes  total size 0
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1679]: name lookup failed for 192.168.1.54: Name or service not known
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1679]: connect from UNKNOWN (192.168.1.54)
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1673]: sent 1688 bytes  received 995502 bytes  total size 990599
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1679]: rsync to rsync_sst/ from UNKNOWN (192.168.1.54)
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1679]: receiving file list
    Sep 03 15:57:02 db2.shenmin.com rsyncd[1679]: sent 54 bytes  received 176 bytes  total size 39
    Sep 03 15:57:11 db2.shenmin.com mysql[1450]: ..SST in progress, setting sleep higher. SUCCESS!
    Sep 03 15:57:11 db2.shenmin.com systemd[1]: Started LSB: start and stop MariaDB.
    [root@db2 ~]#


后续重启也用systemctl restart mysql。


这个时候集群就起来了。

重启第一台数据库服务
===========================
这个时候第一台启动的数据库服务还不是用systemctl 来管理的，所以我们改变下启动方式，让它来管理。 一开始没用systemctl ,是因为它不方便使用那个参数。

下面的内容中，我们有多次查询确认操作，不执行也可以，主要的变更命令就是/etc/init.d/mysql stop;systemctl start mysql

::

    [root@db1 ~]# systemctl status mysql
    ● mysql.service - LSB: start and stop MariaDB
       Loaded: loaded (/etc/rc.d/init.d/mysql; bad; vendor preset: disabled)
       Active: inactive (dead) since Mon 2018-09-03 15:50:09 CST; 9min ago
         Docs: man
         :systemd-sysv-generator(8)
      Process: 28588 ExecStop=/etc/rc.d/init.d/mysql stop (code=exited, status=0/SUCCESS)
      Process: 28458 ExecStart=/etc/rc.d/init.d/mysql start (code=exited, status=0/SUCCESS)

    Sep 03 15:48:56 db1.shenmin.com systemd[1]: Starting LSB: start and stop MariaDB...
    Sep 03 15:48:56 db1.shenmin.com mysql[28458]: Starting MariaDB SUCCESS!
    Sep 03 15:48:56 db1.shenmin.com systemd[1]: Started LSB: start and stop MariaDB.
    Sep 03 15:48:56 db1.shenmin.com mysql[28458]: 180903 15:48:56 mysqld_safe Logging to '/var/lib/mysql/db1.shenmin.com.err'.
    Sep 03 15:48:56 db1.shenmin.com mysql[28458]: 180903 15:48:56 mysqld_safe A mysqld process already exists
    Sep 03 15:50:09 db1.shenmin.com systemd[1]: Stopping LSB: start and stop MariaDB...
    Sep 03 15:50:09 db1.shenmin.com mysql[28588]: ERROR! MariaDB server PID file could not be found!
    Sep 03 15:50:09 db1.shenmin.com systemd[1]: Stopped LSB: start and stop MariaDB.
    [root@db1 ~]#
    [root@db1 ~]# /etc/init.d/mysql stop
    Shutting down MariaDB........... SUCCESS!
    [root@db1 ~]#
    [root@db1 ~]# /etc/init.d/mysql status
     ERROR! MariaDB is not running
    [root@db1 ~]#
    [root@db1 ~]# systemctl start mysql
    [root@db1 ~]#
    [root@db1 ~]# /etc/init.d/mysql status
     SUCCESS! MariaDB running (29077)
    [root@db1 ~]#
    [root@db1 ~]# systemctl status mysql
    ● mysql.service - LSB: start and stop MariaDB
       Loaded: loaded (/etc/rc.d/init.d/mysql; bad; vendor preset: disabled)
       Active: active (running) since Mon 2018-09-03 15:59:55 CST; 11s ago
         Docs: man:systemd-sysv-generator(8)
      Process: 28588 ExecStop=/etc/rc.d/init.d/mysql stop (code=exited, status=0/SUCCESS)
      Process: 28916 ExecStart=/etc/rc.d/init.d/mysql start (code=exited, status=0/SUCCESS)
       CGroup: /system.slice/mysql.service
               ├─28921 /bin/sh /usr/bin/mysqld_safe --datadir=/var/lib/mysql --pid-file=/var/lib/mysql/db1.shenmin.com.pid
               └─29077 /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --wsrep_provider=/usr/lib64/galera/li...

    Sep 03 15:59:50 db1.shenmin.com systemd[1]: Starting LSB: start and stop MariaDB...
    Sep 03 15:59:50 db1.shenmin.com mysql[28916]: Starting MariaDB.180903 15:59:50 mysqld_safe Logging to '/var/lib/mysql/db1.shenmin.com.err'.
    Sep 03 15:59:50 db1.shenmin.com mysql[28916]: 180903 15:59:50 mysqld_safe Starting mysqld daemon with databases from /var/lib/mysql
    Sep 03 15:59:55 db1.shenmin.com mysql[28916]: .. SUCCESS!
    Sep 03 15:59:55 db1.shenmin.com systemd[1]: Started LSB: start and stop MariaDB.



如果开启了selinux，你可能需要执行下面这些命令
======================================================
没有开启selinux，则忽略这些操作。

::

    setsebool -P nis_enabled 1
    ausearch -c 'my-rsyn' --raw | audit2allow -M my-rsyn
    semodule -i my-rsync.pp

    ausearch -c 'my-httpd' --raw | audit2allow -M my-httpd
    semodule -i my-httpd.pp

    ausearch -c 'wsrep_sst_rsync' --raw | audit2allow -M my-wsrepsstrsync
    semodule -i my-wsrepsstrsync.pp

    ausearch -c 'which' --raw | audit2allow -M my-which
    semodule -i my-which.pp

    ausearch -c 'mysqladmin' --raw | audit2allow -M my-mysqladmin
    semodule -i my-mysqladmin.pp

    ausearch -c 'mysqld' --raw | audit2allow -M my-mysqld
    semodule -i my-mysqld.pp

    ausearch -c 'audispd' --raw | audit2allow -M my-audispd
    semodule -i my-audispd.pp

    ausearch -c 'mysql' --raw | audit2allow -M my-mysql
    semodule -i my-mysql.pp


设置root密码
======================
这里我们进行一些初始化的操作，删除test数据库，移除匿名账号，设置root密码等。

两台服务器上都这样做。

.. code-block:: bash

     mysql_secure_installation


创建数据库和用户，验证数据同步
=====================================

db1上创建数据库，然后添加一个用户。

::

    [root@db1 ~]# mysql -uroot -p
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 14
    Server version: 10.0.36-MariaDB-wsrep MariaDB Server, wsrep_25.23.rc3fc46e

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    +--------------------+
    3 rows in set (0.01 sec)

    MariaDB [(none)]> create database sophiroth;
    Query OK, 1 row affected (0.01 sec)

    MariaDB [(none)]> grant all privileges on sophiroth.* to 'alvin'@'%' identified by 'sophiroth';
    Query OK, 0 rows affected (0.01 sec)

    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.00 sec)



db2上使用刚才在db1上创建的用户登录，查看数据库

::

    [root@db2 ~]# mysql -ualvin -p
    Enter password:
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 16
    Server version: 10.0.36-MariaDB-wsrep MariaDB Server, wsrep_25.23.rc3fc46e

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | sophiroth          |
    +--------------------+
    2 rows in set (0.00 sec)


从结果上看，可以判断db1和db2两边的数据是同步的。

