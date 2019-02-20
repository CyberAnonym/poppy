snmp
#########

参考资料：https://kb.op5.com/display/HOWTOs/Configure+a+Linux+server+for+SNMP+monitoring#sthash.yYwhEpzs.dpbs

snmp， 简单网络管理协议

1. SNMP描述&说明
====================

SNMP 是一个协议用来管理网络上的节点，（包括工作站，路由器，交换机，集线器和其他的外围设备）。SNMP是一个应用协议，使用UDP封装进行传输。UDP是一个无连接的传输层协议，在OSI模型中为第四层协议，提供简单的可靠的传输服务。SNMP使网络管理者能够管理网络性能，发现和解决网络问题，规划网络的增长。

当前，定义了三个版本的网络管理协议，SNMP v1，SNMP v2，SNMP v3。SNMP v1，v2有很多共同的特征，SNMP v3 在先前的版本地基础上增加了安全和远程配置能力 。为了解决不同版本的兼容性问题，RFC3584定义了共存策略。

SNMP v1 是最初实施SNMP协议。SNMPv1 运行在像UDP，IP，OSI无连接网络服务（CLNS），DDP（AppTalk Datagram-Delivery）,IPX(Novell Internet Packet Exchange)之上.SNMPv1 广泛使用成为因特网上实际的网络管理协议。

SNMP 是一种简单的request/response协议。网络管理系统发出一个请求，被管理设备返回响应。这些行为由四种协议操作组成：Get，GetNext，Set 和Trap。Get操作使NMS来获取agent的一个或多个对象实例。如果agent返回get操作不能提供列表所有对象实例的值，就不能提供任何值。GetNext 操作是NMS用来从agent表中获取表中下一个对象实例。Set操作是NMS用来设置agent对象实例的值。trap操作用于agent向NMS通告有意义的事件。

SNMP v2是1993年设计的，是v1版的演进版。Get，GetNext和Set操作相同于SNMPv1。然而，SNMPv2 增加和加强了一些协议操作。在SNMPv2中，如果在get-request中需要多个请求值，如果有一个不存在，请求照样会被正常执行。而在SNMPv1中将响应一个错误消息。在 v1，Trap 消息和其他几个操作消息的PDU不同。v2版本简化了trap消息，使trap和其他的get和set消息格式相同。

SNMPv2还定义了两个新的协议操作：GetBulk和Inform。GetBulk 操作被用于NMS高效的获取大量的块数据，如表中一行中的多列(一个UDP数据包应答)。GetBulk 将请求返回的响应消息尽量多的返回。Inform操作允许一个NMS 来发送trap消息给其他的NMS，再接收响应。在SNMPv2中，如果agent响应GetBulk操作不能提供list中全部的变量的值，则提供部分的结果。

SNMP v2在安全策略演变时存在多个变种,实际存在多个SNMP v2的消息格式。SNMPv2各个变种之间的不同在于安全的实施。因而各个SNMP v2变种之间的PDU都有相同的格式，而总的消息格式又都不同。

现在，SNMP v3 在前面的版本上增加了安全能力和远程配置能力，SNMPv3结构为消息安全和VACM（View-based Access Control Model）引入了USM（User-based Security Model）。这个结构支持同时使用不同的安全机制，接入控制，消息处理模型。SNMP v3 也引入使用SNMP SET命令动态配置 SNMP agent而不失MIB对象代表agent配置。

这些动态配置支持能够增加，删除，修改和配置远程或本地实体。


有三个可能的安全级别: noAuthNoPriv, authNoPriv, 和 authPriv。
    noAuthNoPriv 级别指明了没有认证或私密性被执行.

    authNoPriv 级别指明了认证被执行但没有私密性被执行.

    authPriv 级别指明了认证和私密性都被执行.

auth---认证 支持MD5 or SHA;
priv---加密 支持DES or RSA;

通用的SNMPv3消息格式遵循相同的消息封装格式包含一个头和一个被封装PDU。 头部区域，被分成两个部分，一部分处理安全，和另外一部份与安全无关的部分。与安全无关部分所有的SNMPv3部分是相同的，而使用安全相关部分被设计成各种的SNMPv3安全模型，被SNMP内的安全模型处理。



SNMPv1只使用一种安全策略，团体名。团体名和密码相似。Agent能够被设置回答那些团体名能够被接受的Manager的查询。在很容易让人截取得到团体名或密码。SNMPv2增加了不少额外的安全。首先所有的包信息除了目的地址，其他都被加密。在加密的数据中包括团体名和源IP地址。Agent 能够解开加密包并使用收到的团体名和源IP地址使请求有效。SNMPv3提供三重的安全机制。最高层是认证和私密。中间层提供认证而没有私密和底层没有任何的认证机制和私密

SNMPV1,V2均采用明文传送，SNMPV3采用加密传送，也就是说对应SNMPV1,V2用抓包工具能在数据包中直接看到团体名。

如下团体名为：snmpv2, 显然抓包可以抓到


2. 安装snmp
================

.. code-block:: bash

    yum -y install net-snmp net-snmp-utils


查看snmp版本号

.. code-block:: bash

    snmpd -v


3. snmp的常用配置
=======================

3.1 配置解释
--------------------

这里我们先查看一下snmpd的配置。

.. code-block:: bash

    $ grep -vE '^$|^#' /etc/snmp/snmpd.conf
    com2sec notConfigUser  default       public
    group   notConfigGroup v1           notConfigUser
    group   notConfigGroup v2c           notConfigUser
    view    systemview    included   .1.3.6.1.2.1.1
    view    systemview    included   .1.3.6.1.2.1.25.1.1
    access  notConfigGroup ""      any       noauth    exact  systemview none none
    syslocation Unknown (edit /etc/snmp/snmpd.conf)
    syscontact Root <root@localhost> (configure /etc/snmp/snmp.local.conf)
    dontLogTCPWrappersConnects yes


下面我们来了解下这些配置,首先是com2sec这一行

com2sec 这一行的内容表示定义一个团体名（community）public到安全名(security name)notConfigUser. defaults表示范围是默认范围，即对所有地址开放，可将default改成具体ip。 团体名public相当于一个密码，客户端通过这个团体名来获取信息。

group这一行的内容表示将安全名notConfigUser映射到一个noConfigGroup这个组，这个组使用的协议是v1，下面一行使用的协议是v2c.

view开头的行，表示定义定一个视图，这里是视图名为systemview，后面是动作，这里的动作是included，就是包含，最后一列就是要包含的内容，也就是该视图的权限范围。

access 这一行就是将权限分配给组，各列的的值的分别代表group  context sec.model sec.level prefix read   write  notif ， 上面的配置表示我们在读的权限上是给了systemview,写的权限没有给，验证方式是noauth。

后面的 syslocation syscontact 就是关于本机信息我们自己的填写标识了。

上面这些配置，都是SNMP v1和SNMPv 2的配置。



下面我们修改/etc/snmp/snmpd.conf ，原配置中我们修改的那一行，最后一列数据默认是public，这里我们改成了sophiroth，后续访问该服务器的snmp服务时，也需要通过sophiroth这个标识来验证获取数据。

.. code-block:: bash

    $ vim /etc/snmp/snmpd.conf
    com2sec notConfigUser  default       sophiroth


4. 启动snmp服务
===================

.. code-block:: bash

    systemctl start snmpd.service
    systemctl enable snmpd.service


如果系统启用了防火墙，还需要根据需求配置防火墙策略,端口是161




5. 查看通过SNMP能看到的东西
==============================

刚才我们是在test2上安装的，现在我们在test1上安装了客户端工具，去查看一下test1

.. code-block:: bash

    [root@test1 ~]# snmpwalk  -v2c -c sophiroth test2
    SNMPv2-MIB::sysDescr.0 = STRING: Linux test2.alv.pub 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC 2017 x86_64
    SNMPv2-MIB::sysObjectID.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
    DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (504971) 1:24:09.71
    SNMPv2-MIB::sysContact.0 = STRING: Root <root@localhost> (configure /etc/snmp/snmp.local.conf)
    SNMPv2-MIB::sysName.0 = STRING: test2.alv.pub
    SNMPv2-MIB::sysLocation.0 = STRING: Unknown (edit /etc/snmp/snmpd.conf)
    SNMPv2-MIB::sysORLastChange.0 = Timeticks: (1) 0:00:00.01
    SNMPv2-MIB::sysORID.1 = OID: SNMP-MPD-MIB::snmpMPDCompliance
    SNMPv2-MIB::sysORID.2 = OID: SNMP-USER-BASED-SM-MIB::usmMIBCompliance
    SNMPv2-MIB::sysORID.3 = OID: SNMP-FRAMEWORK-MIB::snmpFrameworkMIBCompliance
    SNMPv2-MIB::sysORID.4 = OID: SNMPv2-MIB::snmpMIB
    SNMPv2-MIB::sysORID.5 = OID: TCP-MIB::tcpMIB
    SNMPv2-MIB::sysORID.6 = OID: IP-MIB::ip
    SNMPv2-MIB::sysORID.7 = OID: UDP-MIB::udpMIB
    SNMPv2-MIB::sysORID.8 = OID: SNMP-VIEW-BASED-ACM-MIB::vacmBasicGroup
    SNMPv2-MIB::sysORID.9 = OID: SNMP-NOTIFICATION-MIB::snmpNotifyFullCompliance
    SNMPv2-MIB::sysORID.10 = OID: NOTIFICATION-LOG-MIB::notificationLogMIB
    SNMPv2-MIB::sysORDescr.1 = STRING: The MIB for Message Processing and Dispatching.
    SNMPv2-MIB::sysORDescr.2 = STRING: The management information definitions for the SNMP User-based Security Model.
    SNMPv2-MIB::sysORDescr.3 = STRING: The SNMP Management Architecture MIB.
    SNMPv2-MIB::sysORDescr.4 = STRING: The MIB module for SNMPv2 entities
    SNMPv2-MIB::sysORDescr.5 = STRING: The MIB module for managing TCP implementations
    SNMPv2-MIB::sysORDescr.6 = STRING: The MIB module for managing IP and ICMP implementations
    SNMPv2-MIB::sysORDescr.7 = STRING: The MIB module for managing UDP implementations
    SNMPv2-MIB::sysORDescr.8 = STRING: View-based Access Control Model for SNMP.
    SNMPv2-MIB::sysORDescr.9 = STRING: The MIB modules for managing SNMP Notification, plus filtering.
    SNMPv2-MIB::sysORDescr.10 = STRING: The MIB module for logging SNMP Notifications.
    SNMPv2-MIB::sysORUpTime.1 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.2 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.3 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.4 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.5 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.6 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.7 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.8 = Timeticks: (0) 0:00:00.00
    SNMPv2-MIB::sysORUpTime.9 = Timeticks: (1) 0:00:00.01
    SNMPv2-MIB::sysORUpTime.10 = Timeticks: (1) 0:00:00.01
    HOST-RESOURCES-MIB::hrSystemUptime.0 = Timeticks: (5956198) 16:32:41.98
    HOST-RESOURCES-MIB::hrSystemUptime.0 = No more variables left in this MIB View (It is past the end of the MIB tree)

6. 修改配置，使客户端能获取更多信息
=========================================

下面我们指定能访问我们的snmp服务的ip地址，指定只允许192.168.3.42来访问。

access那一行的倒数第三列改成了all，使得客户端可以获取更多信息了。

.. code-block:: bash

    $ vim /etc/snmp/snmpd.conf
    com2sec notConfigUser  192.168.3.42  publicsvr
    access  notConfigGroup ""      any       noauth    exact  all none none
    view all    included  .1



7. 通过OID查看主机信息
==============================

.. code-block:: bash

    [root@test1 ~]# snmpwalk  -v2c -c sophiroth test2  1.3.6.1.2.1.1.5.0
    SNMPv2-MIB::sysName.0 = STRING: test2.alv.pub


snmpwalk 命令参数


–h  显示帮助

–v  1|2c|3  指定SNMP协议版本

–V  显示当前SNMPWALK命令行版本

–r  RETRIES     指定重试次数，默认为0次。

–t  TIMEOUT    指定每次请求的等待超时时间，单为秒，默认为3秒。

–Cc 指定当在WALK时，如果发现OID负增长将是否继续WALK。

–c  COMMUNITY    指定共同体字符串

–l  LEVEL    指定安全级别：noAuthNoPriv|authNoPriv|authPriv

–u  USER-NAME    安全名字

–a  PROTOCOL    验证协议：MD5|SHA。如果-l指定为authNoPriv或authPriv时才需要。

–A  PASSPHRASE    验证字符串。如果-l指定为authNoPriv或authPriv时才需要。

–x  PROTOCOL    加密协议：DES。如果-l指定为authPriv时才需要。



8. snmpv3用户，并设置认证以及加密方式
==========================================

.. note::

    为了安全，验证密码和加密密码不要设置相同。


8.1配置之前，要先停止服务
-------------------------------

.. code-block:: bash

    [root@test2 ~]# systemctl stop snmpd
    [root@test2 ~]#


8.2 然后开始新增snmpv3用户，并设置认证及加密方式
-----------------------------------------------------


.. code-block:: bash

    [root@test2 ~]# net-snmp-create-v3-user  -A alvinAuthPassword -a MD5 -X alvinEcryptPassword -x DES -ro alvin
    adding the following line to /var/lib/net-snmp/snmpd.conf:
       createUser alvin MD5 "alvinAuthPassword" DES alvinEcryptPassword
    adding the following line to /etc/snmp/snmpd.conf:
       rouser alvin




net-snmp-create-v3-user命令参数解释如下

       --version
              displays the net-snmp version number

       -ro    creates a user with read-only permissions

       -A authpass
              specifies the authentication password

       -a MD5|SHA
              specifies the authentication password hashing algorithm

       -X privpass
              specifies the encryption password

       -x DES|AES
              specifies the encryption algorithm



8.3 客户端验证
-------------------


.. code-block:: bash

    [root@test1 ~]# snmpwalk -v3  -lauthNoPriv -u alvin -aMD5 -A 'alvinAuthPassword' -X alvinEcryptPassword test2 |wc -l
    4488



8.4 删除SNMPv3账户
-------------------------


先停止服务

.. code-block:: bash

    systemctl stop snmpd

SNMPv3 账户信息被包含在两个文件之中。删除账户即删除这个文件中的信息即可。

这里我们删除/var/lib/net-snmp/snmpd.conf  中的这一行

.. code-block:: bash

    $ vim  /var/lib/net-snmp/snmpd.conf
    usmUser 1 3 0x80001f8880dc0ee4475ccd6c5c00000000 "snmpv3user" "snmpv3user" NULL .1.3.6.1.6.3.10.1.1.2 0x680aefdd2947e0d086b1a0c0227e2692 .1.3.6.1.6.3.10.1.2.2 0x680aefdd2947e0d086b1a0c0227e2692 ""

然后删除/etc/snmp/snmpd.conf 中的这一行

.. code-block:: bash

    $ vim /etc/snmp/snmpd.conf

然后启动服务

.. code-block:: bash

    $ systemctl start snmpd



9. SNMPV3禁止不安全的接入方式
=====================================

按照上述文档内容我配置了SNMPV3的用户验证之后，客户端可以通过-lauthNoPriv也就是验证但不加密的方式访问， 但出于安全需求我们要禁止不加密。也就是禁止authNoPriv这个级别

所以这里我们要在配置文件里做如下配置.

当前我们在/etc/snmp/snmpd.conf里配置的最后一行是rouser alvin, 这是我们创建用户的时候自动添加进去的， rouser 表示 ro user,就是只读用户，后面自然就是我们的用户名了。

.. code-block:: bash

    [root@test2 ~]# tail -1 /etc/snmp/snmpd.conf
    rouser alvin

但实际上，这一行后面还可以继续添加参数， 可参考这种配置

    .. code-block:: bash

        /etc/snmp/snmpd.conf:

        # Allow user 'auth_none' read-only access to the entire SNMP tree
        #        user           mode      subtree
        rouser   auth_none      noauth    .1
        rouser   auth_sha       auth      .1
        rouser   auth_md5       auth      .1
        rouser   auth_sha_des   priv      .1
        rouser   auth_sha_aes   priv      .1
        rouser   auth_md5_des   priv      .1
        rouser   auth_md5_aes   priv      .1


第三行可以设置模式，第四行设置subtree。  subtree按我的理解就是可访问的信息的范围。

从上面的例子可以看到，我们甚至可以设置 noauth


下面我们试试设置noauth

    .. code-block:: bash

        $ vim /etc/snmp/snmpd.conf
        rouser alvin noauth
        $ systemctl restart snmpd

然后在客户端试试, 就可以看到，现在不要验证也可以拿到信息了。

    .. code-block:: bash

        [root@test1 ~]# snmpwalk -v3  -lnoAuthNoPriv -u alvin    test2|wc -l
        4479

但这自然不是我们所需要的现象，我们需要必须验证，还必须加密。

默认情况是auth模式，所以我们要使用的模式是priv模式

    .. code-block:: bash

        $ vim /etc/snmp/snmpd.conf
        rouser alvin priv
        $ systemctl restart snmpd

然后再去客户端试试，发现noAuthNoPriv级别已经不行了。

    .. code-block:: bash

        [root@test1 ~]# snmpwalk -v3  -lnoAuthNoPriv -u alvin    test2|wc -l
        Error in packet.
        Reason: authorizationError (access denied to that object)
        0

那么试试验证但不加密的模式-lauthNoPriv ，这里我们设置了-lauthNoPriv，后面即使也写了-x DES -X AlvinEcryptPassword 也不行。

    .. code-block:: bash

        [root@test1 ~]# snmpwalk -v3  -lauthNoPriv -u alvin -aMD5 -A 'alvinAuthPassword' -x DES -X alvinEcryptPassword  test2|wc -l
        Error in packet.
        Reason: authorizationError (access denied to that object)
        0

现在我们试试验证同时也加密，如下结果显示，成功拿到了我们需要的信息。

    .. code-block:: bash

        [root@test1 ~]# snmpwalk -v3 -l authPriv  -u alvin -aMD5 -A 'alvinAuthPassword' -x DES -X alvinEcryptPassword  test2|wc -l
        4468

这里我们通过OID来针对性的查看一下目标服务器的总内存, 下面的命令中，最后的.1.3.6.1.2.1.25.2.2.0就是OID, 开头1前面那个点也可以去掉。

.. code-block:: bash

    [root@test1 ~]# snmpwalk -v3 -l authPriv  -u alvin -aMD5 -A 'alvinAuthPassword' -x DES -X alvinEcryptPassword  test2 .1.3.6.1.2.1.25.2.2.0
    HOST-RESOURCES-MIB::hrMemorySize.0 = INTEGER: 3881516 KBytes

OID是各个监控项的一个标识，树形分配的，比如1.3.6.1.2.1.25.2.2.0 后面去掉.2.0，使用1.3.6.1.2.1.25.2去查看，出来的内容就更多，其中就包含1.3.6.1.2.1.25.2.2.0所显示的内容。如果只输入1，那就是查看全部，因为所有的项都是在1下面的。


**查看空闲CPU百分比**

.. code-block:: bash

    [root@test1 ~]# snmpwalk -v3 -l authPriv  -u alvin -aMD5 -A 'alvinAuthPassword' -x DES -X alvinEcryptPassword  test2 1.3.6.1.4.1.2021.11.11.0
    UCD-SNMP-MIB::ssCpuIdle.0 = INTEGER: 99



常用OID列表
========================


::

    1）SNMP协议是通用的，该模板不仅可以监控HP Linux机器，还可以监控HP Windows机器。
    2）HP代理常用的OID，其它的还很多，大家去慢慢研究。
    HP阵列卡状态：1.3.6.1.4.1.232.3.2.2.1.1.6
    物理磁盘状态：1.3.6.1.4.1.232.3.2.5.1.1.6
    逻辑磁盘状态：1.3.6.1.4.1.232.3.2.3.1.1.4
    HP部件温度：1.3.6.1.4.1.232.6.2.6.8.1.4
    snmpwalk -v2c -c public 10.17.71.25 .1.3.6.1.2.1.25.2.2  查看内存总数
    SNMP监控一些常用OID的总结
    系统参数（1.3.6.1.2.1.1）
    OID 描述 备注 请求方式
    .1.3.6.1.2.1.1.1.0 获取系统基本信息 SysDesc GET
    .1.3.6.1.2.1.1.3.0 监控时间 sysUptime GET
    .1.3.6.1.2.1.1.4.0 系统联系人 sysContact GET
    .1.3.6.1.2.1.1.5.0 获取机器名 SysName GET
    .1.3.6.1.2.1.1.6.0 机器坐在位置 SysLocation GET
    .1.3.6.1.2.1.1.7.0 机器提供的服务 SysService GET
    .1.3.6.1.2.1.25.4.2.1.2 系统运行的进程列表 hrSWRunName WALK
    .1.3.6.1.2.1.25.6.3.1.2 系统安装的软件列表 hrSWInstalledName WALK

    网络接口（1.3.6.1.2.1.2）
    OID 描述 备注 请求方式
    .1.3.6.1.2.1.2.1.0 网络接口的数目 IfNumber GET
    .1.3.6.1.2.1.2.2.1.2 网络接口信息描述 IfDescr WALK
    .1.3.6.1.2.1.2.2.1.3 网络接口类型 IfType WALK
    .1.3.6.1.2.1.2.2.1.4 接口发送和接收的最大IP数据报[BYTE] IfMTU WALK
    .1.3.6.1.2.1.2.2.1.5 接口当前带宽[bps] IfSpeed WALK
    .1.3.6.1.2.1.2.2.1.6 接口的物理地址 IfPhysAddress WALK
    .1.3.6.1.2.1.2.2.1.8 接口当前操作状态[up|down] IfOperStatus WALK
    .1.3.6.1.2.1.2.2.1.10 接口收到的字节数 IfInOctet WALK
    .1.3.6.1.2.1.2.2.1.16 接口发送的字节数 IfOutOctet WALK
    .1.3.6.1.2.1.2.2.1.11 接口收到的数据包个数 IfInUcastPkts WALK
    .1.3.6.1.2.1.2.2.1.17 接口发送的数据包个数 IfOutUcastPkts WALK

    CPU及负载
    OID 描述 备注 请求方式
    . 1.3.6.1.4.1.2021.11.9.0 用户CPU百分比 ssCpuUser GET
    . 1.3.6.1.4.1.2021.11.10.0 系统CPU百分比 ssCpuSystem GET
    . 1.3.6.1.4.1.2021.11.11.0 空闲CPU百分比 ssCpuIdle GET
    . 1.3.6.1.4.1.2021.11.50.0 原始用户CPU使用时间 ssCpuRawUser GET
    .1.3.6.1.4.1.2021.11.51.0 原始nice占用时间 ssCpuRawNice GET
    . 1.3.6.1.4.1.2021.11.52.0 原始系统CPU使用时间 ssCpuRawSystem. GET
    . 1.3.6.1.4.1.2021.11.53.0 原始CPU空闲时间 ssCpuRawIdle GET
    . 1.3.6.1.2.1.25.3.3.1.2 CPU的当前负载，N个核就有N个负载 hrProcessorLoad WALK
    . 1.3.6.1.4.1.2021.11.3.0 ssSwapIn GET
    . 1.3.6.1.4.1.2021.11.4.0 SsSwapOut GET
    . 1.3.6.1.4.1.2021.11.5.0 ssIOSent GET
    . 1.3.6.1.4.1.2021.11.6.0 ssIOReceive GET
    . 1.3.6.1.4.1.2021.11.7.0 ssSysInterrupts GET
    . 1.3.6.1.4.1.2021.11.8.0 ssSysContext GET
    . 1.3.6.1.4.1.2021.11.54.0 ssCpuRawWait GET
    . 1.3.6.1.4.1.2021.11.56.0 ssCpuRawInterrupt GET
    . 1.3.6.1.4.1.2021.11.57.0 ssIORawSent GET
    . 1.3.6.1.4.1.2021.11.58.0 ssIORawReceived GET
    . 1.3.6.1.4.1.2021.11.59.0 ssRawInterrupts GET
    . 1.3.6.1.4.1.2021.11.60.0 ssRawContexts GET
    . 1.3.6.1.4.1.2021.11.61.0 ssCpuRawSoftIRQ GET
    . 1.3.6.1.4.1.2021.11.62.0 ssRawSwapIn. GET
    . 1.3.6.1.4.1.2021.11.63.0 ssRawSwapOut GET
    .1.3.6.1.4.1.2021.10.1.3.1 Load5 GET
    .1.3.6.1.4.1.2021.10.1.3.2 Load10 GET
    .1.3.6.1.4.1.2021.10.1.3.3 Load15 GET

    内存及磁盘（1.3.6.1.2.1.25）
    OID 描述 备注 请求方式
    .1.3.6.1.2.1.25.2.2.0 获取内存总大小 hrMemorySize GET
    .1.3.6.1.2.1.25.2.3.1.1 存储设备编号 hrStorageIndex WALK
    .1.3.6.1.2.1.25.2.3.1.2 存储设备类型 hrStorageType[OID] WALK
    .1.3.6.1.2.1.25.2.3.1.3 存储设备描述 hrStorageDescr WALK
    .1.3.6.1.2.1.25.2.3.1.4 簇的大小 hrStorageAllocationUnits WALK
    .1.3.6.1.2.1.25.2.3.1.5 簇的的数目 hrStorageSize WALK
    .1.3.6.1.2.1.25.2.3.1.6 使用多少，跟总容量相除就是占用率 hrStorageUsed WALK
    .1.3.6.1.4.1.2021.4.3.0 Total Swap Size(虚拟内存) memTotalSwap GET
    .1.3.6.1.4.1.2021.4.4.0 Available Swap Space memAvailSwap GET
    .1.3.6.1.4.1.2021.4.5.0 Total RAM in machine memTotalReal GET
    .1.3.6.1.4.1.2021.4.6.0 Total RAM Free memAvailReal GET
    .1.3.6.1.4.1.2021.4.11.0 Total RAM +SWAP Free memTotalFree GET
    .1.3.6.1.4.1.2021.4.13.0 Total RAM Shared memShared GET
    .1.3.6.1.4.1.2021.4.14.0 Total RAM Buffered memBuffer GET
    .1.3.6.1.4.1.2021.4.15.0 Total Cached Memory memCached GET
    .1.3.6.1.4.1.2021.9.1.2 Path where the disk is mounted dskPath WALK
    .1.3.6.1.4.1.2021.9.1.3 Path of the device for the partition dskDevice WALK
    .1.3.6.1.4.1.2021.9.1.6 Total size of the disk/partion (kBytes) dskTotal WALK
    .1.3.6.1.4.1.2021.9.1.7 Available space on the disk dskAvail WALK
    .1.3.6.1.4.1.2021.9.1.8 Used space on the disk dskUsed WALK
    .1.3.6.1.4.1.2021.9.1.9 Percentage of space used on disk dskPercent WALK
    .1.3.6.1.4.1.2021.9.1.10 Percentage of inodes used on disk dskPercentNode WALK
    System Group
    sysDescr 1.3.6.1.2.1.1.1
    sysObjectID 1.3.6.1.2.1.1.2
    sysUpTime 1.3.6.1.2.1.1.3
    sysContact 1.3.6.1.2.1.1.4
    sysName 1.3.6.1.2.1.1.5
    sysLocation 1.3.6.1.2.1.1.6
    sysServices 1.3.6.1.2.1.1.7
    Interfaces Group
    ifNumber 1.3.6.1.2.1.2.1
    ifTable 1.3.6.1.2.1.2.2
    ifEntry 1.3.6.1.2.1.2.2.1
    ifIndex 1.3.6.1.2.1.2.2.1.1
    ifDescr 1.3.6.1.2.1.2.2.1.2
    ifType 1.3.6.1.2.1.2.2.1.3
    ifMtu 1.3.6.1.2.1.2.2.1.4
    ifSpeed 1.3.6.1.2.1.2.2.1.5
    ifPhysAddress 1.3.6.1.2.1.2.2.1.6
    ifAdminStatus 1.3.6.1.2.1.2.2.1.7
    ifOperStatus 1.3.6.1.2.1.2.2.1.8
    ifLastChange 1.3.6.1.2.1.2.2.1.9
    ifInOctets 1.3.6.1.2.1.2.2.1.10
    ifInUcastPkts 1.3.6.1.2.1.2.2.1.11
    ifInNUcastPkts 1.3.6.1.2.1.2.2.1.12
    ifInDiscards 1.3.6.1.2.1.2.2.1.13
    ifInErrors 1.3.6.1.2.1.2.2.1.14
    ifInUnknownProtos 1.3.6.1.2.1.2.2.1.15
    ifOutOctets 1.3.6.1.2.1.2.2.1.16
    ifOutUcastPkts 1.3.6.1.2.1.2.2.1.17
    ifOutNUcastPkts 1.3.6.1.2.1.2.2.1.18
    ifOutDiscards 1.3.6.1.2.1.2.2.1.19
    ifOutErrors 1.3.6.1.2.1.2.2.1.20
    ifOutQLen 1.3.6.1.2.1.2.2.1.21
    ifSpecific 1.3.6.1.2.1.2.2.1.22
    IP Group
    ipForwarding 1.3.6.1.2.1.4.1
    ipDefaultTTL 1.3.6.1.2.1.4.2
    ipInReceives 1.3.6.1.2.1.4.3
    ipInHdrErrors 1.3.6.1.2.1.4.4
    ipInAddrErrors 1.3.6.1.2.1.4.5
    ipForwDatagrams 1.3.6.1.2.1.4.6
    ipInUnknownProtos 1.3.6.1.2.1.4.7
    ipInDiscards 1.3.6.1.2.1.4.8
    ipInDelivers 1.3.6.1.2.1.4.9
    ipOutRequests 1.3.6.1.2.1.4.10
    ipOutDiscards 1.3.6.1.2.1.4.11
    ipOutNoRoutes 1.3.6.1.2.1.4.12
    ipReasmTimeout 1.3.6.1.2.1.4.13
    ipReasmReqds 1.3.6.1.2.1.4.14
    ipReasmOKs 1.3.6.1.2.1.4.15
    ipReasmFails 1.3.6.1.2.1.4.16
    ipFragsOKs 1.3.6.1.2.1.4.17
    ipFragsFails 1.3.6.1.2.1.4.18
    ipFragCreates 1.3.6.1.2.1.4.19
    ipAddrTable 1.3.6.1.2.1.4.20
    ipAddrEntry 1.3.6.1.2.1.4.20.1
    ipAdEntAddr 1.3.6.1.2.1.4.20.1.1
    ipAdEntIfIndex 1.3.6.1.2.1.4.20.1.2
    ipAdEntNetMask 1.3.6.1.2.1.4.20.1.3
    ipAdEntBcastAddr 1.3.6.1.2.1.4.20.1.4
    ipAdEntReasmMaxSize 1.3.6.1.2.1.4.20.1.5
    ICMP Group
    icmpInMsgs 1.3.6.1.2.1.5.1
    icmpInErrors 1.3.6.1.2.1.5.2
    icmpInDestUnreachs 1.3.6.1.2.1.5.3
    icmpInTimeExcds 1.3.6.1.2.1.5.4
    icmpInParmProbs 1.3.6.1.2.1.5.5
    icmpInSrcQuenchs 1.3.6.1.2.1.5.6
    icmpInRedirects 1.3.6.1.2.1.5.7
    icmpInEchos 1.3.6.1.2.1.5.8
    icmpInEchoReps 1.3.6.1.2.1.5.9
    icmpInTimestamps 1.3.6.1.2.1.5.10
    icmpInTimestampReps 1.3.6.1.2.1.5.11
    icmpInAddrMasks 1.3.6.1.2.1.5.12
    icmpInAddrMaskReps 1.3.6.1.2.1.5.13
    icmpOutMsgs 1.3.6.1.2.1.5.14
    icmpOutErrors 1.3.6.1.2.1.5.15
    icmpOutDestUnreachs 1.3.6.1.2.1.5.16
    icmpOutTimeExcds 1.3.6.1.2.1.5.17
    icmpOutParmProbs 1.3.6.1.2.1.5.18
    icmpOutSrcQuenchs 1.3.6.1.2.1.5.19
    icmpOutRedirects 1.3.6.1.2.1.5.20
    icmpOutEchos 1.3.6.1.2.1.5.21
    icmpOutEchoReps 1.3.6.1.2.1.5.22
    icmpOutTimestamps 1.3.6.1.2.1.5.23
    icmpOutTimestampReps 1.3.6.1.2.1.5.24
    icmpOutAddrMasks 1.3.6.1.2.1.5.25
    icmpOutAddrMaskReps 1.3.6.1.2.1.5.26
    TCP Group
    tcpRtoAlgorithm 1.3.6.1.2.1.6.1
    tcpRtoMin 1.3.6.1.2.1.6.2
    tcpRtoMax 1.3.6.1.2.1.6.3
    tcpMaxConn 1.3.6.1.2.1.6.4
    tcpActiveOpens 1.3.6.1.2.1.6.5
    tcpPassiveOpens 1.3.6.1.2.1.6.6
    tcpAttemptFails 1.3.6.1.2.1.6.7
    tcpEstabResets 1.3.6.1.2.1.6.8
    tcpCurrEstab 1.3.6.1.2.1.6.9
    tcpInSegs 1.3.6.1.2.1.6.10
    tcpOutSegs 1.3.6.1.2.1.6.11
    tcpRetransSegs 1.3.6.1.2.1.6.12
    tcpConnTable 1.3.6.1.2.1.6.13
    tcpConnEntry 1.3.6.1.2.1.6.13.1
    tcpConnState 1.3.6.1.2.1.6.13.1.1
    tcpConnLocalAddress 1.3.6.1.2.1.6.13.1.2
    tcpConnLocalPort 1.3.6.1.2.1.6.13.1.3
    tcpConnRemAddress 1.3.6.1.2.1.6.13.1.4
    tcpConnRemPort 1.3.6.1.2.1.6.13.1.5
    tcpInErrs 1.3.6.1.2.1.6.14
    tcpOutRsts 1.3.6.1.2.1.6.15
    UDP Group
    udpInDatagrams 1.3.6.1.2.1.7.1
    udpNoPorts 1.3.6.1.2.1.7.2
    udpInErrors 1.3.6.1.2.1.7.3
    udpOutDatagrams 1.3.6.1.2.1.7.4
    udpTable 1.3.6.1.2.1.7.5
    udpEntry 1.3.6.1.2.1.7.5.1
    udpLocalAddress 1.3.6.1.2.1.7.5.1.1
    udpLocalPort 1.3.6.1.2.1.7.5.1.2
    SNMP Group
    snmpInPkts 1.3.6.1.2.1.11.1
    snmpOutPkts 1.3.6.1.2.1.11.2
    snmpInBadVersions 1.3.6.1.2.1.11.3
    snmpInBadCommunityNames 1.3.6.1.2.1.11.4
    snmpInBadCommunityUses 1.3.6.1.2.1.11.5
    snmpInASNParseErrs 1.3.6.1.2.1.11.6
    NOT USED 1.3.6.1.2.1.11.7
    snmpInTooBigs 1.3.6.1.2.1.11.8
    snmpInNoSuchNames 1.3.6.1.2.1.11.9
    snmpInBadValues 1.3.6.1.2.1.11.10
    snmpInReadOnlys 1.3.6.1.2.1.11.11
    snmpInGenErrs 1.3.6.1.2.1.11.12
    snmpInTotalReqVars 1.3.6.1.2.1.11.13
    snmpInTotalSetVars 1.3.6.1.2.1.11.14
    snmpInGetRequests 1.3.6.1.2.1.11.15
    snmpInGetNexts 1.3.6.1.2.1.11.16
    snmpInSetRequests 1.3.6.1.2.1.11.17
    snmpInGetResponses 1.3.6.1.2.1.11.18
    snmpInTraps 1.3.6.1.2.1.11.19
    snmpOutTooBigs 1.3.6.1.2.1.11.20
    snmpOutNoSuchNames 1.3.6.1.2.1.11.21
    snmpOutBadValues 1.3.6.1.2.1.11.22
    NOT USED 1.3.6.1.2.1.11.23
    snmpOutGenErrs 1.3.6.1.2.1.11.24
    snmpOutGetRequests 1.3.6.1.2.1.11.25
    snmpOutGetNexts 1.3.6.1.2.1.11.26
    snmpOutSetRequests 1.3.6.1.2.1.11.27
    snmpOutGetResponses 1.3.6.1.2.1.11.28
    snmpOutTraps 1.3.6.1.2.1.11.29
    snmpEnableAuthenTraps 1.3.6.1.2.1.11.30