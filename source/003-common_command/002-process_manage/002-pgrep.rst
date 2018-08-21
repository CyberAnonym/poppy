pgrep
#####
pgrep用来过滤指定命令的pid， pid是process id,进程id。


比如我们当前有一个进程叫做/usr/bin/python2 -m CGIHTTPServer 8001,那么我们可以执行pgrep python2来获取它的pid

.. code-block:: bash

    [root@alvin ~]# ps -ef|grep python
    sophiro+  14496      1  0 10:34 ?        00:00:00 /usr/bin/python2 -m CGIHTTPServer 8001
    root      14901  14502  0 10:39 pts/0    00:00:00 grep --color=auto python
    [root@alvin ~]# pgrep 8001
    [root@alvin ~]# pgrep CGIHTTPServer
    [root@alvin ~]# pgrep python2
    14496



pgrep 是匹配命令的，不包括命令的参数，不完整匹配命令，命令中包含我们指定的内容，就会被匹配出来。

比如我们现在要匹配zabbix的进程。


.. code-block:: bash

    [root@alvin ~]# ps -ef|grep zabbix
    zabbix    14587      1  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf
    zabbix    14588  14587  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd: collector [idle 1 sec]
    zabbix    14589  14587  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd: listener #1 [waiting for connection]
    zabbix    14590  14587  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd: listener #2 [waiting for connection]
    zabbix    14591  14587  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd: listener #3 [waiting for connection]
    zabbix    14592  14587  0 10:34 ?        00:00:00 /usr/sbin/zabbix_agentd: active checks #1 [idle 1 sec]
    root      14985  14502  0 10:41 pts/0    00:00:00 grep --color=auto zabbix
    [root@alvin ~]#
    [root@alvin ~]# pgrep zabbix
    14587
    14588
    14589
    14590
    14591
    14592
    [root@alvin ~]# pgrep zabb
    14587
    14588
    14589
    14590
    14591
    14592
    [root@alvin ~]# pgrep bix_age
    14587
    14588
    14589
    14590
    14591
    14592
