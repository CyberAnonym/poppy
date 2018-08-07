fdisk
#####

fdisk是下的一个磁盘分区工具


当前我们有一块磁盘sdb,我们来通过fdisk来对sdb进行分区。


创建一个1G的分区。
=====================

.. code-block:: bash

    fdisk /dev/sdb
    n


    +1G
    w
