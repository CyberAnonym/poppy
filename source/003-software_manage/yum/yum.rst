yum
####
使用yum前，需要已经配置好了yum源。

yum安装指定软件
=====================

.. code-block:: bash

    yum install httpd


yum查看那个包提供指定命令
==========================
查看sar这个命令是由那个包提供的。


.. code-block:: bash

    yum provides sysstat

yum升级指定包
======================

升级httpd包

.. code-block:: bash

    yum upgrade httpd


清理yum缓存
=================

.. code-block:: bash

    yum clean all

缓存包信息到本地
=====================

.. code-block:: bash

    yum makecache

查看仓库列表
====================

.. code-block:: bash

    yum repolist

查看指定包信息
=====================
查看ntp包的信息

.. code-block:: bash

    yum info ntp

查看rpm包列表
======================

.. code-block:: bash

    yum list

查看包组的列表
========================

.. code-block:: bash

    yum grouplist

安装包组
===============
这里我们安装"Server with GUI"这个包组

.. code-block:: bash

    yum groupinstall "Server with GUI"
