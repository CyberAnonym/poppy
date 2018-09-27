RHCE练习题
#################


环境说明
================

真实机（无 root 权限）：foundation.groupX.example.com

虚拟机 1（有 root 权限）：system1.groupX.example.com

虚拟机 2（有 root 权限）：system2.groupX.example.com

考试服务器（提供 DNS/YUM/认证/素材	）：server1.groupX.example.com、host.groupX.example.com

练习环境说明
==================

真实机（无 root 权限）：foundationX.example.com

虚拟机 1（有 root 权限）：serverX.example.com

虚拟机 2（有 root 权限）：desktopX.example.com

练习服务器（提供 DNS/YUM/认证/素材.. ..）：http://classroom.example.com

example.com,group0.example.com: 172.25.0.0/24

alv.pub:    172.24.3.0/24

上面描述的主机名即域名，访问该域名可以解析到相应的IP地址，上述域名中的X,代表服务器编号，比如我的服务器编号是3，那么我的server端的域名就是server3.example.com ，ip地址也是在172.25.3.0/24网段。

下面的实验中，我的练习环境是使用的172.25.0.0/24网段，使用的编号是0，所以我使用的域名也是server0.example.com， desktop0.example.com， 如果实际你练习或考试使用的网段是其他网段，比如14网段，那就改成server14.server0.com，这里我再重复了一遍。

注意事项
===========

一定要等classroom完全启动完了，再启动desktop和server。

配置 SELinux
=================

确保 SELinux 处于强制启用模式。



配置 SSH 访问试题概述：
===========================

按以下要求配置 SSH 访问：

- 用户能够从域 group0.example.com 内的客户端 SSH 远程访问您的两个虚拟机系统
- 在域 alv.pub 内的客户端不能访问您的两个虚拟机系统




自定义用户环境（别名设置） 试题概述：
==============================================


在系统 server0 和 desktop0 上创建自定义命令为 qstat，此自定义命令将执行以下命令：

/bin/ps -Ao pid,tt,user,fname,rsz 此命令对系统中所有用户有效。


配置防火墙端口转发试题概述：
==============================================

在系统 server0 配置端口转发，要求如下：

- 在 172.25.0.0/24 网络中的系统，访问 server0 的本地端口 5423 将被转发到 80

- 此设置必须永久有效



配置链路聚合试题概述：
==============================================

在server0和 desktop0 之间按以下要求配置一个链路：

- 此链路使用接口 eth1 和 eth2
- 此链路在一个接口失效时仍然能工作；
- 此链路在 server0 使用下面的地址 172.16.0.20/255.255.255.0
- 此链路在 dekstop0 使用下面的地址 172.16.0.25/255.255.255.0
- 此链路在系统重启之后依然保持正常状态



配置 IPv6 地址试题概述：
==============================================

在您的考试系统上配置接口 eth0 使用下列 IPv6 地址：

- server0 上的地址应该是 2003:ac18::305/64
- desktop0 上的地址应该是 2003:ac18::306/64
- 两个系统必须能与网络 2003:ac18/64 内的系统通信
- 地址必须在重启后依旧生效
- 两个系统必须保持当前的 IPv4 地址并能通信

配置本地邮件服务试题概述：
==============================================

在系统 server0 和 desktop0 上配置邮件服务，满足以下要求：

- 这些系统不接收外部发送来的邮件
- 在这些系统上本地发送的任何邮件都会自动路由到 smtp0.example.com
- 从这些系统上发送的邮件显示来自于 desktop0.example.com
- 您可以通过发送邮件到本地用户student来测试您的配置，系统
- smtp0.example.com	已经配置把此用户的邮件转到下列URL：http://smtp0.example.com/received_mail/3



通过 Samba 发布共享目录试题概述：
==============================================

在 server0 上通过 SMB 共享/common 目录：

- 您的 SMB 服务器必须是 STAFF 工作组的一个成员
- 共享名必须为 common
- 只有 group0.example.com 域内的客户端可以访问 common 共享
- common 必须是可以浏览的
- 用户 harry 必须能够读取共享中的内容，如果需要的话，验证的密码是 redhat



配置多用户 Samba 挂载试题概述：
==============================================

在 system1 通过 SMB 共享目录/devops，并满足以下要求：

- 共享名为 devops
- 共享目录 devops 只能被 groupX.example.com 域中的客户端使用
- 共享目录 devops 必须可以被浏览
- 用户 kenji 必须能以读的方式访问此共享，该问密码是 redhat
- 用户 chihiro 必须能以读写的方式访问此共享，访问密码是 redhat
- 此共享永久挂载在 desktop0.groupX.example.com 上的/mnt/dev 目录，并使用用户kenji 作为认证，任何用户可以通过用户 chihiro 来临时获取写的权限


配置 NFS 共享服务试题概述：
==============================================


在 system1 配置 NFS 服务，要求如下：

- 以只读的方式共享目录/public，同时只能被 groupX.example.com 域中的系统访问
- 以读写的方式共享目录/protected，能被 groupX.example.com 域中的系统访问
- 访问/protected 需要通过 Kerberos 安全加密，您可以使用下面 URL 提供的密钥： http://classroom.example.com/pub/keytabs/server0.keytab
- 目录/protected 应该包含名为 project 拥有人为 ldapuser0 的子目录
- 用户 ldapuser0 能以读写方式访问/protected/project


挂载 NFS 共享试题概述：
==============================================

在 desktop0 上挂载一个来自 system1.goup3.exmaple.com 的共享，并符合下列要求：

- /public 挂载在下面的目录上/mnt/nfsmount
- /protected 挂载在下面的目录上/mnt/nfssecure 并使用安全的方式，密钥下载 URL： http://classroom.example.com/pub/keytabs/desktop0.keytab
- 用户 ldapuser0 能够在/mnt/nfssecure/project 上创建文件
- 这些文件系统在系统启动时自动挂载

ldapuser0的密码是 kerberos


实现一个 web 服务器试题概述：
==============================================

为 http://server0.example.com 配置 Web 服务器：

- 从http://smtp0.example.com/materials/station.html 下载一个主页文件，并将该文件重命名为 index.html
- 将文件 index.html 拷贝到您的 web 服务器的 DocumentRoot 目录下
- 不要对文件 index.html 的内容进行任何修改
- 来自于 group0.example.com 域的客户端可以访问此 Web 服务
- 来自于 alv.pub 域的客户端拒绝访问此 Web 服务





配置安全 web 服务试题概述：
==============================================


为站点 http://server0.example.com 配置TLS 加密

- 一个已签名证书从http://classroom/pub/tls/certs/www0.crt获取
- 此证书的密钥从http://classroom/pub/tls/private/www0.key获取
- 此证书的签名授权信息http://classroom/pub/example-ca.crt获取



配置虚拟主机试题概述：
==============================================

在 system1 上扩展您的 web 服务器，为站点 http://www.groupX.example.com 创建一个虚拟主机，然后执行下述步骤：

- 设置 DocumentRoot 为/var/www/virtual
- 从 http://smtp0.example.com/materials/www.html 下载文件并重命名为index.html
- 不要对文件 index.html 的内容做任何修改
- 将文件 index.html 放到虚拟主机的 DocumentRoot 目录下
- 确保 harry 用户能够在/var/www/virtual 目录下创建文件




配置 web 内容的访问
=========================



在 server0 上的 web 服务器的 DocumentRoot 目录下创建一个名为 secret 的目录，要求如下：

- 从 http://rhgls.domain1.example.com/materials/private.html 下载一个文件副本到这个目录，并且重命名为 index.html，不要对这个文件的内容做任何修改。
- 从 server0 上，任何人都可以浏览 secret 的内容，但是从其它系统不能访问这个目录的内容




实现动态 WEB 内容
======================

试题概述：

在 system1 上配置提供动态 Web 内容，要求如下：

- 动态内容由名为 alt.groupX.example.com 的虚拟主机提供
- 虚拟主机侦听在端口 8998
- 从 http://smtp0.example.com/materials/webinfo.wsgi 下载一个脚本， 然后放在适当的位置，无论如何不要修改此文件的内容
- 客户端访问 http://alt.groupX.example.com:8998 可接收到动态生成的 Web 页
- 此 http://alt.groupX.example.com:8998/必须能被 groupX.example.com 域内的所有系统访问


创建一个脚本试题概述：
==============================================

在 system1 上创建一个名为/root/foo.sh 的脚本，让其提供下列特性：

- 当运行/root/foo.sh redhat，输出为 fedora
- 当运行/root/foo.sh fedora，输出为 redhat
- 当没有任何参数或者参数不是 redhat 或者 fedora 时，其错误输出产生以下的信息：
    /root/foo.sh redhat|fedora




创建一个添加用户的脚本试题概述：
==============================================

在 system1 上创建一个脚本，名为/root/batchusers，此脚本能实现为系统 system1 创建本地用户，并且这些用户的用户名来自一个包含用户名的文件，同时满足下列要求：

- 此脚本要求提供一个参数，此参数就是包含用户名列表的文件
- 如果没有提供参数，此脚本应该给出下面的提示信息	Usage: /root/batchusers
    <userfile> 然后退出并返回相应的值

- 如果提供一个不存在的文件名，此脚本应该给出下面的提示信息 Input file not found 然后退出并返回相应的值
- 创建的用户登陆 Shell 为/bin/false，此脚本不需要为用户设置密码
- 您可以从下面的 URL 获取用户名列表作为测试用： http://smtp0.example.com/materials/userlist


配置 iSCSI 服务端试题概述：
==============================================

配置 system1 提供 iSCSI 服务，磁盘名为 iqn.2016-02.com.example.groupX:system1，并符合下列要求：

- 服务端口为 3260
- 使用 iscsi_store 作其后端卷，其大小为 3GiB
- 此服务只能被 desktop0.groupX.example.com 访问


配置 iSCSI 客户端试题概述：
==============================================

配置 desktop0 使其能连接 system1 上提供的 iqn.2016-02.com.example.groupX:system1，并符合以下要求：

- iSCSI 设备在系统启动的期间自动加载
- 块设备 iSCSI 上包含一个大小为 2100MiB 的分区，并格式化为 ext4 文件系统,此分区挂载在/mnt/data 上，同时在系统启动的期间自动挂载

配置一个数据库试题概述：
==============================================

在 system1 上创建一个 MariaDB 数据库，名为 Contacts，并符合以下条件：

- 数据库应该包含来自数据库复制的内容，复制文件的 URL 为： http://smtp0.example.com/materials/users.sql
- 数据库只能被 localhost 访问
- 除了 root 用户，此数据库只能被用户 Raikon 查询，此用户密码为 redhat
- root 用户的密码为 redhat，同时不允许空密码登陆。


数据库查询（填空） 试题概述：
==============================================

在系统 system1 上使用数据库 Contacts，并使用相应的 SQL 查询以回答下列问题：

- 密码是 solicitous 的人的名字？

- 有多少人的姓名是 Barbara 同时居住在 Sunnyvale？

