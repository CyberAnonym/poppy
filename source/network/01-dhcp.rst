dhcp
####


安装dhcp服务
------------------
::

    yum install -y dhcp

配置DHCP服务
----------------

::

    vim /etc/dhcp/dhcpd.conf
    #设置DHCP于DNS服务器的动态信息更新模式。初学时完全可以不理这个选项，但是全局设置中一定要有这个选项，否则DHCP服务不能成功启动。
    ddns-update-style interim;
    subnet 192.168.38.0 netmask 255.255.255.0 {
        range 192.168.38.200 192.168.38.254; #分配给客户机的IP从192.168.233.100开始到192.168.233.199
        option routers 192.168.38.1; #设置网关
        default-lease-time 600; #默认租约时间
        max-lease-time 7200; #最大租约时间
    }

为指定服务器网卡进行MAC地址与IP地址绑定，则继续在上面的配置文件下面进行如下配置

::

    host ops2 { #有一个主机，叫ops2
        hardware ethernet 00:0c:29:1c:53:48; #MAC地址是08:...:27的网卡
        fixed-address 192.168.38.235;    #分配给它192.168.38.235的IP
    }

以上是为一个网段做配置，那么如果是两个网段呢？我们进行如下配置，顺便将dhcp于dns服务器的动态信息更新关掉
::


    vim /etc/dhcp/dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.example
    #   see dhcpd.conf(5) man page
    #设置DHCP于DNS服务器的动态信息更新模式。初学时完全可以不理这个选项，但是全局设置中一定要有这个选项，否则DHCP服务不能成功启动。
    ddns-update-style none;
    shared-network alpha {
    subnet 192.168.38.0 netmask 255.255.255.0 {
        range 192.168.38.100 192.168.38.200; #分配给客户机的IP从192.168.233.100开始到192.168.233.199
        option domain-name-servers 192.168.38.3;
        option domain-name "alv.pub shenmin.com sophiroth.com";
        option routers 192.168.38.1; #设置网关
        default-lease-time 600; #默认租约时间
        max-lease-time 7200; #最大租约时间
    }
    host ops2 { #有一个主机，叫ops2
        hardware ethernet 00:0c:29:1c:53:48; #MAC地址是08:...:27的网卡
        fixed-address 192.168.38.235;    #分配给它192.168.38.235的IP
    }
    host ops1 { #有一个主机，叫ops1
        hardware ethernet 00:0C:29:8A:81:7B;
        fixed-address 192.168.38.200;
    }
    host t1 { #有一个主机，叫t1
        hardware ethernet 00:50:56:32:9C:C4;
        fixed-address 192.168.38.86;
    }

    subnet 192.168.127.0 netmask 255.255.255.0 {
        range 192.168.127.100 192.168.127.200; #分配给客户机的IP从192.168.233.100开始到192.168.233.199
        option domain-name-servers 192.168.127.3,114.114.114.114;
        option domain-name "alv.pub shenmin.com sophiroth.com";
        option routers 192.168.127.2; #设置网关
        default-lease-time 600; #默认租约时间
        max-lease-time 7200; #最大租约时间
    }
    }