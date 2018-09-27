虚拟机系统信息

- Hostname: server0.example.com
- IP address: 172.25.0.11
- Netmask: 255.255.255.0
- Gateway: 172.25.0.254
- Name server: 172.25.0.254

重设root 密码
------------------

#. 重启虚拟机 server，出现 GRUB 启动菜单时按 e 键进入编辑状态
#. 找到 linux16 所在行，末尾添加 rd.break console=tty0，按 Ctrl+x 键进恢复模式
#. 以可写方式挂载硬盘中的根目录，并重设root 密码：

::

    mount -o remount,rw /sysroot #以可读写方式重新挂载根系
    chroot /sysroot/ #切换到根系统
    passwd root #设置考试指定的root密码
    touch /.autorelabel #标记下一次启动重做SELinux标签
    exit
    reboot

配置主机名、IP地址/掩码/默认网关/DNS 地址
-------------------------------------------

::

    hostnamectl set-hostname server0.example.com


修改ip地址
---------------

.. code-block:: bash

    [root@server0 ~]# nmcli conn show
    [root@server0 ~]# nmcli conn modify eth0 ipv4.addresses	'172.25.0.11/24	172.25.0.254' ipv4.dns 172.25.254.254	ipv4.method manual
    [root@server0 ~]# nmcli connection modify eth0 connection.autoconnect yes
    [root@server0 ~]# nmcli conn up eth0
    [root@server0 ~]# nmcli conn show eth0

ping 测试

确认 selinux 模式
-------------------

请按下列要求设定系统：

SeLinux 的工作模式为 enforcing 要求系统重启后依然生效
::

    [root@server0 ~]#vim /etc/sysconfig/selinux
    # SELINUX= can take one of these three values:
    SELINUX=enforcing [root@server0 ~]# setenforce 1


配置yum
----------

建立Yum软件仓库，该Yum仓库将作为默认仓库。 YUM REPO: http://content.example.com/rhel7.0/x86_64/dvd


::

    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-*
    [root@server0 ~]# cd /etc/yum.repos.d/
    [root@server0 yum.repos.d]# vim base.repo
    [root@server0 yum.repos.d]# cat base.repo
    [base]
    name=base
    baseurl=http://classroom.example.com/content/rhel7.0/x86_64/dvd
    enabled=1
    gpgcheck=0
    [root@server0 yum.repos.d]# yum repolist


调整逻辑卷的大小
------------------

请按照以下要求调整本地逻辑卷 loans 的容量：

- 调整后的逻辑卷及文件系统大小为 770MiB 调整后确保文件系统中已存在的内容不能被破坏调整后的容量可能出现误差，只要在 730MiB - 805MiB 之间都是允许的.

- 调整后，保证其挂载目录不改变，文件系统完成



.. note::

    #. 考试时候系统中只有一块硬盘 vda，而且已经使用三个分区 vda1 vda2 vda3。
    #. 如果卷组需要扩容，将剩余所有空间划分给第四个分区，第四个分区类型是扩展分区



.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,8,16,19,24,30,34,35,38,41-43,46,55,56,58,60,74

    [root@server0 ~]# lab lvm setup
    Creating partition on /dev/vdb ...
    Adding PV ...
    Adding VG ...
    Adding LV ...
    Creating XFS on LV ...
    SUCCESS
    [root@server0 ~]# df
    Filesystem                1K-blocks    Used Available Use% Mounted on
    /dev/vda1                  10473900 3120140   7353760  30% /
    devtmpfs                     927072       0    927072   0% /dev
    tmpfs                        942660      80    942580   1% /dev/shm
    tmpfs                        942660   17024    925636   2% /run
    tmpfs                        942660       0    942660   0% /sys/fs/cgroup
    /dev/mapper/finance-loans    258732   13288    245444   6% /finance/loans
    [root@server0 ~]# lvs
      LV    VG      Attr       LSize   Pool Origin Data%  Move Log Cpy%Sync Convert
      loans finance -wi-ao---- 256.00m
    [root@server0 ~]# vgs
      VG      #PV #LV #SN Attr   VSize   VFree
      finance   1   1   0 wz--n- 508.00m 252.00m

    [root@server0 ~]#
    [root@server0 ~]# fdisk /dev/vdb
    Welcome to fdisk (util-linux 2.23.2).

    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Command (m for help): n
    Partition type:
       p   primary (1 primary, 0 extended, 3 free)
       e   extended
    Select (default p): p
    Partition number (2-4, default 2): 2
    First sector (1050624-20971519, default 1050624):
    Using default value 1050624
    Last sector, +sectors or +size{K,M,G} (1050624-20971519, default 20971519): +1G
    Partition 2 of type Linux and of size 1 GiB is set

    Command (m for help): t
    Partition number (1,2, default 2): 2
    Hex code (type L to list all codes): 8e
    Changed type of partition 'Linux' to 'Linux LVM'

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
    The kernel still uses the old table. The new table will be used at
    the next reboot or after you run partprobe(8) or kpartx(8)
    Syncing disks.
    [root@server0 ~]# partprobe
    [root@server0 ~]# pvcreate /dev/vdb2
      Physical volume "/dev/vdb2" successfully created
    [root@server0 ~]# vgextend finance /dev/vdb2
      Volume group "finance" successfully extended
    [root@server0 ~]# lvextend -r -L 770M /dev/finance/loans
      Rounding size to boundary between physical extents: 772.00 MiB
      Extending logical volume loans to 772.00 MiB
      Logical volume loans successfully resized
    meta-data=/dev/mapper/finance-loans isize=256    agcount=4, agsize=16384 blks
             =                       sectsz=512   attr=2, projid32bit=1
             =                       crc=0
    data     =                       bsize=4096   blocks=65536, imaxpct=25
             =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
    log      =internal               bsize=4096   blocks=853, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
    data blocks changed from 65536 to 197632
    [root@server0 ~]# df -h
    Filesystem                 Size  Used Avail Use% Mounted on
    /dev/vda1                   10G  3.0G  7.1G  30% /
    devtmpfs                   906M     0  906M   0% /dev
    tmpfs                      921M   80K  921M   1% /dev/shm
    tmpfs                      921M   17M  904M   2% /run
    tmpfs                      921M     0  921M   0% /sys/fs/cgroup
    /dev/mapper/finance-loans  769M   14M  756M   2% /finance/loans


创建用户和用户组
---------------------

请按照以下要求创建用户、用户组：

#. 新建一个名为 adminuser 的组，组 id 为 40000
#. 新建一个名为 natasha 的用户，并将 adminuser 作为其附属组
#. 新建一个名为harry 的用户，并将 adminuser 作为其附属组
#. 新建一个名为 sarah 的用户，其不属于 adminuser 组，并将其 shell 设置为不可登陆shell
#. natasha、harry 和 sarah 三个用户的密码均设置为 alvin

::

    [root@server0 ~]# groupadd -g 40000 adminuser
    [root@server0 ~]# useradd -G adminuser natasha
    [root@server0 ~]# useradd -G adminuser harry
    [root@server0 ~]# useradd -s /sbin/nologin sarah
    [root@server0 ~]# echo alvin |passwd --stdin natasha Changing password for user natasha. passwd: all authentication tokens updated successfully.
    [root@server0 ~]# echo alvin |passwd --stdin harry Changing password for user harry. passwd: all authentication tokens updated successfully.
    [root@server0 ~]# echo alvin |passwd --stdin sarah Changing password for user sarah.
    passwd: all authentication tokens updated successfully.

文件权限设定
---------------

复制文件/etc/fstab 到/var/tmp 目录下，并按照以下要求配置/var/tmp/fstab 文件的权限:

    #. 该文件的所属人为 root
    #. 该文件的所属组为 root
    #. 该文件对任何人均没有执行权限
    #. 用户natasha对该文件有读和写的权限
    #. 用户harry对该文件既不能读也不能写
    #. 所有其他用户（包括当前已有用户及未来创建的用户）对该文件都有读的权限

参考解答：

::

    [root@server0 ~]# cp /etc/fstab /var/tmp/
    [root@server0 ~]# cd /var/tmp/
    [root@server0 tmp]# ll fstab
    -rw-r--r--. 1 root root 358 Apr	4 07:27 fstab
    [root@server0 tmp]# setfacl -m u:natasha:rw fstab
    [root@server0 tmp]# setfacl -m u:harry:- fstab
    [root@server0 tmp]# setfacl -m o:r fstab
    验证结果：
    [root@server0 ~]# getfacl /var/tmp/fstab

建立计划任务
---------------

对 natasha 用户建立计划任务，要求在本地时间的每天 14：23 执行以下命令：/bin/echo "rhcsa"

参考解答：

::

    [root@server0 ~]# su - natasha
    [natasha@server0 ~]$ crontab -e 编辑临时文件插入如下条目：
    23 14 * * * /bin/echo "rhcsa"
    :wq 保存退出。
    查看结果
    [natasha@server0 ~]$ crontab -l
    23 14 * * * /bin/echo "rhcsa"

文件特殊权限设定
-------------------

在/home 目录下创建名为 admins 的子目录，并按以下要求设置权限：

#. /home/admins 的所属组为 adminuser
#. 该目录对 adminuser 组的成员可读可执行可写，但对其他用户没有任何权限，但 root 不受限制
#. 在/home/admins 目录下所创建的文件的所属组自动被设置为 adminuser

::

    [root@server0 ~]# mkdir /home/admins
    [root@server0 ~]# chgrp adminuser /home/admins
    [root@server0 ~]# chmod 2770 /home/admins

升级系统内核
-----------------

请按下列要求更新系统的内核：

新内核的 RPM 包位于
http://content.example.com/rhel7.0/x86_64/errata/Packages/

系统重启后，默认以新内核启动系统，原始的内核将继续可用

在 foundation 上使用浏览 http://content.example.com/rhel7.0/x86_64/errata/Packages/, 找到文件，复制下载链接


在终端中使用 wget 下载文件。
::

    [root@server0 ~]# wget http://content.example.com/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm

安装 kernel：
::

    yum localinstall -y kernel-3.10.0-123.1.2.el7.x86_64.rpm #安装内核时间比较长，需要等待几分钟。


验证：查看当前内核版本信息，重启后再查看内核版本信息。

::

    [root@server0 ~]# uname -r
    3.10.0-123.el7.x86_64

配置ldap客户端
-------------------


在 classroom.example.com 上已经部署了一台 LDAP 认证服务器，按以下要求将你的系统加入到该 LDAP 服务中，并使用 ldap 认证用户密码：

    #. 该LDAP 认证服务的 Base DN 为：dc=example,dc=com
    #. 该 LDAP 认证服务的 LDAP Server 为：classroom.example.com
    #. 认证的会话连接需要使用 TLS 加密，加密所用证书请在此下载 http://classroom.example.com/pub/example-ca.crt

上一次考试只给了 Base DN 和 ldap 服务器，ldap 服务器名填写题目中提到的主机名。

解答：

    用户信息和验证信息全为 ldap

    安装软件包
    ::

        yum install -y sssd	krb5-workstation.x86_64 nss-pam-* pam-krb5
        mdkir -p /etc/openldap/cacerts
        wget -P  /etc/openldap/cacerts http://classroom.example.com/pub/example-ca.crt


    打开配置界面
    ::

        authconfig-tui

    左侧选中 Use LDA P 和右侧选中 Use LDAP Authentication，然后 Next

    - 选中 Use TLS 和填写 LDAP Server 和 Base DN，然后 Next
        | [*] Use TLS
        | Server: ldap://classroom.example.com
        | Base DN: dc=example,dc=com

    - 然后填写Kerberos Settings
        | Realm: EXAMPLE.COM     #注意要大写
        | KDC: clssroom.example.com
        | Admin Server: classroom.com
        | (下面两相不用勾选)

    - 配置Kerberos

        | Realm: EXAMPLE.COM
        | KDC: classroom.example.com
        | Admin Server: classroom.example.com


    ::

        [root@server0 ~]# getent passwd ldapuser0


配置 LDAP 用户家目录自动挂载
-------------------------------


请使用 LDAP 服务器上的用户 ldapuser0 登陆系统，并满足以下要求：

    #. ldapuser0 用户的家目录路径为/home/guests/ldapuser0
    #. ldapuser0 用户登陆后，家目录会自动挂载到 classroom.example.com 服务通过 nfs 服务到处的/home/guests/ldapuser0
    #. 客户端挂载使用 nfs 版本 3

解答：

安装软件包：
::

    [root@server0 ~]# yum install -y autofs

查看 ldapuser0 家目录位置为/home/guests/ldapuser0 和服务器共享的位置/home/guests
::

    [root@server0 ~]# getent passwd ldapuser0
    ldapuser0:*:1700:1700:LDAPTest User 0:/home/guests/ldapuser0:/bin/bash
    [root@server0 ~]# showmount -e classroom Export list for classroom:
    /home/guests 172.25.0.0/255.255.0.0
    准备目录
    [root@server0 ~]# mkdir /home/guests
    [root@server0 ~]# cd /etc/auto.master.d/
    [root@server0 auto.master.d]# touch ldap.autofs
    [root@server0 auto.master.d]# vim ldap.autofs
    /home/guests	/etc/auto.ldap
    :wq 保存退出
    [root@server0 auto.master.d]# cd /etc
    [root@server0 etc]# touch auto.ldap
    [root@server0 etc]# vim auto.ldap
    *	-rw,sync,v3	classroom.example.com:/home/guests/&
    :wq 保存退出
    设置 autofs 开机启动，并启动 autofs 服务。
    [root@server0 ~]# systemctl enable autofs.service
    ln	-s	'/usr/lib/systemd/system/autofs.service' '/etc/systemd/system/multi-user.target.wants/autofs.service'
    [root@server0 ~]# systemctl restart autofs.service
    验证：
    su - ldapuser0

本题如果自动挂载失败，可能是时间与服务器不一致到值得。可以先做 NTP 服务配置，再回来完成此题。如果还是不行，使用 date 命令手动设置时间。

先查看物理主机时间
::

    date

然后设置 server 时间，将物理主机完整时间拷贝过来，修改一下操作过程时间差。

    [root@server0 ~]# date -s "Wed Mar 15 09:37:36 CST 2017"


时间同步
------------

使用 NTP 配置系统时间与服务器 classroom.example.com 同步，要求系统重启后依然生效。

解答：

使用 chrony 配置或者 ntp 配置，都可以得分。

确认 chrony 软件包已经安装
::

    yum list chrony

一般情况，系统会自动安装。如果没有安装执行 yum install -y chrony 安装。

编辑配置文件/etc/chrony.conf，将文件中 server 记录全部删除或者注释掉，添加如下内容：

server classroom.example.com iburst

::

    [root@server0 ~]# vim /etc/chrony.conf
    server classroom.example.com iburst
    :wq 保存退出。

设置 chronyd 服务开机启动并重启服务
--------------------------------------
::

    [root@server0 ~]# systemctl enable chronyd
    [root@server0 ~]# systemctl restart chronyd

验证：
::

    [root@server0 ~]# chronyc sources -v

利用 server 设定上层 NTP 服务器，格式如下：

server [IP or hostname] [prefer] perfer:表示优先级最高 burst ：当一个运程 NTP 服务器可用时，向它发送一系列的并发包进行检测。 iburst ：当一个运程 NTP 服务器不可用时，向它发送一系列的并发包进行检测。

ntp 和 chrony 服务有冲突，同时只能运行一个。我们的评分脚本是根据 chrony 评分的。

打包文件
-------------

请对 /etc/sysconfig 目录进行打包并用 gzip 压缩，生成的文件保存为/root/sysconfig.tar.gz

-j, --bzip2 filter the archive through bzip2

-J, --xz filter the archive through xz

-z, --gzip filter the archive through gzip

解答：
::

[root@server0 ~]# tar -cvzf	/root/sysconfig.tar.gz /etc/sysconfig 评分脚本按照 bz2 格式评分，/root/sysconfig.tar.bz2


创建用户
------------

请创建一个名为 alex 的用户，并满足以下要求：

用户 id 为 3456 密码为 glegunge

解答：
::

    [root@server0 ~]# useradd -u 3456 alex
    [root@server0 ~]# echo glegunge|passwd --stdin alex

创建 swap 分区
-------------------

为系统新增加一个 swap 分区：新建的 swap 分区容量为 512MiB 重启系统后，新建的 swap 分区会自动激活不能删除或者修改原有的 swap 分区

解答：

::

    [root@server0 ~]# fdisk /dev/vdb
    Welcome to fdisk (util-linux 2.23.2).
    Changes will remain in memory only, until you decide to write them. Be careful before using the write command.
    Command (m for help): n
    Partition type:
    p	primary (2 primary, 0 extended, 2 free) e	extended
    Select (default p):
    Using default response p
    Partition number (3,4, default 3):
    First sector (2074624-20971519, default 2074624):
    Using default value 2074624
    Last sector, +sectors or +size{K,M,G} (2074624-20971519, default 20971519): +512M
    Partition 3 of type Linux and of size 512 MiB is set
    Command (m for help): t
    Partition number (1-3, default 3):
    Hex code (type L to list all codes): 82
    Changed type of partition 'Linux' to 'Linux swap / Solaris'
    Command (m for help): w
    The partition table has been altered!
    Calling ioctl() to re-read partition table.
    WARNING: Re-reading the partition table failed with error 16: Device or resource busy. The kernel still uses the old table.
    The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8) Syncing disks.
    通知内核更新分区表
    [root@server0 ~]# partprobe
    格式化 swap 分区
    [root@server0 ~]# mkswap /dev/vdb3
    编辑/etc/fstab
    [root@server0 ~]# vim /etc/fstab
    UUID=3a433201-5c45-46e0-9c1f-b8f2e48de8eb	swap	swap	defaults
    0 0
    :wq 保存退出。
    挂载
    [root@server0 ~]# swapon /dev/vdb3
    验证：
    [root@server0 ~]# swapon -s
    [root@server0 ~]# free

查找文件
------------

请把系统上拥有者为 ira 用户的所有文件，并将其拷贝到/root/findfiles 目录中

解答：文件夹一定要先创建。

::

    [root@server0 ~]# mkdir findfiles
    [root@server0 ~]# find / -user ira -exec cp -rpf {} /root/findfiles/ \;


过滤文件
--------------

把/usr/share/dict/words 文件中所有包含 seismic 字符串的行找到，并将这些行按照原始文件中的顺序存放到/root/wordlist 中，/root/wordlist 文件不能包含空行

解答：
::

    [root@server0 ~]# grep seismic /usr/share/dict/words > /root/wordlist

LVM
--------

请按下列要求创建一个新的逻辑卷创建一个名为 exam 的卷组，卷组的 PE 尺寸为 16MiB 逻辑卷的名字为 lvm2,所属卷组为 exam,

该逻辑卷由 8 个 PE 组成将新建的逻辑卷格式化为 xfs 文件系统，要求系统启动时，该逻辑卷能被自动挂载到

/exam/lvm2 目录

解答：准备分区，标记分区类型，通知内核更新分区表

::

    [root@server0 ~]# fdisk /dev/vdb
    Welcome to fdisk (util-linux 2.23.2).
    Changes will remain in memory only, until you decide to write them. Be careful before using the write command.
    Command (m for help): n
    Partition type:
    p	primary (3 primary, 0 extended, 1 free) e	extended
    Select (default e):
    Using default response e
    Selected partition 4
    First sector (3123200-20971519, default 3123200):
    Using default value 3123200
    Last sector, +sectors or +size{K,M,G} (3123200-20971519, default 20971519):
    Using default value 20971519
    Partition 4 of type Extended and of size 8.5 GiB is set
    Command (m for help): n
    All primary partitions are in use
    Adding logical partition 5
    First sector (3125248-20971519, default 3125248):
    Using default value 3125248
    Last sector, +sectors or +size{K,M,G} (3125248-20971519, default 20971519): +500M
    Partition 5 of type Linux and of size 500 MiB is set
    Command (m for help): t
    Partition number (1-5, default 5):
    Hex code (type L to list all codes): 8e
    Changed type of partition 'Linux' to 'Linux LVM'
    Command (m for help): w
    The partition table has been altered!
    Calling ioctl() to re-read partition table.
    WARNING: Re-reading the partition table failed with error 16: Device or resource busy. The kernel still uses the old table.
    The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8) Syncing disks.
    [root@server0 ~]# partprobe
    创建 pv，vg，lv
    [root@server0 ~]# pvcreate /dev/vdb5
    Physical volume "/dev/vdb3" successfully created
    [root@server0 ~]# vgcreate -s 16M exam /dev/vdb5 Volume group "wgroup" successfully created
    [root@server0 ~]# lvcreate -l 8 -n lvm2 exam
    Logical volume "wshare" created
    [root@server0 ~]#
    格式化分区
    [root@server0 ~]# mkfs.xfs	/dev/exam/lvm2
    创建挂载点
    [root@server0 ~]# mkdir /exam/lvm2
    设置永久挂载，编辑/etc/fstab，添加如下内容：
    [root@server0 ~]# vim /etc/fstab
    /dev/exam/lvm2	/exam/lvm2	xfs	defaults	0 0
    :wq 保存退出
    验证：
    [root@server0 ~]# mount -a
    [root@server0 ~]# df -h
    [root@server0 ~]# vgdisplay exam
    [root@server0 ~]# lvdisplay /dev/exam/lvm2


最后检查
-----------

重启前检查一遍考试涉及到的服务是否设置开机启动，selinux 问题服务包涵：定时计划任务 crond，ntp 对时 chronyd，自动挂载 autofs

第一遍做完一定要重启，保证有充足的时间排错。不要到最后 5 分钟再重启系统。

扩文件系统分两步：扩逻辑卷和扩文件系-统，也可以在 lvextend 时候使用-r 参数直接扩文件系统，ext4 和 xfs 都支持。

ldap 题目使用 authconfig-tui 字符界面完成。


成绩自检：
-------------

server0： lab examrhcsa grade
