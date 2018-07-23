yum
=========


搭建yum源服务器


.. contents::

准备篇：
```````````````

一、安装http服务器
----------------------

这里使用Nginx服务器提供http服务

关于Nginx服务器搭建，参考：CentOS安装配置LNMP服务器（Nginx+PHP+MySQL）

http://www.osyunwei.com/archives/5910.html

二、系统约定
----------------------

Nginx站点根目录:/www/share

服务器执行脚本文件存放目录:/home/crontab

三、开始Nginx目录浏览功能

#编辑nginx配置文件，添加以下内容：

autoindex on; #开启nginx目录浏览功能

autoindex_exact_size off; #文件大小从KB开始显示

autoindex_localtime on; #显示文件修改时间为服务器本地时间



service nginx reload #重新加载配置

安装篇：
````````````

安装环境
--------------

系统版本： centos7.4
Hostname: dc.alv.pub


一、创建镜像文件存放目录
---------------------------


mkdir -p /www/share/centos #CentOS官方标准源

mkdir -p /www/share/repoforge #第三方rpmforge源

mkdir -p /www/share/epel #第三方epel源


说明：这里创建三个文件夹，分别存放CentOS官方标准源、第三方的rpmforge源和epel源
\
二、确定以上三个yum源上游源的同步镜像地址
------------------------------------


1、CentOS官方标准源：rsync://rsync.mirrors.ustc.edu.cn/centos/

2、rpmforge源：rsync://rsync.mirrors.ispros.com.bd/repoforge/

3、epel源：rsync://rsync.mirrors.ustc.edu.cn/epel/

备注：上游yum源必须要支持rsync协议，否则不能使用rsync进行同步。

参考：

CentOS官方标准源：

rsync://mirrors.kernel.org/centos

rpmforge源：

http://apt.sw.be/

rsync://ftp-stud.fht-esslingen.de/dag

epel源：

http://mirrors.fedoraproject.org/publiclist/EPEL/

rsync://mirrors.kernel.org/fedora-epel


三、创建以上三个yum源同步脚本，并且设定脚本自动执行
----------------------------------------------------

mkdir -p /home/crontab #创建目录

vi /home/crontab/yum_rsync.sh #添加以下代码

#!/bin/sh

/usr/bin/rsync -avrt rsync://rsync.mirrors.ustc.edu.cn/centos/ --exclude-from=/www/share/exclude_centos.list /www/share/centos/

/usr/bin/rsync -avrt rsync://ftp-stud.fht-esslingen.de/dag/ --exclude-from=/www/share/exclude_repoforge.list /www/share/repoforge/

/usr/bin/rsync -avrt rsync://rsync.mirrors.ustc.edu.cn/epel/ --exclude-from=/www/share/exclude_epel.list /www/share/epel/

:wq! #保存退出

chmod +x /home/crontab/yum_rsync.sh #添加脚本执行权限

查看目录列表

rsync --list-only  rsync://rsync.mirrors.ustc.edu.cn/centos/


备注：运行此脚本前，先要创建好同步目录及不需要同步的目录列表文件

cd /www/share/  #进入目录

touch exclude_centos.list   #创建文件

touch exclude_repoforge.list   #创建文件

touch exclude_epel.list   #创建文件

把不需要同步的目录写到上面对应的文件中，每行一个目录

例如：

.. code-block:: bash

    echo '
    4/
    4AS/
    4ES/
    4WS/
    '>exclude_epel.list

.. code-block:: bash

    echo'
    /centos/7.5.1804/isos/
    /centos/7/isos/
    /centos/6/isos/
    /centos/6.9/isos/
    '>exclude_centos.list

四、添加脚本定时执行任务
----------------------------------------------------

vi /etc/crontab  #在最后一行添加以下代码

0 1 * * * root /home/crontab/yum_rsync.sh #设置每天凌晨1点整开始执行脚本

:wq! #保存退出

service crond restart #重启

测试篇：
```````````````````

一、安装rsync同步软件
----------------------------------------------------

yum install rsync xinetd #安装

vi /etc/xinetd.d/rsync #编辑配置文件，设置开机启动rsync

disable = no #修改为

/etc/init.d/xinetd start #启动（CentOS中是以xinetd 来管理Rsync服务的）

:wq! #保存退出

二、执行同步脚本
----------------------------------------------------


sh /home/crontab/yum_rsync.sh

注意：等待脚本执行完毕，首次同步，耗费的时间比较长！

三、根据不同版本创建三个yum源的repo配置文件
----------------------------------------------------

cd /etc/yum.repos.d/ #进入目录

mv /etc/yum.repos.d/CentOS-Base.repo CentOS-Base.repo-bak

1、CentOS官方标准源：

CentOS 5.x系列：

vi /etc/yum.repos.d/CentOS-Base.repo #添加以下代码

# CentOS-Base.repo

#

# The mirror system uses the connecting IP address of the client and the

# update status of each mirror to pick mirrors that are updated to and

# geographically close to the client. You should use this for CentOS updates

# unless you are manually picking other mirrors.

#

# If the mirrorlist= does not work for you, as a fall back you can try the

# remarked out baseurl= line instead.

#

#

[base]

name=CentOS-$releasever - Base - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/os/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

#released updates

[updates]

name=CentOS-$releasever - Updates - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/updates/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

#packages used/produced in the build but not released

[addons]

name=CentOS-$releasever - Addons - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/addons/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=addons

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

#additional packages that may be useful

[extras]

name=CentOS-$releasever - Extras - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/extras/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

#additional packages that extend functionality of existing packages

[centosplus]

name=CentOS-$releasever - Plus - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/centosplus/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus

gpgcheck=1

enabled=0

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

#contrib - packages by Centos Users

[contrib]

name=CentOS-$releasever - Contrib - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/contrib/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib

gpgcheck=1

enabled=0

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-5

:wq! #保存退出

#########################

CentOS 6.x系列：

vi /etc/yum.repos.d/CentOS-Base.repo #添加以下代码

# CentOS-Base.repo

#

# The mirror system uses the connecting IP address of the client and the

# update status of each mirror to pick mirrors that are updated to and

# geographically close to the client. You should use this for CentOS updates

# unless you are manually picking other mirrors.

#

# If the mirrorlist= does not work for you, as a fall back you can try the

# remarked out baseurl= line instead.

#

#

[base]

name=CentOS-$releasever - Base - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/os/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-6

#released updates

[updates]

name=CentOS-$releasever - Updates - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/updates/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful

[extras]

name=CentOS-$releasever - Extras - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/extras/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras

gpgcheck=1

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages

[centosplus]

name=CentOS-$releasever - Plus - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/centosplus/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus

gpgcheck=1

enabled=0

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users

[contrib]

name=CentOS-$releasever - Contrib - huanqiu.com

baseurl=http://dc.alv.pub/centos/$releasever/contrib/$basearch/

#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib

gpgcheck=1

enabled=0

gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-6

:wq! #保存退出

#########################

CentOS 7.x系列：

.. code-block:: bash

    vi /etc/yum.repos.d/CentOS-Base.repo #添加以下代码
    # CentOS-Base.repo
    #
    # The mirror system uses the connecting IP address of the client and the
    # update status of each mirror to pick mirrors that are updated to and
    # geographically close to the client. You should use this for CentOS updates
    # unless you are manually picking other mirrors.
    #
    # If the mirrorlist= does not work for you, as a fall back you can try the
    # remarked out baseurl= line instead.
    #

    [base]
    name=CentOS-$releasever - Base
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
    baseurl=http://dc.alv.pub/centos/$releasever/os/$basearch/
    gpgcheck=1
    gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-7

    #released updates
    [updates]
    name=CentOS-$releasever - Updates
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
    baseurl=http://dc.alv.pub/centos/$releasever/updates/$basearch/
    gpgcheck=1
    gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-7

    #additional packages that may be useful
    [extras]
    name=CentOS-$releasever - Extras
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
    baseurl=http://dc.alv.pub/centos/$releasever/extras/$basearch/
    gpgcheck=1
    gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-7

    #additional packages that extend functionality of existing packages
    [centosplus]
    name=CentOS-$releasever - Plus
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
    baseurl=http://dc.alv.pub/centos/$releasever/centosplus/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=http://dc.alv.pub/centos/RPM-GPG-KEY-CentOS-7

#########################

或者参考：https://lug.ustc.edu.cn/wiki/mirrors/help/centos

把里面的http://mirrors.ustc.edu.cn/替换为http://dc.alv.pub/, 因为我们这台服务器的主机名和域名是dc.alv.pub

2、rpmforge源：

CentOS 5.x系列：

vi /etc/yum.repos.d/rpmforge.repo #添加以下代码

[rpmforge]

name = RHEL $releasever - RPMforge.net - dag

baseurl = http://dc.alv.pub/repoforge/redhat/el5/en/$basearch/rpmforge

enabled = 1

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

[rpmforge-extras]

name = RHEL $releasever - RPMforge.net - extras

baseurl = http://dc.alv.pub/repoforge/redhat/el5/en/$basearch/extras

enabled = 0

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

[rpmforge-testing]

name = RHEL $releasever - RPMforge.net - testing

baseurl = http://dc.alv.pub/repoforge/redhat/el5/en/$basearch/testing

enabled = 0

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

:wq! #保存退出

#########################

系统运维  www.osyunwei.com  温馨提醒：qihang01原创内容©版权所有,转载请注明出处及原文链

CentOS 6.x系列：

vi /etc/yum.repos.d/rpmforge.repo #添加以下代码

[rpmforge]

name = RHEL $releasever - RPMforge.net - dag

baseurl = http://dc.alv.pub/repoforge/redhat/el6/en/$basearch/rpmforge

enabled = 1

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

[rpmforge-extras]

name = RHEL $releasever - RPMforge.net - extras

baseurl = http://dc.alv.pub/repoforge/redhat/el6/en/$basearch/extras

enabled = 0

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

[rpmforge-testing]

name = RHEL $releasever - RPMforge.net - testing

baseurl = http://dc.alv.pub/repoforge/redhat/el6/en/$basearch/testing

enabled = 0

protect = 0

gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge

gpgcheck = 1

:wq! #保存退出

#########################

CentOS 7.x系列：


.. code-block:: bash

    vi /etc/yum.repos.d/rpmforge.repo #添加以下代码

    [rpmforge]
    name = RHEL $releasever - RPMforge.net - dag
    baseurl = http://dc.alv.pub/repoforge/redhat/el7/en/$basearch/rpmforge
    enabled = 1
    protect = 0
    gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge
    gpgcheck = 1

    [rpmforge-extras]
    name = RHEL $releasever - RPMforge.net - extras
    baseurl = http://dc.alv.pub/repoforge/redhat/el7/en/$basearch/extras
    enabled = 0
    protect = 0
    gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge
    gpgcheck = 1

    [rpmforge-testing]
    name = RHEL $releasever - RPMforge.net - testing
    baseurl = http://dc.alv.pub/repoforge/redhat/el7/en/$basearch/testing
    enabled = 0
    protect = 0
    gpgkey=http://dc.alv.pub/repoforge/RPM-GPG-KEY-rpmforge
    gpgcheck = 1


#########################

3、epel源：

CentOS 5.x系列：

vi /etc/yum.repos.d/epel.repo #添加以下代码

[epel]

name=Extra Packages for Enterprise Linux 5 - $basearch

baseurl=http://dc.alv.pub/epel/5/$basearch

failovermethod=priority

enabled=1

gpgcheck=1

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-5

[epel-debuginfo]

name=Extra Packages for Enterprise Linux 5 - $basearch - Debug

baseurl=http://dc.alv.pub/epel/5/$basearch/debug

failovermethod=priority

enabled=0

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-5

gpgcheck=1

[epel-source]

name=Extra Packages for Enterprise Linux 5 - $basearch - Source

baseurl=http://dc.alv.pub/epel/5/SRPMS

failovermethod=priority

enabled=0

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-5

gpgcheck=1

:wq! #保存退出

#########################

CentOS 6.x系列：

vi /etc/yum.repos.d/epel.repo #添加以下代码

[epel]

name=Extra Packages for Enterprise Linux 6 - $basearch

baseurl=http://dc.alv.pub/epel/6/$basearch

failovermethod=priority

enabled=1

gpgcheck=1

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-6

[epel-debuginfo]

name=Extra Packages for Enterprise Linux 6 - $basearch - Debug

baseurl=http://dc.alv.pub/epel/6/$basearch/debug

failovermethod=priority

enabled=0

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-6

gpgcheck=1

[epel-source]

name=Extra Packages for Enterprise Linux 6 - $basearch - Source

baseurl=http://dc.alv.pub/epel/6/SRPMS

failovermethod=priority

enabled=0

gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-6

gpgcheck=1

:wq! #保存退出

#########################

CentOS 7.x系列：

.. code-block:: bash

    vi /etc/yum.repos.d/epel.repo #添加以下代码
    [epel]
    name=Extra Packages for Enterprise Linux 7 - $basearch
    baseurl=http://dc.alv.pub/epel/beta/7/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=1
    gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-7

    [epel-debuginfo]
    name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
    baseurl=http://dc.alv.pub/epel/beta/7/$basearch/debug
    failovermethod=priority
    enabled=0
    gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-7
    gpgcheck=1

    [epel-source]
    name=Extra Packages for Enterprise Linux 7 - $basearch - Source
    baseurl=http://dc.alv.pub/epel/beta/7/SRPMS
    failovermethod=priority
    enabled=0
    gpgkey =http://dc.alv.pub/epel/RPM-GPG-KEY-EPEL-7
    gpgcheck=1
    :wq! #保存退出

#########################

四、测试yum源是否配置正确
----------------------------------------------------

我们当前系统是centos7.4，所以按照上面描述的7的yum repo配置去编写repo文件，然后开始以下操作。

yum clean all #清除当前yum缓存

yum makecache #缓存yum源中的软件包信息

yum repolist #列出yum源中可用的软件包

2、使用yum命令安装软件

yum install php #测试CentOS官方标准源

yum install htop #测试rpmforge源

yum install nginx #测试epel源

至此，搭建CentOS在线yum源镜像服务器完成！