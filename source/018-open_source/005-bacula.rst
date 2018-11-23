bacula
#############
开源备份软件


介绍
=======

Bacula是一个开源网络备份解决方案，允许您创建备份和执行计算机系统的数据恢复。它非常灵活和健壮，这使得它，虽然配置稍微麻烦，适合在许多情况下的备份。备份系统是在大多数服务器基础架构的重要组成部分 ，从数据丢失恢复往往是灾难恢复计划的重要组成部分。 在本教程中，我们将向您展示如何在CentOS 7服务器上安装和配置Bacula的服务器组件。我们将配置Bacula执行每周作业，创建本地备份（即其自己的主机的备份）。这本身并不是Bacula的特别引人注目的用途，但它将为您创建其他服务器（即备份客户端）的备份提供一个良好的起点。本系列的下一个教程将介绍如何通过安装和配置Bacula客户端以及配置Bacula服务器来创建其他远程服务器的备份。 如果您想使用Ubuntu 14.04代替，请点击此链接： 如何在Ubuntu 14.04安装Bacula的服务器 。


安装bacula
==================

bacula下载地址：http://blog.bacula.org/source-download-center/



下载软件
---------------

.. code-block:: bash

    wget http://blog.bacula.org/download/5684/

解压软件
----------

::
    tar xf index.html

安装依赖包
---------------

::

    yum install gcc gcc-c++ -y


检查编译环境
------------------

::

    cd bacula-9.2.2/
     ./configure --prefix=/usr/local/bacula --sbindir=/usr/local/bacula/sbin --sysconfdir=/usr/local/bacula/etc --enable-smartalloc --with-working-dir=/usr/local/bacula/bin/working --with-subsys-dir=/usr/local/bacula/bin/working --with-pid-dir=/usr/local/bacula/bin/working --with-mysql



开始编译
--------------

这里指定了路径为/usr/local/bacula，默认情况下,bacula 的安装路径为/etc/bacula.


::

    make && make install
    make install-autostart

设置环境变量
-------------------


    $ vim /etc/profile
    export PATH=$PATH:/usr/local/bacula/sbin
    $ source /etc/profile

