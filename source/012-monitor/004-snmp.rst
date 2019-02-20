snmp
#########

参考资料：https://kb.op5.com/display/HOWTOs/Configure+a+Linux+server+for+SNMP+monitoring#sthash.yYwhEpzs.dpbs

snmp， 简单网络管理协议


SNMP 是一个协议用来管理网络上的节点，（包括工作站，路由器，交换机，集线器和其他的外围设备）。SNMP是一个应用协议，使用UDP封装进行传输。UDP是一个无连接的传输层协议，在OSI模型中为第四层协议，提供简单的可靠的传输服务。SNMP使网络管理者能够管理网络性能，发现和解决网络问题，规划网络的增长。
     当前，定义了三个版本的网络管理协议，SNMP v1，SNMP v2，SNMP v3。SNMP v1，v2有很多共同的特征，SNMP v3 在先前的版本地基础上增加了安全和远程配置能力 。为了解决不同版本的兼容性问题，RFC3584定义了共存策略。

   SNMP v1 是最初实施SNMP协议。SNMPv1 运行在像UDP，IP，OSI无连接网络服务（CLNS），DDP（AppTalk Datagram-Delivery）,IPX(Novell Internet Packet Exchange)之上.SNMPv1 广泛使用成为因特网上实际的网络管理协议。

   SNMP 是一种简单的request/response协议。网络管理系统发出一个请求，被管理设备返回响应。这些行为由四种协议操作组成：Get，GetNext，Set 和Trap。Get操作使NMS来获取agent的一个或多个对象实例。如果agent返回get操作不能提供列表所有对象实例的值，就不能提供任何值。GetNext 操作是NMS用来从agent表中获取表中下一个对象实例。Set操作是NMS用来设置agent对象实例的值。trap操作用于agent向NMS通告有意义的事件。

   SNMP v2是1993年设计的，是v1版的演进版。Get，GetNext和Set操作相同于SNMPv1。然而，SNMPv2 增加和加强了一些协议操作。在SNMPv2中，如果在get-request中需要多个请求值，如果有一个不存在，请求照样会被正常执行。而在SNMPv1中将响应一个错误消息。在 v1，Trap 消息和其他几个操作消息的PDU不同。v2版本简化了trap消息，使trap和其他的get和set消息格式相同。

SNMPv2还定义了两个新的协议操作：GetBulk和Inform。GetBulk 操作被用于NMS高效的获取大量的块数据，如表中一行中的多列(一个UDP数据包应答)。GetBulk 将请求返回的响应消息尽量多的返回。Inform操作允许一个NMS 来发送trap消息给其他的NMS，再接收响应。在SNMPv2中，如果agent响应GetBulk操作不能提供list中全部的变量的值，则提供部分的结果。

   SNMP v2在安全策略演变时存在多个变种,实际存在多个SNMP v2的消息格式。SNMPv2各个变种之间的不同在于安全的实施。因而各个SNMP v2变种之间的PDU都有相同的格式，而总的消息格式又都不同。

   现在，SNMP v3 在前面的版本上增加了安全能力和远程配置能力，SNMPv3结构为消息安全和VACM（View-based Access Control Model）引入了USM（User-based Security Model）。这个结构支持同时使用不同的安全机制，接入控制，消息处理模型。SNMP v3 也引入使用SNMP SET命令动态配置 SNMP agent而不失MIB对象代表agent配置。

  这些动态配置支持能够增加，删除，修改和配置远程或本地实体。


有三个可能的安全级别: noAuthNoPriv, authNoPriv, 和 authPriv.
noAuthNoPriv 级别指明了没有认证或私密性被执行.
authNoPriv 级别指明了认证被执行但没有私密性被执行.
authPriv 级别指明了认证和私密性都被执行.

auth---认证 支持MD5 or SHA;
priv---加密 支持DES or RSA;

  通用的SNMPv3消息格式遵循相同的消息封装格式包含一个头和一个被封装PDU。 头部区域，被分成两个部分，一部分处理安全，和另外一部份与安全无关的部分。与安全无关部分所有的SNMPv3部分是相同的，而使用安全相关部分被设计成各种的SNMPv3安全模型，被SNMP内的安全模型处理。



    SNMPv1只使用一种安全策略，团体名。团体名和密码相似。Agent能够被设置回答那些团体名能够被接受的Manager的查询。在很容易让人截取得到团体名或密码。SNMPv2增加了不少额外的安全。首先所有的包信息除了目的地址，其他都被加密。在加密的数据中包括团体名和源IP地址。Agent 能够解开加密包并使用收到的团体名和源IP地址使请求有效。SNMPv3提供三重的安全机制。最高层是认证和私密。中间层提供认证而没有私密和底层没有任何的认证机制和私密

    SNMPV1,V2均采用明文传送，SNMPV3采用加密传送，也就是说对应SNMPV1,V2用抓包工具能在数据包中直接看到团体名。

如下团体名为：snmpv2, 显然抓包可以抓到


安装snmp
================

.. code-block:: bash

    yum -y install net-snmp net-snmp-utils


查看snmp版本号

.. code-block:: bash

    snmpd -v


配置snmp团体名
=======================

下面我们修改/etc/snmp/snmpd.conf ，原配置中我们修改的那一行，最后一列数据默认是public，这里我们改成了sophiroth，后续访问该服务器的snmp服务时，也需要通过sophiroth这个标识来验证获取数据。

.. code-block:: bash

    $ vim /etc/snmp/snmpd.conf
    com2sec notConfigUser  default       sophiroth


启动snmp服务
===================

.. code-block:: bash

    systemctl start snmpd.service
    systemctl enable snmpd.service


如果系统启用了防火墙，还需要根据需求配置防火墙策略,端口是161




查看通过SNMP能看到的东西
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

修改配置，使客户端能获取更多信息
=========================================

下面我们指定能访问我们的snmp服务的ip地址，指定只允许192.168.3.42来访问。

access那一行的倒数第三列改成了all，使得客户端可以获取更多信息了。

.. code-block:: bash

    $ vim /etc/snmp/snmpd.conf
    com2sec notConfigUser  192.168.3.42  publicsvr
    access  notConfigGroup ""      any       noauth    exact  all none none
    view all    included  .1



通过OID查看主机信息
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



snmpv3用户，并设置认证以及加密方式
==========================================

.. note::

    为了安全，验证密码和加密密码不要设置相同。


配置之前，要先停止服务
-------------------------------

.. code-block:: bash

    [root@test2 ~]# systemctl stop snmpd
    [root@test2 ~]#


然后开始新增snmpv3用户，并设置认证及加密方式
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



客户端验证
-------------------


.. code-block:: bash

    [root@test1 ~]# snmpwalk -v3  -lauthNoPriv -u alvin -aMD5 -A 'alvinAuthPassword' -X alvinEcryptPassword test2 |wc -l
    4488



删除SNMPv3账户
----------------------


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



SNMPV3禁止不安全的介入方式
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


