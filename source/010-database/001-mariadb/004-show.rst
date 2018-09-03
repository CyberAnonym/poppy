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