show
############

查看正在处理的操作
===========================
.. code-block:: sql

    show processlist;


查看正在处理的操作的sql的全部内容
============================================
.. code-block:: sql

    show full processlist;

如果要结束查询出来的在执行的语句，使用kill， kill对应语句的id可以结束。


查看变量
=============

查看变量时使用匹配

.. code-block:: sql

    MySQL [(none)]> show variables like 'wsrep_node%';
    +-----------------------------+-----------------+
    | Variable_name               | Value           |
    +-----------------------------+-----------------+
    | wsrep_node_address          |                 |
    | wsrep_node_incoming_address | AUTO            |
    | wsrep_node_name             | db2.shenmin.com |
    +-----------------------------+-----------------+


查看当前用户的权限
========================

.. code-block:: sql

    show grants;
    show grants for current_user();


查看指定该用户的权限

.. code-block:: sql

    MariaDB [(none)]> show grants for nova@localhost;
    +-------------------------------------------------------------------------------------------------------------+
    | Grants for nova@localhost                                                                                   |
    +-------------------------------------------------------------------------------------------------------------+
    | GRANT USAGE ON *.* TO 'nova'@'localhost' IDENTIFIED BY PASSWORD '*0BE3B501084D35F4C66DD3AC4569EAE5EA738212' |
    | GRANT ALL PRIVILEGES ON `nova`.* TO 'nova'@'localhost'                                                      |
    | GRANT ALL PRIVILEGES ON `nova_cell0`.* TO 'nova'@'localhost'                                                |
    | GRANT ALL PRIVILEGES ON `nova_api`.* TO 'nova'@'localhost'                                                  |
    +-------------------------------------------------------------------------------------------------------------+
    4 rows in set (0.00 sec)

    MariaDB [(none)]> show grants for alvin@'%';
    +---------------------------------------------------------------------------------------------------------------+
    | Grants for alvin@%                                                                                            |
    +---------------------------------------------------------------------------------------------------------------+
    | GRANT ALL PRIVILEGES ON *.* TO 'alvin'@'%' IDENTIFIED BY PASSWORD '*9A9D1E495BC0C1EEB2F8FFBD84EA92F95F94EF15' |
    +---------------------------------------------------------------------------------------------------------------+
    1 row in set (0.00 sec)
