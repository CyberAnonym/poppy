克隆虚拟机
###############

比如我们要克隆的虚拟机名字是vos2.alv.pub，我们要可能出的虚拟机名为cl.vos2.img,那么首先我们要关闭vos2.alv.pub

.. code-block:: bash

    # virsh shutdown vos2.alv.pub
    # virsh list --all

确保vos2.alv.pub已经关掉了之后，执行下面的命令，-o 是source，指定源虚拟机，-n是name，指定要创建出的虚拟机的名字，-f 是指定一个img文件路径，作为马上要创建出的虚拟机的磁盘文件。

.. code-block:: bash

    # virt-clone -o vos2.alv.pub -n cl.vos2 -f /kvmdata/cl.vos2.img

克隆好之后，就启动这台虚拟机。

.. code-block:: bash

    # virsh start cl.vos2

如果在启动的时候报了错，比如如下报错

error: Failed to start domain 2.clone.vos
error: internal error: process exited while connecting to monitor: 2016-10-08T05:28:42.493328Z qemu-kvm: -chardev socket,id=charchannel0,path=/var/lib/libvirt/qemu/channel/target/domain-vos2.alv.pub/org.qemu.guest_agent.0,server,nowait: Failed to bind socket: No such file or directory
2016-10-08T05:28:42.493431Z qemu-kvm: -chardev socket,id=charchannel0,path=/var/lib/libvirt/qemu/channel/target/domain-vos2.alv.pub/org.qemu.guest_agent.0,server,nowait: chardev: opening backend "socket" faile

那么就需要修改配置文件

.. code-block:: bash

    # virsh edit cl.vos2

去注销一些东西，注销的方式是<!--
-->

然后再次启动虚拟机

启动后进入到虚拟机里对对网卡进行一下配置，

vim /etc/udev/rules.d/70-persistent-net.rules

如果被克隆的虚拟机只有一块网卡，这里会有eth0和eth1，eth0就是之前那台虚拟机的mac地址，我们把这行删掉，然后把eth1那行的eth1改成eth0，同时记录一下这个mac地址，然后去修改eth0的网卡配置文件vim /etc/sysconfig/network-scripts/ifcfg-eth0