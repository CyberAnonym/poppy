openstack
#####################


安装openstack的方式：
    devstack
    packstack----RDO
    fuse---图形化界面的方式安装

    手动部署
    ansible
    director






安装openstack
======================

安装openstack(RHOSP10)

    安装在RHEL7.3上。



部署网络yum源
====================

先将一个相应的软件都上传到服务器上，RHEL7.3的镜像我们用本地挂载上来的/dev/sr0.

.. code-block:: bash

    [root@cl210compute ~]# mkdir -p /rhca
    [root@cl210compute ~]# yum install cifs-utils -y
    [root@cl210compute ~]# mount //192.168.3.5/public/rhca /rhca -o user=smb,password=wankaihao
    [root@cl210compute ~]# ll /rhca/CL210/soft/
    total 5781717
    -rwxr-xr-x 1 root root        377 Oct 24 07:17 aa.repo
    -rwxr-xr-x 1 root root       2903 Nov 12 23:00 aa.template
    drwxr-xr-x 2 root root          0 Nov 13 05:24 director镜像
    -rwxr-xr-x 1 root root      36110 Nov 12 23:00 rabbitmqadmin
    -rwxr-xr-x 1 root root 1518446592 Nov 12 23:00 rhel-7.3-server-updates-20170308.iso
    -rwxr-xr-x 1 root root 3183450112 Oct 24 07:26 RHEL7OSP-10.0-20170309.3-x86_64.iso
    -rwxr-xr-x 1 root root  177152000 Oct 24 07:18 rhel-7-server-extras-20170308.iso
    -rwxr-xr-x 1 root root  495140864 Oct 24 07:26 rhel-7-server-rh-common-20170308.iso
    -rwxr-xr-x 1 root root  543153092 Oct 24 07:24 rhel-guest-image-7-7.3-35.el7_3.noarch.rpm
    -rwxr-xr-x 1 root root       2213 Nov 12 23:00 web_server.yaml
    -rwxr-xr-x 1 root root    3080930 Nov 12 23:02 练习手册.docx



创建用于挂载的目标目录

.. code-block:: bash

    mkdir -p /var/ftp/{update,osp10,extras,common,dvd}

设置挂载

.. code-block:: bash


    $ vim /etc/fstab
    //192.168.3.5/public/rhca /rhca cifs defaults,_netdev,user=smb,password=wankaihao 0 0
    /rhca/CL210/soft/rhel-7.3-server-updates-20170308.iso /var/ftp/update iso9660 defaults 0 0
    #/rhca/CL210/soft/RHEL7OSP-10.0-20170309.3-x86_64.iso /var/ftp/osp10 iso9660 defaults 0 0
    /rhca/CL210/soft/rhel-7-server-extras-20170308.iso /var/ftp/extras iso9660 defaults 0 0
    /rhca/CL210/soft/rhel-7-server-rh-common-20170308.iso /var/ftp/common iso9660 defaults 0 0
    /dev/sr0 /var/ftp/dvd iso9660 defaults 0 0

    $ mount -a


这个时候，osp10是还用不了的，因为他没有直接有repodata，接下来来我们要去创建

.. code-block:: bash

    yum install createrepo -y


然后我们创建一个临时目录,并挂载到临时目录

.. code-block:: bash

    mkdir -p /xx
    mount /rhca/CL210/soft/RHEL7OSP-10.0-20170309.3-x86_64.iso /xx

拷贝到/var/ftp/ops10目录下，并创建repodata

::

    cp -rf /xx/* /var/ftp/osp10/
    cp /rhca/CL210/soft/rhel-guest-image-7-7.3-35.el7_3.noarch.rpm /var/ftp/osp10/
    createrepo -v /var/ftp/osp10/


然后我们安装启动下vsftpd服务

::

    yum install vsftpd -y
    systemctl start vsftpd
    systemctl restart vsftpd
    systemctl enable vsftpd


创建yum仓库

::

    $ vim /etc/yum.repos.d/aa.repo
    [dvd]
    name=dvd
    baseurl=ftp://192.168.3.4/dvd
    enabled=1
    gpgcheck=0

    [update]
    name=update
    baseurl=ftp://192.168.3.4/update
    enabled=1
    gpgcheck=0

    [extras]
    name=extras
    baseurl=ftp://192.168.3.4/extras
    enabled=1
    gpgcheck=0

    [common]
    name=common
    baseurl=ftp://192.168.3.4/common
    enabled=1
    gpgcheck=0

    [osp10]
    name=osp10
    baseurl=ftp://192.168.3.4/osp10
    enabled=1
    gpgcheck=0


拷贝到compute节点去

::

    scp /etc/yum.repos.d/aa.repo cl210compute:/etc/yum.repos.d/



再查看一下yum信息,确认我们能找到我们需要的东西。

::

    yum list openstack*

安装openstack-packstack

::

    yum install openstack-packstack -y

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


然后这里我们修改密码为redhat,DEMO那里改为n

::

    sed -i.bak -r 's/(.+_PW)=[0-9a-z]+/\1=redhat/' aa.txt
    sed -i.bak 's/CONFIG_PROVISION_DEMO=.*/CONFIG_PROVISION_DEMO=n'/ aa.txt


然后开始安装

::

    [root@cl210controller ~]# packstack --answer-file=aa.txt
    Welcome to the Packstack setup utility

    The installation log file is available at: /var/tmp/packstack/20181213-200151-1wVxDo/openstack-setup.log

    Installing:
    Clean Up                                             [ DONE ]
    Discovering ip protocol version                      [ DONE ]
    Setting up ssh keys                                  [ DONE ]
    Preparing servers                                    [ DONE ]
    Pre installing Puppet and discovering hosts' details [ DONE ]
    Preparing pre-install entries                        [ DONE ]
    Setting up CACERT                                    [ DONE ]
    Preparing AMQP entries                               [ DONE ]
    Preparing MariaDB entries                            [ DONE ]
    Fixing Keystone LDAP config parameters to be undef if empty[ DONE ]
    Preparing Keystone entries                           [ DONE ]
    Preparing Glance entries                             [ DONE ]
    Checking if the Cinder server has a cinder-volumes vg[ DONE ]
    Preparing Cinder entries                             [ DONE ]
    Preparing Nova API entries                           [ DONE ]
    Creating ssh keys for Nova migration                 [ DONE ]
    Gathering ssh host keys for Nova migration           [ DONE ]
    Preparing Nova Compute entries                       [ DONE ]
    Preparing Nova Scheduler entries                     [ DONE ]
    Preparing Nova VNC Proxy entries                     [ DONE ]
    Preparing OpenStack Network-related Nova entries     [ DONE ]
    Preparing Nova Common entries                        [ DONE ]
    Preparing Neutron LBaaS Agent entries                [ DONE ]
    Preparing Neutron API entries                        [ DONE ]
    Preparing Neutron L3 entries                         [ DONE ]
    Preparing Neutron L2 Agent entries                   [ DONE ]
    Preparing Neutron DHCP Agent entries                 [ DONE ]
    Preparing Neutron Metering Agent entries             [ DONE ]
    Checking if NetworkManager is enabled and running    [ DONE ]
    Preparing OpenStack Client entries                   [ DONE ]
    Preparing Horizon entries                            [ DONE ]
    Preparing Swift builder entries                      [ DONE ]
    Preparing Swift proxy entries                        [ DONE ]
    Preparing Swift storage entries                      [ DONE ]
    Preparing Gnocchi entries                            [ DONE ]
    Preparing MongoDB entries                            [ DONE ]
    Preparing Redis entries                              [ DONE ]
    Preparing Ceilometer entries                         [ DONE ]
    Preparing Aodh entries                               [ DONE ]
    Preparing Puppet manifests                           [ DONE ]
    Copying Puppet modules and manifests                 [ DONE ]
    Applying 192.168.3.9_controller.pp
    192.168.3.9_controller.pp:                           [ DONE ]
    Applying 192.168.3.9_network.pp
    192.168.3.9_network.pp:                              [ DONE ]
    Applying 192.168.3.9_compute.pp
    192.168.3.9_compute.pp:                              [ DONE ]
    Applying Puppet manifests                            [ DONE ]
    Finalizing                                           [ DONE ]

     **** Installation completed successfully ******

    Additional information:
     * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
     * File /root/keystonerc_admin has been created on OpenStack client host 192.168.3.9. To use the command line tools you need to source the file.
     * To access the OpenStack Dashboard browse to http://192.168.3.9/dashboard .
    Please, find your login credentials stored in the keystonerc_admin in your home directory.
     * The installation log file is available at: /var/tmp/packstack/20181213-200151-1wVxDo/openstack-setup.log
     * The generated manifests are available at: /var/tmp/packstack/20181213-200151-1wVxDo/manifests

然后我们可以通过 http://192.168.3.9/dashboard 来访问了。

后续如果服务器重启了，httpd服务无法启动，可以执行 mkdir -p /run/httpd 来解决。


