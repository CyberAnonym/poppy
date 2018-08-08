pkill
######


正常杀进程
==============

#. ps查看后过滤出我们指定的进程

    .. code-block:: bash

        ps -ef|grep zabbix_server

#. 然后杀掉进程

    这里我们不杀进程id，而是以命令的名字而去杀进程，我们要杀zabbix_server

    .. code-block:: bash

        kill zabbix_server

强行杀进程
===============

    有时候进程正在做某些事，无法正常结束，那我们就要强行结束了，使用-9参数强行结束。

    .. code-block:: bash

        kill -9 zabbix_sever
