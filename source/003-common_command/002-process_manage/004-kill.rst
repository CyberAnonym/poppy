kill
#####


正常杀进程
==============

#. ps查看后过滤出我们指定的进程

    .. code-block:: bash

        ps -ef|grep logstash

#. 然后杀掉进程

    $pid 代表的是进程的id，实际上使用是替换为进程的id

    .. code-block:: bash

        kill $pid

强行杀进程
=================

    有时候进程正在做某些事，无法正常结束，那我们就要强行结束了，使用-9参数强行结束。

    .. code-block:: bash

        kill -9 $pid