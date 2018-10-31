第七章：管理存储
######################
我们先学习第七章，然后学习第五章和第六章

一般我们需要创建共享存储，用于存储虚拟机硬盘文件，便于虚拟机挂了之后做虚拟机的迁移。



存储虚拟机硬盘文件的村粗-DATA类型的存储
    data类型存储 (用来存储虚拟机的，我们可以有多个data类型的存储)
        iscsi
        nfs
        other

    ISO类型存储（用于存放各种镜像，整个环境里面只能有一个ISO类型存储）

    export类型存储（备份虚拟机，导出域。 导出虚拟机就会导出到export域里面来，存储到其他地方。整个环境里面只能有哦一个export类型存储）


创建iscsi存储
==================

现在我们先在ipa服务器上添加一块硬盘，ipa服务也做我们的存储服务器。

然后我们在ipa服务器上通过targetcli创建iscsi服务，创建名为iqn.2018-10.pub.alv:ipa的target，客户端验证为iqn.2018-10.pub.alv:rhvh。这里创建过程本文中省略，不属于这里的主题知识点，其他章节有讲过iscsi的创建。


配置好iscsi服务器之后，我们在rhvh主机上配置验证

.. code-block:: bash

    [root@rhvh1 ~]# echo 'InitiatorName=iqn.2018-10.pub.alv:rhvh' > /etc/iscsi/initiatorname.iscsi
    [root@rhvh1 ~]# systemctl restart iscsid


然后去web端配置,点击Storage-New domain, 做如下图所示的填写和选择，点击discovery,可以发现目标服务器上iscsi target。

.. image:: ../../../images/virtual/039.png

然后点Login All，成功后，这个按钮就是灰色的了，然后我们就点击确定。



.. image:: ../../../images/virtual/040.png

创建硬盘
==========



创建nfs存储
================

这里nfs存储我们也在ipa服务器上创建.我们共享/iso 和/export 目录，

.. code-block:: bash

    [root@ipa ~]# mkdir -p /iso
    [root@ipa ~]# mkdir -p /export
    [root@ipa ~]# systemctl start nfs-server
    [root@ipa ~]# systemctl enable nfs-server
    [root@ipa ~]# systemctl restart rpcbind
    [root@ipa ~]# systemctl enable rpcbind
    [root@ipa ~]# vim /etc/exports
    /export *(rw,sync)
    /iso    *(rw,sync)
    /vdisk  *(rw,sync)
    [root@ipa ~]# exportfs -rav
    exporting *:/vdisk
    exporting *:/iso
    exporting *:/export

客户端查看验证

.. code-block:: bash

    [root@rhvh1 ~]# showmount -e ipa.alv.pub
    Export list for ipa.alv.pub:
    /vdisk  *
    /iso    *
    /export *

