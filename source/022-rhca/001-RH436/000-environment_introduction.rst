RH436学习环境介绍
###################

RH436的练习我们在都是在虚拟机里进行。

首先我们通过VMware Workstation创建一个RHEL7.1系统的虚拟机，主机名是server1然后在这台机器里安装kvm，在后在这里面通过kvm创建五个虚拟机。

五个虚拟机用于我们做实验的，分别是node1 到node3，地址地址与主机名对应如下， node就是server1

::

    192.168.122.1 node
    192.168.122.10 node1
    192.168.122.20 node2
    192.168.122.30 node3
    192.168.122.40 node4
    192.168.122.50 node5


node就是宿主机，也就是我们安装在vmware workstation平台上的虚拟机，他模拟物理机。



另外，我个人创建了两个脚本，便于一次性在多个节点上执行命令，脚本内容如下

.. code-block:: bash

    [root@server1 ~]# cat to_node3.sh
    #!/bin/bash
    command=$@
    for i in {1..3};do ssh node$i "$command";done
    [root@server1 ~]#
    [root@server1 ~]# cat to_node5.sh
    #!/bin/bash
    command=$@
    for i in {1..5};do ssh node$i "$command";done
    [root@server1 ~]# ln -sv /root/to_node3.sh /bin/3node
    [root@server1 ~]# ln -sv /root/to_node5.sh /bin/5node

然后server1上对创建ssh秘钥，公钥发布到了每一台node上，所以可以对node1到node2做ssh无密码登录。

所以，现在如果我想在node1 node2 node3上都安装httpd，我就只需要在server1上执行下面的一条命令就好了。

.. code-block:: bash

    [root@server1 ~]# 3node yum install httpd -y
