vsftpd
##############

Install vsftpd
=========================

::

    yum install vsftpd -y

Start vfstpd
==================

::

    systemctl start vsftpd


create file share
========================

::

    mkdir -p /var/ftp/share
    echo 'this is share' >> /var/ftp/share/hello.txt

use vsftpd
================

比如我们的ip地址是192.168.3.9 在windows下，我们在资源管理器里打开 ftp://192.168.3.9/  就可以看到刚才创建的那个share目录了，打开这个文件，可以看到里面的hello.txt, 我们可以查看该文件的内容

如果客户端无法访问，注意是不是服务器端设置了防火墙，需要设置一下防火墙策略。

允许匿名用户上传文件和目录
===============================

::

    $ chmod o+rwx /var/ftp/share
    $ vim /etc/vsftpd/vsftpd.conf
    anon_upload_enable=YES
    anon_mkdir_write_enable=YES
    $ systemctl restart vsftpd
    $ systemctl enable vsftpd







禁止root用户登录
==========================


.. code-block:: bash

    if [ -d /etc/vsftpd/ ];then sudo grep ^root /etc/vsftpd/user_list &>/dev/null || sudo sed -i.yabbak '$a root' /etc/vsftpd/user_list; if [ $? -eq 0 ];then sudo grep ^root /etc/vsftpd/ftpusers &>/dev/null || sudo sed -i.yabbak '$a root'  /etc/vsftpd/ftpusers ; echo $?;else echo 1;fi || echo 1 ; else echo 0;fi




linux客户端访问
=======================

安装lftp
---------------

.. code-block:: bash

    yum install lftp -y


匿名用户访问

.. code-block:: bash

    [root@test1 ~]# lftp test3
    lftp test3:~> ls
    drwxr-xr-x    2 0        0               6 Oct 30 19:45 pub
    lftp test3:/> exit

系统用户访问

.. code-block:: bash

    [root@test1 ~]# lftp test3 -ualvin
    Password:
    lftp alvin@test3:~> ls
    -rw-------    1 1000     1000           11 Feb 21 08:41 alvinhome.txt
    lftp alvin@test3:~> cat alvinhome.txt
    alvin home
    11 bytes transferred
    lftp alvin@test3:~> exit
