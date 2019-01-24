OpenVAS
##################

本文参考： http://blog.51cto.com/linhong/2134910


OpenVAS是开放式漏洞评估系统，也可以说它是一个包含着相关工具的网络扫描器。其核心部件是一个服务器，包括一套网络漏洞测试程序，可以检测远程系统和应用程序中的安全问题。

用户需要一种自动测试的方法，并确保正在运行一种最恰当的最新测试。OpenVAS包括一个中央服务器和一个图形化的前端。这个服务器准许用户运行 几种不同的网络漏洞测试（以Nessus攻击脚本语言编写），而且OpenVAS可以经常对其进行更新。OpenVAS所有的代码都符合GPL规范。

建立架构：

OpenVAS是一个客户端/服务器架构，它由几个组件组成。在服务器上（仅限于Linux），用户需要四个程序包：

OpenVAS-Server: 实现基本的扫描功能

OpenVAS-Plugins: 一套网络漏洞测试程序

OpenVAS-LibNASL 和OpenVAS-Libraries: 实现服务器功能所需要的组件

而在客户端上（Windows或Linux均可），用户仅需要OpenVAS客户端。

Server Scanner:负责调用各种漏洞检测插件，完成实际的扫描操作

Manager:负责分配扫描任务，并根据扫描结果生产评估报告

Libraries:负责管理配置信息，用户授权等相关工作


环境准备
===================

安装系统
-------------

这里我们先安装一个kali linux系统，然后在kali系统里安装OpenVAS

kali镜像
-------------

Kali2018.2安装镜像下载地址：https://www.kali.org/downloads/


更新源
-------------

official source

::

    # deb cdrom:[Debian GNU/Linux 2018.2 _Kali-rolling_ - Official Snapshot amd64 LIVE/INSTALL Binary 20180412-10:55]/ kali-last-snapshot contrib main non-free

    #deb cdrom:[Debian GNU/Linux 2018.2 _Kali-rolling_ - Official Snapshot amd64 LIVE/INSTALL Binary 20180412-10:55]/ kali-last-snapshot contrib main non-free

    deb http://http.kali.org/kali kali-rolling main non-free contrib

    # deb-src http://http.kali.org/kali kali-rolling main non-free contrib

    # This system was installed using small removable media

    # (e.g. netinst, live or single CD). The matching "deb cdrom"

    # entries were disabled at the end of the installation process.

    # For information about how to configure apt package sources,

    # see the sources.list(5) manual.

OpenVAS安装与配置
=========================

安装OpenVAS
------------------

Kali linux2018.3默认未安装openvas，需要手动安装：

安装步骤：

#. 更新系统

    ::

        #apt-get clean
        #apt-get update && apt-get upgrade && apt-get dist-upgrade

#. OpenVAS安装包及依赖环境下载

    ::

        #apt-get install openvas*

#. 初始化openvas

    ::

        openvas-setup

    OpenVAS初始化安装


    又是一个漫长的等待。

    初始化完成后，会自动生成默认账号密码，默认账号是：admin

#. 安装完整性检测

    ::

        openvas-check-setup


OpenVAS配置
------------------


#. 设置外部访问

    安装完成之后，OpenVAS默认设置的监听地址为127.0.0.1，为了使用方便，需要手动配置外部访问，Openvas9.0修改以下四个配置文件中的监听ip，由127.0.0.1改为0.0.0.0（表示任意IP），保存之后，重新加载systemctl，重启openvas即可。


#. 增加host 头主机地址（IP或域名）

    在--mlisten=0.0.0.0 后增加“--allow-header-host=外部访问的地址IP或域名”，本次测试本机地址为：192.168.200.221，即外部访问的IP为192.168.200.221

    重新加载systemctl：

    ::

        #openvas-stop

        #systemctl daemon-reload

    重新启动openvas：

    ::

        #openvas-stop

        #openvas-start

    安装完整性检测

    ::

        # openvas-check-setup

    修改密码

    Openvas自动生成的默认密码太长，不容易记，我们可以修改成符合我们记忆习惯的密码。

    方法一：通过命令行修改

    ::

        # openvasmd --user=admin --new-password=admin

    方法二：GSA修改

    登录GSA后，打开administration-》Users

#. 升级插件和漏洞库


    方法一：

    ::

        # openvas-feed-update //初始化安装，可以不用更新

    方法二：

    ::

        # greenbone-nvt-sync

        # greenbone-scapdata-sync

        # greenbone-certdata-sync

    建议使用方法一进行升级。



错误处理
===============


systemctl启动服务

::

    # systemctl start greenbone-security-assistant //启动greenbone-security-assistant

    # systemctl start openvas-scanner // 启动openvas-scanner

    # systemctl start openvas-manager //启动openvas-manager