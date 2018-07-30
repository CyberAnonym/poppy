saltstack 分组
########################


参考网络资料
==================

http://docs.saltstack.com/topics/targeting/nodegroups.html

http://docs.saltstack.com/ref/states/top.html


salt的分组
================

使用saltstack的原因是为了对批量的机器执行相同的操作。大的来说上千台机器，不可能所有的机器都运行相同的业务，有可能这一百台运行的是web、另外一百台运行的是db ，所以分组就显的比较有用。

首先如果不分组，直接用salt命令执行是不是也可以呢？

配置分组
----------------

.. code-block:: bash

    [root@saltstack ~]# salt -C 'P@os:CentOS' test.ping
    db2.alv.pub:
        True
    db1.alv.pub:
        True
    saltstack.alv.pub:
        True
    ansible.alv.pub:
        True
    iscsi.alv.pub:
        True
    zabbix.alv.pub:
        True
    db3.alv.pub:
        True
    maxscale.alv.pub:
        True
    dc.alv.pub:
        True
    jenkins.alv.pub:
        True
    dhcp.alv.pub:
        True


从上面执行的结果看，是OK的。那为什么还要引入分组，当然是为了简化这个过程，以后只需要 -N +组句就ok了，而且也便于区分。

为minion进行预先分组配置非常简单，只需要编辑/etc/salt/master文件即可。示例如下：


.. code-block:: bash

    [root@saltstack ~]# vim /etc/salt/master
    nodegroups:
      dbs: 'L@db1.alv.pub,db2.alv.pub,db3.alv.pub'
      zabbix: 'zabbix.alv.pub'
    ```
    测试test.ping 效果如下
    ```bash
    [root@saltstack ~]# salt -N dbs test.ping
    db1.alv.pub:
        True
    db2.alv.pub:
        True
    db3.alv.pub:
        True
    [root@saltstack ~]# salt -N zabbix test.ping
    zabbix.alv.pub:
        True




分组语法
--------------

nodegroup分组时可以用到的语法关键字有G、E、P、L、I、S、R、D几个，几者的意义和用法如文档最上面的表所显示


此外，匹配中可以使用and、or及not等boolean型操作。例：

.. code-block:: bash

    [root@saltstack ~]# salt -C 'db1.alv.pub or db2.alv.pub' test.ping
    db2.alv.pub:
        True
    db1.alv.pub:


子网匹配
---------------


.. code-block:: bash

    [root@saltstack ~]# salt -C 'S@192.168.127.0/24' test.ping
    ansible.alv.pub:
        True
    maxscale.alv.pub:
        True
    dc.alv.pub:
        True
    iscsi.alv.pub:
        True
    db1.alv.pub:
        True
    dhcp.alv.pub:
        True
    db2.alv.pub:
        True
    db3.alv.pub:
        True
    saltstack.alv.pub:
        True
    zabbix.alv.pub:
        True
    jenkins.alv.pub:


加上and匹配
-------------

.. code-block:: bash

    [root@saltstack ~]# salt -C 'S@192.168.127.0/24 and db*' test.ping
    db1.alv.pub:
        True
    db2.alv.pub:
        True
    db3.alv.pub:



