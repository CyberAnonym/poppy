meta服务器
###################

meta服务器不是一个启动使用的服务，是一块盘，一块已经装好了系统，做了一些初始化操作的盘。

meta服务器用于我们将meta的那块盘拷贝，然后通过拷贝出的盘指定硬件配置、导入为一台新的服务器。


创建meta服务器
===================


创建系统盘和虚拟机

.. code-block:: bash

    qemu-img create -f raw /kvm/meta.alv.pub.raw 20G
    virt-install --virt-type kvm --name meta.alv.pub -m 00:00:00:00:00:09 --ram 4096 --vcpus 2 --cdrom=/nextcloud/data/alvin/files/isos/centos/CentOS-7.4-x86_64-Everything-1708.iso     --disk path=/kvm/meta.alv.pub.raw --network bridge=br0 --graphics vnc,listen=0.0.0.0,port=5909 --noautoconsole



然后安装系统，可以通过5909端口的vnc进入图形化去安装，或是在系统上执行virt-viewer meta.alv.pub打开图形化去安装。



用meta去创建一台虚拟机
===========================

比如这里我们要创建一台名为ipa.alv.pub 的虚拟机

.. code-block:: bash

    cp /kvm/meta.alv.pub.raw  /kvm/ipa.alv.pub.raw -p
    virt-install --virt-type kvm --name ipa.alv.pub --ram 4096 -m 00:00:00:00:00:02 --vcpus 4  \
> --disk=/kvm/ipa.alv.pub.raw --network bridge=br0 --graphics vnc,listen=0.0.0.0,port=5902,keymap=en-us --noautoconsole --import


virt-install --virt-type kvm --name zabbix.alv.pub --ram 4096 -m 00:00:00:00:00:04 --vcpus 8  \
> --disk=/kvm/zabbix.alv.pub.raw --graphics vnc,listen=0.0.0.0,port=5904,keymap=en-us --noautoconsole --import
