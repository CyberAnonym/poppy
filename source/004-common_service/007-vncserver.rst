vncserver
################

前期准备
===========

关闭防火墙，centos的防火墙是firewalld，关闭防火墙的命令

::

    systemctl stop firewalld.service

关闭selinux

::

    setenforce 0

centos 服务器版需安装 GNOME Desktop

::

    yum groupinstall "GNOME Desktop"
　　


安装tigervncserver
===========================

::

    yum install tigervnc-server tigervnc-server-module

拷贝配置文件
==================

::

    cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

进入到配置文件目录
=====================

::

    cd /etc/systemd/system

修改配置文件
================

::

    $ vim vncserver@:1.service
    [Unit]
    Description=Remote desktop service (VNC)
    After=syslog.target network.target

    [Service]
    Type=forking
    User=root
    ExecStart=/usr/bin/vncserver :1 -geometry 1280x1024 -depth 16 -securitytypes=none -fp /usr/share/X11/fonts/misc
    ExecStop=/usr/bin/vncserver -kill :1

    [Install]
    WantedBy=multi-user.target

启用配置文件
==================

::

    systemctl enable vncserver@:1.service

设置登陆密码
===============

::

    vncpasswd

启动vncserver
======================

::

    systemctl start vncserver@:1.service　　

启动状态查看
================

::

    systemctl status vncserver@:1.service

查看端口状态
===================

::

    netstat -lnt | grep 590*

查看报错信息
===============

::

    grep vnc /var/log/messages