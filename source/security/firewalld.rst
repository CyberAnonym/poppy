firewalld
##################

firewalld是centos7下提供的防火墙服务

firewalld 概述
=======================
firewalld是redhat enterprise linux 7 中用于管理主机级别防火墙的默认方法，firewalld通过firewalld.service systemd 服务来启动，可使用低级别的iptables、ip6tables和ebtables命令来管理Linux内核netfilter子系统。

firewalld将所有传入流量划分成区域，每个区域都具有自己的一套规则，为检查哪个区域用于传入连接，firewalld使用以下逻辑，第一个匹配的规则生出：

#. 如果闯入包的原地址与区域的过滤器设置匹配，该包将通过该区域进行路由，
#. 如果包的闯入借口与区域的过滤器设置匹配，则将使用该区域，
#. 否则将使用默认区域。默认区域不是单独的区域，而是指向系统上定义的某个其他区域。

除非被管理员NetworkManager配置缩覆盖，否则，任何新网络接口的默认区域都将设置为public区域

firewalld随附了一些预定义区域，每个都有自己的指定用途：
firewalld区域默认配置

===================    ==========
区域名称                默认配置
===================    ==========
trusted                 允许所有传入流量
home                    除非与传出流量相关，或与ssh、mdns、ipp-client、samba-client或dhcpv6-client预定义服务匹配，否则拒绝传入流量
internal                除非与传出流量相关，或与ssh、mdns、ipp-client、samba-client或dhcpv6-client预定义服务匹配，否则拒绝传入流量（一开始与home区域相同）
work                    除非与传出流量相关，或与ssh、ipp-client或dhcpv6-client预定义服务匹配，否则拒绝传入流量
public                  除非与传出流量相关，或与ssh或dhcpv6-client预定义服务匹配，否则拒绝传入流量。新添加的网络接口的默认区域
external                除非与传出流量相关，或与ssh预定义服务匹配，否则拒绝传入流量。通过此区域转发的ipv4传出流量将进行伪装，使其看起来像是来自传出网络接口的ipv4地址。
dmz                     除非与传出流量相关，或与ssh预定义服务匹配，否则拒绝传入流量。
block                   除非与传出流量相关，否则拒绝传入流量。
deop                    除非与传出流量相关，否则丢弃所有传入流量。（甚至不产生包含 ICMP 错误的响应
===================    ==========




使用 firewall-cmd 配置防火墙设置
========================================

firewall-cmd 作为主 firewalld 软件包的一部分安装。

firewall-cmd 常用命令及说明

--get-default-zone: 查询当前默认区域

--set-default-zone=ZONE: 设置默认区域。会同时更改运行时配置和永久配置。

--get-zones: 列出所有可用区域。

--get-active-zones: 列出当前正在使用的所有区域（具有关联的接口或源）及其接口和源信息。

--add-source=CIDR [--zone=ZONE]: 将来自 IP 地址或网络/子网掩码 CIDR 的所有流量路由到指定区域。如果未提供 --zone= 选项，则将使用默认区域

--remove-source=CIDR [--zone=ZONE]: 从指定区域中删除用于路由来自 IP 地址或网络/子网掩码 CIDR 的所有流量的规则。

--add-interface=INTERFACE [--zone=ZONE]: 将来自 INTERFACE 的所有流量路由到指定区域。

--change-interface=INTERFACE [--zone=ZONE]: 将接口与 ZONE 而非其当前区域关联。

--list-all [--zone=ZONE]: 列出 ZONE 的所有已配置接口、源、服务和端口。

--list-all-zones: 检索所有区域的所有信息（接口、源、端口、服务等）

--add-service=SERVICE [--zone=ZONE]: 允许到 SERVICE 的流量。

--add-port=PORT/PROTOCOL  [--zone=ZONE]: 允许到 PORT/PROTOCOL 端口的流量。

--remove-service=SERVICE [--zone=ZONE]: 从区域的允许列表中删除 SERVICE。

--remove-port=PORT/PROTOCOL [--zone=ZONE]: 从区域的允许列表中删除 PORT/PROTOCOL 端口

--reload: 丢弃运行时配置并应用持久配置。


启动和关闭firewalld
=========================

.. code-block:: bash

    systemctl firewalld start
    systemctl firewalld stop
    systemctl firewalld restart

查看当前防火墙规则列表
=========================

- 查看默认区域的防火墙配置

.. code-block:: bash

    firewall-cmd --list-all

- 查看指定区域的防火墙配置

.. code-block:: bash

    firewall-cmd --list-all --zone=block

将默认区域设置为信任
============================
调整防火墙信任区域，简化对后续各种服务的防护

.. code-block:: bash

    firewall-cmd --set-default-zone=trusted


对所有网络开放http服务
=======================================================
我们需要永久生效该规则，所以加上--permanent参数。

.. code-block:: bash

    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload
    firewall-cmd --list-all

对所有网络开放tcp80端口
===============================

.. code-block:: bash

    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --reload
    firewall-cmd --list-all


删除已开放的httpd服务
===========================

.. code-block:: bash

    firewall-cmd --permanent --remove-service=http
    firewall-cmd --reload
    firewall-cmd --list-all

在public区打开http服务
=================================

.. code-block:: bash

    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --reload#firewall-cmd --list-all


指定网络中将本地端口5423转发到80
=================================================
将本地端口5423转发到80

.. code-block:: bash

    firewall-cmd --permanent --zone=trusted --add-forward-port=port=5423:proto=toport=80

拒绝指定网络的所有请求
=================================
拒绝192.168.2.0/24的请求

.. code-block:: bash

    firewall-cmd --permanent --add-source=192.168.2.0/24 --zone=block


设置默认区域，指定网络分配到指定区域
===============================================

除非另有指定，几乎所有命令都作用于运行时配置，除非指定 --permanent 选项。许多命令都采用 --zone=ZONE 选项指定所影响的区域。

示例：

.. code-block:: bash

    # firewall-cmd --set-default-zone=dmz

    # firewall-cmd --permanent --zone=internal --add-source=192.168.0.0/24

    # firewall-cmd --permanent --zone=internal --add-service=mysql

    # firewall-cmd --reload

默认区域设置为 dmz，来自192.168.0.0/24 网络的所有流量都被分配给 internal 区域，而 internal 区域打开了用于 mysql 的网络端口。
