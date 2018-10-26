配置本地yum源
#################

这篇我们讲个最简单的本地yum源。

添加光盘的步骤我们略过，本环境系统下已存在ISO镜像

本实验在centos7下进行。


创建用于挂在光盘的目录
```````````````````````````
::

    mkdir /mnt/iso

挂在光盘到本地目录
`````````````````````
::

    mount /dev/cdrom /mnt/iso

创建yum仓库
`````````````````
::

    echo "
    [base]
    name=localiso
    baseurl=file:///mnt/iso
    gpgcheck=0
    enable=1" > /etc/yum.repos.d/local.repo

清空yum缓存
```````````````

::

    yum clean all

查看yum源列表
``````````````````
::

    yum repolist

.. image:: ../../../images/yum_local_iso.jpg