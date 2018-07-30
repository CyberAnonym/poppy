swap
####
linux下的交换分区


创建一块用于swap分区的磁盘
==============================
这里我们有一块磁盘sdb，我们在这块磁盘上分一个区出来。


.. code-block:: bash

    fdisk /dev/sdb
    p #打印看看
    n #开始分区
        #回车
        #回车
    +512M
    t
    2 #对应刚才创建的磁盘的编号
    82 #swap格式的号码
    w
    partprobe #通知内核重新读取分区表


格式化为交换分区格式
==========================

.. code-block:: bash

    mkswap /dev/sdb2   #/dev/sdb2是我们刚才创建的那块盘


临时开启该swap
====================

.. code-block:: bash

    swapon /dev/sdb2
    free

开机自动开启该swap
=======================
.. code-block:: bash

    echo "/dev/sdb2 swap swap defaults 0 0 " >> /etc/fstab