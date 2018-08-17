swapoff
############

关闭磁盘的swap
===================
关闭/dev/sdb2的swap

.. code-block:: bash

    # swapoff /dev/sdb2
    # free -m #确认一下


关闭所有swap
=================
命令关闭都是临时关闭，永久关闭需修改/etc/fstab文件里的内容，注释swap的行。

.. code-block:: bash

    $ sudo swapoff -a