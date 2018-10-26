快速安装虚拟机
######################


先从原虚拟机拷贝出虚拟机文件

.. code-block:: bash

    [root@kvm ~]# du -sh /var/lib/libvirt/images/*
    7.3G	/var/lib/libvirt/images/alice.alv.pub.qcow2
    1.9G	/var/lib/libvirt/images/ceph2.alv.pub.qcow2
    512M	/var/lib/libvirt/images/node.qcow2

    [root@kvm ~]# cp /var/lib/libvirt/images/{ceph2.alv.pub.qcow2,test1.alv.pub.qcow2}



用拷贝出的虚拟机文件，安装一个新的虚拟机，这里我们定义了多个参数，包括-memory 指定内存，-n 指定虚拟机名，-m指定MAC地址。 --disk指定磁盘地址。

.. code-block:: bash

    [root@kvm ~]# virt-install -memory 2048 -n test2.alv.pub --os-variant rhel7 -m 00:11:22:33:44:10 -w default --graphics vnc,keymap=en-us --disk=/var/lib/libvirt/images/test1.alv.pub.qcow2 --import

