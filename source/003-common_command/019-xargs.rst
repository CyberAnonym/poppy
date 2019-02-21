xargs
#######






直接使用xargs
======================
直接使用xargs 将标准输出放到本次命令中做标准输入


.. code-block:: bash

    [root@test3 ~]# ll alvin.log
    -rw-r--r-- 1 root root 6 Feb 21 16:29 alvin.log
    [root@test3 ~]#
    [root@test3 ~]# echo 'alvin.log'|xargs ls
    alvin.log
    [root@test3 ~]# echo 'alvin.log'|xargs ls -l
    -rw-r--r-- 1 root root 6 Feb 21 16:29 alvin.log



使用-i参数，将标准输出的内容替换为{}
===================================================

.. code-block:: bash

    [root@test3 ~]# echo hello >> alvin.log
    [root@test3 ~]# cat alvin.log
    hello
    [root@test3 ~]#
    [root@test3 ~]# find . -name alvin.log
    ./alvin.log
    [root@test3 ~]# find . -name alvin.log |xargs -i cp {} {}.bak
    [root@test3 ~]# ll
    total 12
    -rw-r--r--  1 root root    6 Feb 21 16:29 alvin.log
    -rw-r--r--  1 root root    6 Feb 21 16:30 alvin.log.bak
    -rw-------. 1 root root 1555 Dec 17 15:35 anaconda-ks.cfg
    [root@test3 ~]# find . -name alvin.log |xargs -I AA cp AA AA.bak



使用-I参数，将前面标准输出的内容替换为我们指定的内容
==============================================================

这里我们将前面标准输出的内容替换为AA

.. code-block:: bash


    [root@test3 ~]# ll
    total 12
    -rw-r--r--  1 root root    6 Feb 21 16:29 alvin.log
    -rw-r--r--  1 root root    6 Feb 21 16:30 alvin.log.bak
    -rw-------. 1 root root 1555 Dec 17 15:35 anaconda-ks.cfg
    [root@test3 ~]# find . -name alvin.log |xargs -I AA cp AA AA.6666
    [root@test3 ~]# ll
    total 16
    -rw-r--r--  1 root root    6 Feb 21 16:29 alvin.log
    -rw-r--r--  1 root root    6 Feb 21 16:31 alvin.log.6666
    -rw-r--r--  1 root root    6 Feb 21 16:30 alvin.log.bak
    -rw-------. 1 root root 1555 Dec 17 15:35 anaconda-ks.cfg
