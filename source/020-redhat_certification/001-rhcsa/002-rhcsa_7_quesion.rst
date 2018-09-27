RHCSA练习题
===============

虚拟机系统信息

- Hostname: server0.example.com
- IP address: 172.25.0.11
- Netmask: 255.255.255.0
- Gateway: 172.25.0.254
- Name server: 172.25.0.254

重设root 密码
------------------

重置密码为redhat


配置主机名、IP地址/掩码/默认网关/DNS 地址
-------------------------------------------

- Hostname: server0.example.com
- IP address: 172.25.0.11
- Netmask: 255.255.255.0
- Gateway: 172.25.0.254
- Name server: 172.25.0.254



确认 selinux 模式
-------------------

请按下列要求设定系统：

SeLinux 的工作模式为 enforcing 要求系统重启后依然生效


配置yum
----------

建立Yum软件仓库，该Yum仓库将作为默认仓库。 YUM REPO: http://content.example.com/rhel7.0/x86_64/dvd



调整逻辑卷的大小
------------------

请按照以下要求调整本地逻辑卷 loans 的容量：

- 调整后的逻辑卷及文件系统大小为 770MiB 调整后确保文件系统中已存在的内容不能被破坏调整后的容量可能出现误差，只要在 730MiB - 805MiB 之间都是允许的.

- 调整后，保证其挂载目录不改变，文件系统完成



创建用户和用户组
---------------------

请按照以下要求创建用户、用户组：

#. 新建一个名为 adminuser 的组，组 id 为 40000
#. 新建一个名为 natasha 的用户，并将 adminuser 作为其附属组
#. 新建一个名为harry 的用户，并将 adminuser 作为其附属组
#. 新建一个名为 sarah 的用户，其不属于 adminuser 组，并将其 shell 设置为不可登陆shell
#. natasha、harry 和 sarah 三个用户的密码均设置为 alvin


文件权限设定
---------------

复制文件/etc/fstab 到/var/tmp 目录下，并按照以下要求配置/var/tmp/fstab 文件的权限:

    #. 该文件的所属人为 root
    #. 该文件的所属组为 root
    #. 该文件对任何人均没有执行权限
    #. 用户natasha对该文件有读和写的权限
    #. 用户harry对该文件既不能读也不能写
    #. 所有其他用户（包括当前已有用户及未来创建的用户）对该文件都有读的权限



建立计划任务
---------------

对 natasha 用户建立计划任务，要求在本地时间的每天 14：23 执行以下命令：/bin/echo "rhcsa"



文件特殊权限设定
-------------------

在/home 目录下创建名为 admins 的子目录，并按以下要求设置权限：

#. /home/admins 的所属组为 adminuser
#. 该目录对 adminuser 组的成员可读可执行可写，但对其他用户没有任何权限，但 root 不受限制
#. 在/home/admins 目录下所创建的文件的所属组自动被设置为 adminuser


升级系统内核
-----------------

请按下列要求更新系统的内核：

新内核的 RPM 包位于
http://content.example.com/rhel7.0/x86_64/errata/Packages/



配置ldap客户端
-------------------


在 classroom.example.com 上已经部署了一台 LDAP 认证服务器，按以下要求将你的系统加入到该 LDAP 服务中，并使用 ldap 认证用户密码：

    #. 该LDAP 认证服务的 Base DN 为：dc=example,dc=com
    #. 该 LDAP 认证服务的 LDAP Server 为：classroom.example.com
    #. 认证的会话连接需要使用 TLS 加密，加密所用证书请在此下载 http://classroom.example.com/pub/example-ca.crt





配置 LDAP 用户家目录自动挂载
-------------------------------


请使用 LDAP 服务器上的用户 ldapuser0 登陆系统，并满足以下要求：

    #. ldapuser0 用户的家目录路径为/home/guests/ldapuser0
    #. ldapuser0 用户登陆后，家目录会自动挂载到 classroom.example.com 服务通过 nfs 服务到处的/home/guests/ldapuser0
    #. 客户端挂载使用 nfs 版本 3



时间同步
------------

使用 NTP 配置系统时间与服务器 classroom.example.com 同步，要求系统重启后依然生效。



设置 chronyd 服务开机启动并重启服务
--------------------------------------

打包文件
-------------

请对 /etc/sysconfig 目录进行打包并用 gzip 压缩，生成的文件保存为/root/sysconfig.tar.gz




创建用户
------------

请创建一个名为 alex 的用户，并满足以下要求：

用户 id 为 3456 密码为 glegunge


创建 swap 分区
-------------------

为系统新增加一个 swap 分区：新建的 swap 分区容量为 512MiB 重启系统后，新建的 swap 分区会自动激活不能删除或者修改原有的 swap 分区

查找文件
------------

请把系统上拥有者为 ira 用户的所有文件，并将其拷贝到/root/findfiles 目录中



过滤文件
--------------

把/usr/share/dict/words 文件中所有包含 seismic 字符串的行找到，并将这些行按照原始文件中的顺序存放到/root/wordlist 中，/root/wordlist 文件不能包含空行

LVM
--------

请按下列要求创建一个新的逻辑卷创建一个名为 exam 的卷组，卷组的 PE 尺寸为 16MiB 逻辑卷的名字为 lvm2,所属卷组为 exam,

该逻辑卷由 8 个 PE 组成将新建的逻辑卷格式化为 xfs 文件系统，要求系统启动时，该逻辑卷能被自动挂载到

/exam/lvm2 目录

解答：准备分区，标记分区类型，通知内核更新分区表


最后检查
-----------

重启前检查一遍考试涉及到的服务是否设置开机启动，selinux 问题服务包涵：定时计划任务 crond，ntp 对时 chronyd，自动挂载 autofs

第一遍做完一定要重启，保证有充足的时间排错。不要到最后 5 分钟再重启系统。

扩文件系统分两步：扩逻辑卷和扩文件系-统，也可以在 lvextend 时候使用-r 参数直接扩文件系统，ext4 和 xfs 都支持。

ldap 题目使用 authconfig-tui 字符界面完成。



