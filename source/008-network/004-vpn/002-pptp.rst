pptp
#####

Install pptpd service
================================

.. code-block:: bash

    yum install ppp iptables pptpd -y

configure pptpd
====================

- configure /etc/pptpd.conf

.. code-block:: bash

    vim /etc/pptpd.conf
    localip 192.168.0.1
    remoteip 192.168.0.234-238,192.168.0.245

configure dns
========================
.. code-block:: bash

    vim /etc/ppp/options.pptpd
    ms-dns 8.8.8.8
    ms-dns 8.8.4.4

configure user and password
=====================================

.. code-block:: bash

    vim /etc/ppp/chap-secrets
    #Username  Server  Secret  Hosts
    "user1" "*" "password1" "*"
    "user2" "*" "password2" "*"

configure /etc/sysctl.conf
==================================

.. code-block:: bash

    vim /etc/sysctl.conf
    net.ipv4.ip_forward=1

    sysctl -p


startup pptpd service
===========================
.. code-block:: bash

    systemctl start pptpd
    systemctl enable pptpd


打开防火墙
==================

.. code-block:: bash

    firewall-cmd --add-port=1723/tcp --permanent
    firewall-cmd --reload

additional fuction
============================

如果你需要连接这台服务器的vpn客户端可以通过这台服务器来访问外网，那么你需要做如下设置

.. code-block:: bash

    iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source $公网IP

在阿里云的服务器上，公网IP是直接就在服务器里的一张网卡上了的，所以直接用上面的方法是可以的，但是如果环境不在阿里云，比如在AWS上，公网IP是没有直接出现在服务器的网卡上的，所以在AWS上，后面的那个IP不能写公网IP，而要写内网IP，写公网IP就不行，在aws上我写的是iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source 172.31.24.107 ，而后面这个IP，就是我服务器上的内网IP，也是除了127.0.0.1外唯一的IP。

使用的端口是tcp 1723, 如果有使用防火墙，注意防火墙的设置。


firewalld设置
=====================

如果使用了firewalld防火墙，可以参考进行如下设置


启动或重启防火墙：

::

    systemctl start firewalld.service
    firewall-cmd --reload



允许防火墙伪装IP：

::

    firewall-cmd --add-masquerade

开启1723端口：

::

    firewall-cmd --permanent --zone=public --add-port=1723/tcp

允许gre协议：

::

    firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p gre -j ACCEPT
    firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p gre -j ACCEPT

设置规则允许数据包由eth0和ppp+接口中进出

::

    firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i ppp+ -o eth0 -j ACCEPT

    firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i eth0 -o ppp+ -j ACCEPT

设置转发规则，从源地址发出的所有包都进行伪装，改变地址，由eth0发出：

::

    firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 192.168.0.0/24

重启服务器：

::

    firewall-cmd --reload
    systemctl restart pptpd


pptp客户端
===============


pptp ubuntu 客户端
------------------------------

安装软件

::

    sudo apt-get install pptp-linux

连接服务

::

    pptpsetup -create vpn -server 47.75.0.56 -username alvinguest -password bemyguest -encrypt -start
    route add -net 0.0.0.0 dev ppp0

以后的启动可以使用下面的命令：

::

    pppd call vpn



其他：

::

    pon vpntovps #连接
    poff #断开VPN


centos 客户端
----------------------

安装软件

::

    yum install pptp-setup


连接服务器

::

    pptpsetup -create vpn -server diana.alv.pub -username alvinguest -password bemyguest -encrypt -start

以后的启动可以使用：

::

    pppd call vpn
    route add -net 0.0.0.0 dev ppp0


其他：

::

    pon vpntovps #连接
    poff #断开VPN



