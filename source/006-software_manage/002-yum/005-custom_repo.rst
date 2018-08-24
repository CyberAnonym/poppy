创建自定义软件仓库
#######################

如果有些rpm包我们本地内网的yum仓库里面没有，又经常需要用到，要去外网去下载，那么每次要用的时候都会依赖外网带宽，可能速度会很慢，需要消耗很长时间。

那么这个时候，我们可以把这些包下载下来，在本地创建一个自定义仓库，就放这些包。

这里以安装k8s为例，我们多台服务器需要安装那些外网网络yum源的rpm包。每次从网络上下载都需要很长时间，三台服务器要安装，时间就是三倍。

所以现在我们将这些包下载到本地，做成自定义yum仓库，然后每台服务器都使用这个本地的yum源，那速度就快了。


下载指定rpm包到本地
=================================

这里我们以docker-ce为例。

- 添加docker-ce的yum仓库

.. code-block:: bash

    $ wget -P /etc/yum.repos.d/ https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

- 创建用于存放rpm包的目录，下载rpm包到该目录

.. code-block:: bash

    $ sudo mkdir -p  /www/share/sophiroth
    $ sudo yum install --downloadonly --downloaddir=/www/share/sophiroth docker-ce

更新源
============

如果没有安装createrepo, 要先安装

.. code-block:: bash

    sudo yum install createrepo -y

更新源

.. code-block:: bash

    sudo createrepo --update -p /www/share/sophiroth/


配置nginx
================

在nginx的server里添加如下配置

.. code-block:: bash

    location /sophiroth {
           alias /www/share/sophiroth ;
    }


然后通过web服务就可以访问了，这里我们部署的地址是：  http://dc.alv.pub/sophiroth


客户端访问
==================

客户端配置yum仓库

.. code-block:: bash

    [alvin@k8s1 ~]$ sudo vim /etc/yum.repos.d/sophiroth.repo
    [sophiroth]
    name=sophiroth
    gpgcheck=0
    enable=1
    baseurl=http://dc.alv.pub/sophiroth
    [alvin@k8s1 ~]$ yum repolist|grep sophiroth
    sophiroth               sophiroth                                              1


然后客户端就可以通过这个内网yum源安装docker-ce了。

.. code-block:: bash

    sudo yum install docker-ce



后续更新新的包
=================
后续添加新的包的时候，需要做以下几步。

#. 添加yum源

    后续添加新的包的时候，首先添加能下载那个包的yum源

#. 下载rpm包
    下载rpm包，通过以下命令，$packageName替换为实际要下载的包名。

    .. code-block:: bash

        $ sudo yum install --downloadonly --downloaddir=/www/share/sophiroth  $packageName

#. 更新仓库包信息

    .. code-block:: bash

        $ sudo createrepo --update -p /www/share/sophiroth/

#. 客户端清理缓存重新加载包信息
    客户端如果以前加载过，会有以前的仓库包信息的缓存，需要清理缓存后从新加载才能找到仓库里新增的包。

    .. code-block:: bash

        $ sudo yum clean all
        $ sudo yum repolist