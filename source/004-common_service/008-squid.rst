squid
#######

这里我们在centos7 下使用docker提供支持https的squid服务



安装docker
===============

::

    wget -P /etc/yum.repos.d/ https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum install docker-ce



启动docker
==============

::


    systemctl start docker
    systemctl enable docker



配置启动squid
================

::

    $ vim /etc/squid3/squid.conf
    acl all src 0.0.0.0/0
    acl SSL_ports port 443
    acl Safe_ports port 80 # http
    acl Safe_ports port 443 # https
    acl CONNECT method CONNECT
    http_access allow all
    http_port 3128
    visible_hostname proxy




启动docker
======================


docker run -d --name squid3 --restart=always  -m 1G -p 10080:3128 -v /etc/squid3/squid.conf:/etc/squid3/squid.conf -v /var/log/squid3:/var/log/squid3 -v /var/spool/squid3:/var/spool/squid3 sameersbn/squid:3.3.8-14
