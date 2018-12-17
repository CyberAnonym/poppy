安装kvm
#########





安装qemu-kvm和libvirt
=============================

::

    yum install -y qemu-kvm libvirt   ###qemu-kvm用来创建虚拟机硬盘,libvirt用来管理虚拟机

安装virt-install
============================

::

    yum install -y virt-install    ###用来创建虚拟机


启动libvirtd,并将它设为开机启动
==========================================

启动后使用ifconfig查看,发现会多出来一块virbr0的网卡,ip默认为192.168.122.1/24,说明libvirtd启动成功,如果默认没有ifconfig命令,使用yum install -y net-tools安装

::

    systemctl start libvirtd && systemctl enable libvirtd

经过以上三步,KVM安装成功,下面开始使用KVM创建虚拟机.

下面我们开始使用KVM创建虚拟机(CentOS7)

使用qemu命令创建一个10G的硬盘(最小10,G,可以更多)
====================================================
硬盘的名称为: redis1.alv.pub.raw

::

    [root@internal ~]# qemu-img create -f raw /kvm/redis1.alv.pub.raw 20G
    Formatting '/kvm/redis1.alv.pub.raw', fmt=raw size=21474836480
    [root@internal ~]#
    [root@internal ~]# ll /kvm/
    total 16
    -rw-r--r-- 1 root root 21474836480 Dec 17 09:09 redis1.alv.pub.raw

创建虚拟机
===============


使用virt-install创建名称为redis1.alv.pub的虚拟机,在创建之前,先上传一个CentOS7的ISO镜像

::

    virt-install --virt-type kvm --name redis1.alv.pub --ram 1024 --cdrom=/nextcloud/data/alvin/files/isos/centos/CentOS-7.4-x86_64-Everything-1708.iso \
    --disk path=/kvm/redis1.alv.pub.raw --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole

.. note::

    上面我们没有指定vnc端口，实际上，我们也可以指定vpn端口，因为当有多台虚拟机需要连接的时候，我们确实也要使用不同的端口去管理。
    vnc的默认端口是5900，下面我们在listen参数的后，加上port=5903，就表示指定vnc的端口为5903，vnc客户端去连接的时候找5903这个端口就好了。

    ::

        virt-install --virt-type kvm --name redis3.alv.pub --ram 1024 --cdrom=/nextcloud/data/alvin/files/isos/centos/CentOS-7.4-x86_64-Everything-1708.iso \
        --disk path=/kvm/redis3.alv.pub.raw --network network=default --graphics vnc,listen=0.0.0.0,port=5903 --noautoconsole

使用桥接网络
=====================

先创建网桥
-------------

这里我的物理网卡接口名为enp6s0

::

    $ vim /etc/sysconfig/network-scripts/ifcfg-br0
    DEVICE="br0"
    ONBOOT="yes"
    TYPE="Bridge"
    BOOTPROTO=static
    IPADDR=192.168.3.3
    NETMASK=255.255.255.0
    GATEWAY=192.168.3.1
    DEFROUTE=yes
    $ vim /etc/sysconfig/network-scripts/ifcfg-enp6s0
    DEVICE="enp6s0"
    NM_CONTROLLED="no"
    ONBOOT="yes"
    TYPE=Ethernet
    BOOTPROTO=none
    BRIDGE="br0"
    NAME="enp6s0"
    $ systemctl restart network

使用桥接网络
----------------
配置参数 --network bridge=br0

    ::

        virt-install --virt-type kvm --name redis3.alv.pub --ram 1024 --cdrom=/nextcloud/data/alvin/files/isos/centos/CentOS-7.4-x86_64-Everything-1708.iso \
         --disk path=/kvm/redis3.alv.pub.raw --network bridge=br0 --graphics vnc,listen=0.0.0.0,port=5903 --noautoconsole

这时候使用TightVNC工具,连接主机IP ,设置安装操作系统的网卡名称为eth0,如图所示

virt-install其他配置参数
--------------------------------

::

    -memory 2048 指定内存2048
    -m 00:11:22:33:44:10  #指定mac地址
    --disk=/var/lib/libvirt/images/test1.alv.pub.qcow2   #指定磁盘文件，可使用这种方法，--disk path=/xxxx 也可以
    --graphics keymap=en-us #指定键盘类型
    --import  #最后加这个参数，表示是导入一个虚拟机，使用的磁盘是一个已经装好的虚拟机磁盘，而不是创建一个虚拟机
    --vcpus 4 #指定cpu个数为4个
