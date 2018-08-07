NetworkManager
#################
NetworkManager是用于取代network服务，比network更好用的网络管理工具。

查看设备的状态
=====================

nmcli device  可以确认你可以对哪些网卡配置，以及这些硬件设备的信息；

.. code-block:: bash

    [root@dc ~]# nmcli device status
    DEVICE  TYPE      STATE      CONNECTION
    ens33   ethernet  connected  ens33
    ens34   ethernet  connected  ens34
    ens38   ethernet  connected  ens38


查看指定设备的详细的设备信息
=======================================

nmcli connection 这里主要是操作管理配置文件的，启用/停用、创建/删除 哪些配置文件，以及查看这些配置文件对应硬件的信息

.. code-block:: bash

    [root@dc ~]# nmcli device show ens33
    GENERAL.DEVICE:                         ens33
    GENERAL.TYPE:                           ethernet
    GENERAL.HWADDR:                         00:0C:29:FE:38:33
    GENERAL.MTU:                            1500
    GENERAL.STATE:                          100 (connected)
    GENERAL.CONNECTION:                     ens33
    GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/99
    WIRED-PROPERTIES.CARRIER:               on
    IP4.ADDRESS[1]:                         192.168.11.54/24
    IP4.ADDRESS[2]:                         172.25.254.233/24
    IP4.GATEWAY:                            192.168.11.205
    IP4.DNS[1]:                             172.25.254.250
    IP4.DNS[2]:                             192.168.127.3
    IP4.DOMAIN[1]:                          ilt.example.com
    IP4.DOMAIN[2]:                          example.com
    IP6.ADDRESS[1]:                         fe80::20c:29ff:fefe:3833/64
    IP6.GATEWAY:                            --

显示各种状态
=================


- 显示所有网络连接：nmcli con show
- 显示活动网络连接：nmcli con show -active
- 显示指定网络连接的详情：nmcli con show eno16777728
- 显示网络设备连接状态：nmcli dev status
- 显示所有网络设备的详情：nmcli dev show
- 显示指定网络设备的详情：nmcli dev show eno16777728

查看connection
===================

.. code-block:: bash

    [root@dc ~]# nmcli connection show
    NAME   UUID                                  TYPE            DEVICE
    ens33  4df6c9b1-8af2-45cc-8f3a-a0f3be223b1d  802-3-ethernet  ens33
    ens34  5e2bcc3b-ea61-41b9-a7f8-c1588ee5595e  802-3-ethernet  ens34
    ens38  be9e2b6b-674b-771d-7251-f3b49b3d23e0  802-3-ethernet  ens38


修改网络连接单项参数
=========================

::

    nmcli con mod IF-NAME connection.autoconnect yes修改为自动连接
    nmcli con mod IF-NAME ipv4.method manual | dhcp修改IP地址是静态还是DHCP
    nmcli con mod IF-NAME ipv4.addresses “172.25.X.10/24 172.25.X.254”修改IP配置及网关
    nmcli con mod IF-NAME ipv4.gateway 10.1.0.1修改默认网关
    nmcli con mod IF-NAME +ipv4.addresses 10.10.10.10/16添加第二个IP地址
    nmcli con mod IF-NAME ipv4.dns 114.114.114.114添加dns1
    nmcli con mod IF-NAME +ipv4.dns  8.8.8.8添加dns2
    nmcli con mod IF-NAME -ipv4.dns  8.8.8.8删除dns

修改connection名
=========================
将connection System eth0的名字改为eth0

.. code-block:: bash

    nmcli connection modify 'System eth0' connection.id eth0


配置链路聚合
====================

.. code-block:: bash
    :linenos:

    ##建立新的聚合连
    nmcli connection add con-name team0 type team ifname team0 config '{"runner":{"name":"activebackup"}}'
    ##指定成员网卡 1
    nmcli connection add con-name team0-p1 type team-slave ifname ens34 master team0
    ##指定成员网卡 2
    nmcli connection add con-name team0-p2 type team-slave ifname ens35 master team0
    ##为聚合连接配置 IP 地址
    nmcli  connection modify team0 ipv4.method manual ipv4.address "192.168.38.80/24"
    ##激活聚合连
    nmcli connection up team0
    ## 激活成员连接1（备用)
    nmcli connection up team0-p1
    ## 激活成员连接 2（备用)
    nmcli connection up team0-p2
    teamdctl team0 state


设置ipv6地址
====================
下面我们设置一个ipv6地址2003:ac18::305/64。

.. code-block:: bash

    nmcli connection modify "Wired connection 1" ipv6.method  manual ipv6.address 2003:ac18::305/64 ifname ens36
    nmcli connection up "Wired connection 1"

如果没有开启ipv6的支持，可以执行以下操作

.. code-block:: bash

    grep NETWORKING_IPV6=yes /etc/sysconfig/network || echo NETWORKING_IPV6=yes >> /etc/sysconfig/network
    grep net.ipv6.conf.all.disable_ipv6=0 /etc/sysctl.conf || echo net.ipv6.conf.all.disable_ipv6=0 >> /etc/sysctl.conf



nmcli命令修改所对应的文件条目
==============================

::

    nmcli con mod           ifcfg-* 文件
    ipv4.method manual       BOOTPROTO=none
    ipv4.method auto         BOOTPROTO=dhcp
    connection.id eth0        NAME=eth0
    (ipv4.addresses          IPADDR0=192.0.2.1
    “192.0.2.1/24           PREFIX0=24
    192.0.2.254”)           GATEWAY0=192.0.2.254
    ipv4.dns 8.8.8.8        DNS0=8.8.8.8
    pv4.dns-search example.com   DOMAIN=example.com
    pv4.ignore-auto-dns true    PEERDNS=no
    connection.autoconnect yes   ONBOOT=yes
    connection.interface-name eth0 DEVICE=eth0
    802-3-ethernet.mac-address... HWADDR=...


停止网络连接（可被自动激活）
==============================
::

    nmcli con down eno33554960

禁用网卡，防止被自动激活
=============================

::

    nmcli dev dis eth0

删除网络连接的配置文件
===========================
::

    nmcli con del eno33554960

重新加载配置网络配置文件
=========================
::

    nmcli con reload

使用图形化的方式配置IP
==============================

.. code-block:: bash

    nm-connection-editor