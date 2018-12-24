apt-get
##########
apt-get 是ubuntu系统下安装软件的命令。


source.list解析
=======================

deb http://cn.archive.ubuntu.com/ubuntu/ precise main restricted

这句话到底怎么解释，对应着服务器上的什么目录呢？  对应的是：

::

    http://cn.archive.ubuntu.com/ubuntu/dists/precise/main

    http://cn.archive.ubuntu.com/ubuntu/dists/precise/restricted



也就是说，解析规则是这样的 ：


uri + "dists" + 版本信息 + 若干个分类



查看/设置软件源
===================
这里我们是一台阿里云的服务器，使用的是阿里云的内网软件源。

.. code-block:: bash

    root@alvin:~# cat /etc/apt/sources.list
    deb http://mirrors.aliyuncs.com/ubuntu/ xenial main restricted universe multiverse
    deb http://mirrors.aliyuncs.com/ubuntu/ xenial-security main restricted universe multiverse
    deb http://mirrors.aliyuncs.com/ubuntu/ xenial-updates main restricted universe multiverse
    deb http://mirrors.aliyuncs.com/ubuntu/ xenial-proposed main restricted universe multiverse
    deb http://mirrors.aliyuncs.com/ubuntu/ xenial-backports main restricted universe multiverse
    deb-src http://mirrors.aliyuncs.com/ubuntu/ xenial main restricted universe multiverse
    deb-src http://mirrors.aliyuncs.com/ubuntu/ xenial-security main restricted universe multiverse
    deb-src http://mirrors.aliyuncs.com/ubuntu/ xenial-updates main restricted universe multiverse
    deb-src http://mirrors.aliyuncs.com/ubuntu/ xenial-proposed main restricted universe multiverse
    deb [arch=amd64,ppc64el,i386] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    # deb-src [arch=amd64,ppc64el,i386] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    # deb-src [arch=i386,ppc64el,amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    deb-src http://mirrors.aliyuncs.com/ubuntu/ xenial-backports main restricted universe multiverse

非阿里云内网，则可以使用阿里云的外网的镜像服务



.. code-block:: bash

    root@alvin:~# cat /etc/apt/sources.list
    deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
    deb [arch=amd64,ppc64el,i386] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    # deb-src [arch=amd64,ppc64el,i386] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    # deb-src [arch=i386,ppc64el,amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu xenial main
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse



更新软件源
=============

.. code-block:: bash

    apt-get update


安装软件
============
安装nginx

.. code-block:: bash

    apt-get install nginx