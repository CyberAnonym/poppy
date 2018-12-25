binlog日志管理
########################



开启binlog
==================

下面我们添加了两行内容，一行server-id=1, 如果是单台mysql数据库，那么这个id可以随便写个数字，但如果是集群，则不同的mysql配置的server-id不能相同。

log-bin= 这一行配置的是binlog日志的文件前缀，包括存放地址。 这里我们将binlog日志放在了/mysql-binlog目录下，便于备份和管理，我们也需要先创建这个目录并给予mysql权限。

::

    $ mkdir -p /mysql-binlog
    $ chown mysql:mysql /mysql-binlog
    $ vim /etc/my.cnf
    [mysqld]
    server-id=1
    log-bin=/mysql-binlog/mysql-bin


然后重启mysql服务

数据库里查看binlog
===========================

::

    MariaDB [test]> show binary logs;
    +------------------+-----------+
    | Log_name         | File_size |
    +------------------+-----------+
    | mysql-bin.000001 |       881 |
    +------------------+-----------+
    1 row in set (0.00 sec)



查看binlog文件
========================

::

    [root@d ~]# ll /var/lib/mysql/mysql-bin.*
    -rw-rw---- 1 mysql mysql 881 Dec 12 13:34 /var/lib/mysql/mysql-bin.000001
    -rw-rw---- 1 mysql mysql  19 Dec 12 13:31 /var/lib/mysql/mysql-bin.index

查看binlog文件内容
===========================

::

    $ mysqlbinlog -v /var/lib/mysql/mysql-bin.000001


下面简单说一下怎么用bin-log恢复数据


::

    mysqlbinlog  /var/lib/mysql/BIN-log.000009 --stop-POSITION=1255|mysql -uroot -pMyNewPass4!


mysqlbinlog常见的选项有以下几个：

::

    --start-datetime：从二进制日志中读取指定等于时间戳或者晚于本地计算机的时间
    --stop-datetime：从二进制日志中读取指定小于时间戳或者等于本地计算机的时间 取值和上述一样
    --start-position：从二进制日志中读取指定position 事件位置作为开始。
    --stop-position：从二进制日志中读取指定position 事件位置作为事件截至 



备份binlog 时，可以先执行一下mysqladmin flush-logs, 增量备份脚本是备份前flush-logs,mysql会自动把内存中的日志放到文件里,然后生成一个新的日志文件,所以我们只需要备份前面的几个即可,也就是不备份最后一个.

::

    mysqladmin flush-logs