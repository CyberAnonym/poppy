nfs
###
nfs - Network File System

安装nfs
=========
.. code-block:: bash

    yum install nfs-utils

共享指定目录/opt
======================
这里我们对指定网段192.168.1.0/24开放本共享，如果是对所有网段共享，则使用*

.. code-block:: bash

# vim /etc/exports
/opt