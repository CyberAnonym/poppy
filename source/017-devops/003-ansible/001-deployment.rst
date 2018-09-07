安装部署ansible
##################

安装ansible
================


.. code-block:: bash

    $ sudo yum install ansible -y

配置ansible
====================

在ansible的hosts配置里添加两台主机
.. code-block::  bash

    $ sudo vim /etc/ansible/hosts
    db1
    db2



创建密钥


::

    [root@ops ~]# ssh-keygen
    Generating public/private rsa key pair.

    Enter file in which to save the key (/root/.ssh/id_rsa): Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /root/.ssh/id_rsa.
    Your public key has been saved in /root/.ssh/id_rsa.pub.
    The key fingerprint is:
    SHA256:fHCWgg35Z9qAZMU+PX8zBhyX3+e1fh2sm5gxNGW9OIc root@ops.shenmin.com
    The key's randomart image is:
    +---[RSA 2048]----+
    |      .+.      . |
    |      ++.  .. +  |
    |     o.++.+. = o.|
    |      ..=== = o *|
    |        SB.= E.++|
    |        ..o o B+.|
    |           o oooo|
    |            =...o|
    |           o o. .|
    +----[SHA256]-----+
    [root@ops ~]#
    [root@ops ~]#
    [root@ops ~]# ssh-copy-id db1
    [root@ops ~]# ssh-copy-id db2

使用ansible
================

.. code-block:: bash

    [alvin@ops ~]$ sudo ansible db1 -m ping
    db1 | SUCCESS => {
        "changed": false,
        "ping": "pong"
    }
    [alvin@ops ~]$ sudo ansible db* -m command -a 'hostname'
    db2 | SUCCESS | rc=0 >>
    db2.shenmin.com

    db1 | SUCCESS | rc=0 >>
    db1.shenmin.com


添加主机组
-----------------



这里的k8s1到k8s4都能解析为IP，是真实的服务器。

.. code-block:: bash

    [root@ops ~]# vim /etc/ansible/hosts
    [k8s]
    k8s1
    k8s2
    k8s3
    k8s4
    [dbs]
    db1
    db2
    [root@ops ~]# ssh-copy-id k8s1
    [root@ops ~]# ssh-copy-id k8s2
    [root@ops ~]# ssh-copy-id k8s3
    [root@ops ~]# ssh-copy-id k8s4
    [root@ops ~]# ansible k8s -m command -a 'ntpdate time.windows.com '
    k8s4 | SUCCESS | rc=0 >>
     7 Sep 13:59:06 ntpdate[11559]: adjust time server 52.163.118.68 offset 0.004244 sec

    k8s2 | SUCCESS | rc=0 >>
     7 Sep 13:59:06 ntpdate[28949]: adjust time server 52.163.118.68 offset 0.002946 sec

    k8s1 | SUCCESS | rc=0 >>
     7 Sep 13:59:07 ntpdate[14539]: adjust time server 52.163.118.68 offset -0.386365 sec

    k8s3 | SUCCESS | rc=0 >>
     7 Sep 13:59:07 ntpdate[706]: adjust time server 52.163.118.68 offset 0.000515 sec

    [root@ops ~]#
    [root@ops ~]# ansible k8s -m shell -a 'hostname;uptime'
    k8s3 | SUCCESS | rc=0 >>
    k8s3.shenmin.com
     13:59:11 up  4:26,  3 users,  load average: 0.24, 0.20, 0.13

    k8s1 | SUCCESS | rc=0 >>
    k8s1.shenmin.com
     13:59:11 up  4:26,  3 users,  load average: 0.31, 0.41, 0.41

    k8s4 | SUCCESS | rc=0 >>
    k8s4.shenmin.com
     13:59:11 up  4:53,  3 users,  load average: 0.24, 0.12, 0.08

    k8s2 | SUCCESS | rc=0 >>
    k8s2.shenmin.com
     13:59:11 up  4:26,  3 users,  load average: 0.94, 0.36, 0.16

上面我们用到了两个模块，一个command模块和一个shell模块，两个模块都是用来执行命令的，有什么区别呢？
区别就是，我们上面在shell模块里的命令，在command里是执行不了的，command只能执行一个命令，不能使用;结束一个命令之后继续执行其他命令，也不能使用管道符。


.. code-block:: bash

    [root@ops ~]# ansible k8s -m command -a 'ls|wc -l'
    k8s4 | FAILED | rc=2 >>
    [Errno 2] No such file or directory

    k8s3 | FAILED | rc=2 >>
    [Errno 2] No such file or directory

    k8s1 | FAILED | rc=2 >>
    [Errno 2] No such file or directory

    k8s2 | FAILED | rc=2 >>
    [Errno 2] No such file or directory

    [root@ops ~]# ansible k8s -m shell -a 'ls|wc -l'
    k8s1 | SUCCESS | rc=0 >>
    52

    k8s4 | SUCCESS | rc=0 >>
    8

    k8s3 | SUCCESS | rc=0 >>
    12

    k8s2 | SUCCESS | rc=0 >>
    14

