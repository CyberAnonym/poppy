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

再查看一下yum信息,确认我们能找到我们需要的东西。

::

    yum list openstack*



packstack安装openstack
=============================

packstack安装的时候，有两种方式，
    1.allinone
    2.应答文件的方式

生成应答文件

::

    [root@cl210controller ~]# packstack --help | grep ans
      --gen-answer-file=GEN_ANSWER_FILE
                            Generate a template of an answer file.
      --answer-file=ANSWER_FILE
                            answerfile will also be generated and should be used
      -o, --options         Print details on options available in answer file(rst
                            Packstack a second time with the same answer file and
                            attribute where "y" means an account is disabled.
        --manila-netapp-transport-type=MANILA_NETAPP_TRANSPORT_TYPE
                            The transport protocol used when communicating with
    [root@cl210controller ~]# packstack --gen-answer-file=aa.txt

这样我们就生存了一个应答文件aa.txt

然后我们修改应答文件，主要修改两点，第一点是密码，所有的密码我们改为统一的密码，如果不改，后续需要一些密码的时候就需要到这个文件来找了。第二点是修改CONFIG_PROVISION_DEMO的值为n，也就是不去下载demo，如果为y，系统会去下载demo，需要很长的时间。


grep -i _pw aa.txt