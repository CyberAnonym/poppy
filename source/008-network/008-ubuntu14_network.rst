ubuntu14 网络配置
########################



修改网络配置文件
===========================

::

    $ vim network/interfaces
    auto lo
    iface lo inet loopback

    # The primary network interface
    auto eth0
    iface eth0 inet static
    address 192.168.1.31
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameserver 192.168.1.5

重启网卡
=============

这里我们执行的命令是重启所有的网卡，实际上我们可以根据网卡名单独重启指定网卡的将-a换成网卡名就好了。

::

    ifdown -a && ifup -a