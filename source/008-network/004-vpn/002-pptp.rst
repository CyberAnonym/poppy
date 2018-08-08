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
