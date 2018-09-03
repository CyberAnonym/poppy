maxscale
##############
数据库前端代理工具


安装maxscale
=========================

.. code-block:: bash

    $ sudo yum install https://downloads.mariadb.com/MaxScale/2.1.9/rhel/7/x86_64/maxscale-2.1.9-1.rhel.7.x86_64.rpm



在galera mariadb cluster数据库创建用于maxscale的账号
============================================================

.. code-block:: bash

    [root@db1 ~]# mysql -uroot -p
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 14
    Server version: 10.0.36-MariaDB-wsrep MariaDB Server, wsrep_25.23.rc3fc46e

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> grant all privileges on *.* to 'maxscale'@'%' identified by 'shenmin';
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.01 sec)


生成maxscale的key
==========================

下面的命令中，maxkeys 是先生成一种加密规格

然后maxpasswd 是使用指定目录加的加密规格，去加密后面那个shenmin， shenmin就是我们的数据库的密码。

.. code-block:: bash

    [root@maxscale ~]# maxkeys /var/lib/maxscale/
    [root@maxscale ~]# maxpasswd /var/lib/maxscale/ shenmin
    F1BC675B4E6A120A5C6FECEE4BB11599


配置maxscale
=====================

::

    [root@maxscale ~]# vim /etc/maxscale.cnf
    [root@maxscale ~]# cat /etc/maxscale.cnf
    # MaxScale documentation on GitHub:
    # https://github.com/mariadb-corporation/MaxScale/blob/2.1/Documentation/Documentation-Contents.md

    # Global parameters
    #
    # Complete list of configuration options:
    # https://github.com/mariadb-corporation/MaxScale/blob/2.1/Documentation/Getting-Started/Configuration-Guide.md

    [maxscale]
    threads=1
    ms_timestamp=1 #timesstamp精确度 ts=秒
    syslog=1 #将日志写到syslog
    maxlog=1 #将日志写到maxscale的日志文件中
    log_to_shm=0 #日志不写入共享缓存
    log_warning=1 #记录警告信息
    log_notice=0 #不记录notice
    log_info=0 #不记录info
    log_debug=0 #不打开debug模式
    log_augmentation=1 #日志递增

    # 定义三个mysql服务
    [server1]
    type=server
    address=192.168.1.54
    port=3306
    protocol=MySQLBackend
    serv_weight=1 #设置权重

    [server2]
    type=server
    address=192.168.1.55
    port=3306
    protocol=MySQLBackend
    serv_weight=1

    # Monitor for the servers
    #
    # This will keep MaxScale aware of the state of the servers.
    # MySQL Monitor documentation:
    # https://github.com/mariadb-corporation/MaxScale/blob/2.1/Documentation/Monitors/MySQL-Monitor.md

    #设置监控
    [Galera Monitor]
    type=monitor
    module=galeramon
    servers=server1,server2
    user=maxscale
    passwd=F1BC675B4E6A120A5C6FECEE4BB11599
    monitor_interval=10000

    #配置一个名为Read-Write的服务
    [Read-Write Service]
    type=service
    router=readwritesplit
    servers=server1,server2
    user=maxscale
    passwd=F1BC675B4E6A120A5C6FECEE4BB11599
    max_slave_connections=100%
    #weightby=serversize
    weightby=serv_weight

    #为Read-Write服务配置listener
    [Read-Write Listener]
    type=listener
    service=Read-Write Service
    protocol=MySQLClient
    port=4006

    [MaxAdmin Service]
    type=service
    router=cli

    [MaxAdmin Listener]
    type=listener
    service=MaxAdmin Service
    protocol=maxscaled
    socket=default
    [root@maxscale ~]#


修改目录权限

.. code-block:: bash

    # chown maxscale /var/lib/maxscale/ -R


启动maxscale服务
=====================

.. code-block:: bash

    # systemctl start maxscale
    # systemctl enable maxscale


使用maxadmin命令管理maxscale
======================================


查看命令帮助
--------------------

.. code-block:: bash

    [root@maxscale ~]# maxadmin help
    Available commands:
    add:
        add user - Add insecure account for using maxadmin over the network
        add server - Add a new server to a service

    remove:
        remove user - Remove account for using maxadmin over the network
        remove server - Remove a server from a service or a monitor

    create:
        create server - Create a new server
        create listener - Create a new listener for a service
        create monitor - Create a new monitor

    destroy:
        destroy server - Destroy a server
        destroy listener - Destroy a listener
        destroy monitor - Destroy a monitor

    alter:
        alter server - Alter server parameters
        alter monitor - Alter monitor parameters

    set:
        set server - Set the status of a server
        set pollsleep - Set poll sleep period
        set nbpolls - Set non-blocking polls
        set log_throttling - Set the log throttling configuration

    clear:
        clear server - Clear server status

    disable:
        disable log-priority - Disable a logging priority
        disable sessionlog-priority - [Deprecated] Disable a logging priority for a particular session
        disable root - Disable root access
        disable feedback - Disable MaxScale feedback to notification service
        disable syslog - Disable syslog logging
        disable maxlog - Disable MaxScale logging
        disable account - Disable Linux user

    enable:
        enable log-priority - Enable a logging priority
        enable sessionlog-priority - [Deprecated] Enable a logging priority for a session
        enable root - Enable root user access to a service
        enable feedback - Enable MaxScale feedback to notification service
        enable syslog - Enable syslog logging
        enable maxlog - Enable MaxScale logging
        enable account - Activate a Linux user account for MaxAdmin use

    flush:
        flush log - Flush the content of a log file and reopen it
        flush logs - Flush the content of a log file and reopen it

    list:
        list clients - List all the client connections to MaxScale
        list dcbs - List all active connections within MaxScale
        list filters - List all filters
        list listeners - List all listeners
        list modules - List all currently loaded modules
        list monitors - List all monitors
        list services - List all services
        list servers - List all servers
        list sessions - List all the active sessions within MaxScale
        list threads - List the status of the polling threads in MaxScale
        list commands - List registered commands

    reload:
        reload config - Reload the configuration
        reload dbusers - Reload the database users for a service

    restart:
        restart monitor - Restart a monitor
        restart service - Restart a service
        restart listener - Restart a listener

    shutdown:
        shutdown maxscale - Initiate a controlled shutdown of MaxScale
        shutdown monitor - Stop a monitor
        shutdown service - Stop a service
        shutdown listener - Stop a listener

    show:
        show dcbs - Show all DCBs
        show dbusers - [deprecated] Show user statistics
        show authenticators - Show authenticator diagnostics for a service
        show epoll - Show the polling system statistics
        show eventstats - Show event queue statistics
        show feedbackreport - Show the report of MaxScale loaded modules, suitable for Notification Service
        show filter - Show filter details
        show filters - Show all filters
        show log_throttling - Show the current log throttling setting (count, window (ms), suppression (ms))
        show modules - Show all currently loaded modules
        show monitor - Show monitor details
        show monitors - Show all monitors
        show persistent - Show the persistent connection pool of a server
        show server - Show server details
        show servers - Show all servers
        show serversjson - Show all servers in JSON
        show services - Show all configured services in MaxScale
        show service - Show a single service in MaxScale
        show session - Show session details
        show sessions - Show all active sessions in MaxScale
        show tasks - Show all active housekeeper tasks in MaxScale
        show threads - Show the status of the worker threads in MaxScale
        show users - Show enabled Linux accounts
        show version - Show the MaxScale version number

    sync:
        sync logs - Flush log files to disk

    call:
        call command - Call module command


    Type `help COMMAND` to see details of each command.
    Where commands require names as arguments and these names contain
    whitespace either the \ character may be used to escape the whitespace
    or the name may be enclosed in double quotes ".



查看服务器列表
-------------------------

.. code-block:: sh

    [root@maxscale ~]# maxadmin list servers
    Servers.
    -------------------+-----------------+-------+-------------+--------------------
    Server             | Address         | Port  | Connections | Status
    -------------------+-----------------+-------+-------------+--------------------
    server1            | 192.168.1.54    |  3306 |           0 | Master, Synced, Running
    server2            | 192.168.1.55    |  3306 |           0 | Slave, Synced, Running
    -------------------+-----------------+-------+-------------+--------------------
    [root@maxscale ~]# maxadmin
    MaxScale> list servers
    Servers.
    -------------------+-----------------+-------+-------------+--------------------
    Server             | Address         | Port  | Connections | Status
    -------------------+-----------------+-------+-------------+--------------------
    server1            | 192.168.1.54    |  3306 |           0 | Master, Synced, Running
    server2            | 192.168.1.55    |  3306 |           0 | Slave, Synced, Running
    -------------------+-----------------+-------+-------------+--------------------

通过maxscale访问数据库
=======================================

上面的查询结果是server1 是master, server2是slave, server1就是我们的db1服务器，我们配置的是读写分离，那么读取操作都会在server2上进行，那么下面我们查询一下数据库，查询主机名。

验证读操作
--------------

.. code-block:: bash

    [root@db2 ~]# mysql -umaxscale -pshenmin -hmaxscale.shenmin.com -P4006 -e 'select @@hostname;'
    +-----------------+
    | @@hostname      |
    +-----------------+
    | db2.shenmin.com |
    +-----------------+

结果显示是db2，正如我们所期望的那样。

验证写操作
-----------------
那么写入操作呢？ 我们也验证一下

这里我们先在mysql数据库创建一个test表，然后插入一条数据，数据有两列，id和name，其中的值，这里我们插入的是@@hostname，也就是当前主机的主机名，这样我们就能知道是在那台服务器上插入的了。


.. code-block:: bash

    [root@db2 ~]# mysql -umaxscale -pshenmin -hmaxscale.shenmin.com -P4006 -e ' create table mysql.test (id int,name varchar(24));'
    [root@db2 ~]# mysql -umaxscale -pshenmin -hmaxscale.shenmin.com -P4006 -e 'insert into mysql.test set id=1,name=@@hostname;'
    [root@db2 ~]# mysql -umaxscale -pshenmin -hmaxscale.shenmin.com -P4006 -e 'select * from mysql.test;'
    +------+-----------------+
    | id   | name            |
    +------+-----------------+
    |    1 | db1.shenmin.com |
    +------+-----------------+

如上所示，我们是在db1上插入的数据， 分写分离验证完成。
