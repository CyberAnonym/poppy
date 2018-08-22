keepalived
################


实验环境
================

::

    DR 1 INFO
    Hostname: vos1.alv.pub
    Eth0-RIP:192.168.105.201 Netmask 255.255.255.0
    Eth0:1-VIP:192.168.105.211 Netmask 255.255.255.255
    Gateway: 192.168.105.1
    Service: Keepalived, ipvsadm

    DR 2 INFO
    Hostname: vos2.alv.pub
    Eth0-RIP: eth0:192.168.105.202 Netmask 255.255.255.0
    Eth0:1-VIP: eth0:1 :192.168.105.211 Netmask 255.255.255.255
    Gateway: 192.168.105.1
    Service: keepalived, ipvsadm

    Real Server 1 INFO
    Hostname: vos3.alv.pub
    Eth0-RIP: 192.168.105.203 Netmask 255.255.255.0
    lo:0-VIP: 192.168.105.211 Netmask 255.255.255.255
    Gateway: 192.168.105.1
    Service: apache

    Real Server2 INFO
    Hostname: vos4.alv.pub
    Eth0-RIP: 192.168.105.204 Netmask 255.255.255.0
    lo:0-VIP: 192.168.105.211 Netmask 255.255.255.255
    Gateway: 192.168.105.1
    Service: apache


Vos1.alv.pub configuration
====================================

.. code-block:: bash

    yum install keepalived ipvsadm kernel-devel gcc openssl-devel popt-devel make  -y
    echo 1 >  /proc/sys/net/ipv4/ip_forward
    # vim /etc/keepalived/keepalived.conf
    [root@vos1 ~]# grep -v ^# /etc/keepalived/keepalived.conf
    ! Configuration File for keepalived

    global_defs {
       notification_email {
         root@localhost
       }
       notification_email_from Alvin.Wan.CN@hotmail.com
       smtp_server 127.0.0.1
       smtp_connect_timeout 300
       router_id director
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.105.211
        }
    }

    virtual_server 192.168.105.211 80 {
        delay_loop 6
        lb_algo rr
        lb_kind DR
        protocol TCP

        real_server 192.168.105.203 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
            }
        }
        real_server 192.168.105.204 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
            }
        }
    }


然后启动keepalived服务

.. code-block:: bash

    # /etc/init.d/keepalived start

vos2.alv.pub configuration
====================================

.. code-block:: bash

    yum install keepalived ipvsadm kernel-devel gcc openssl-devel popt-devel make  -y
    echo 1 >  /proc/sys/net/ipv4/ip_forward
    vim /etc/keepalived/keepalived.conf
    [root@vos2 ~]# grep -v ^# /etc/keepalived/keepalived.conf
    ! Configuration File for keepalived

    global_defs {
       notification_email {
         root@localhost
       }
       notification_email_from Alvin.Wan.CN@hotmail.com
       smtp_server 127.0.0.1
       smtp_connect_timeout 300
       router_id director
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.105.211
        }
    }

    virtual_server 192.168.105.211 80 {
        delay_loop 6
        lb_algo rr
        lb_kind DR
        protocol TCP

        real_server 192.168.105.203 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
            }
        }
        real_server 192.168.105.204 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
            }
        }
    }

然后启动keepalived服务

.. code-block:: bash

    # /etc/init.d/keepalived start

vos3alv.pub configuration
====================================
.. code-block:: bash

    # yum install httpd -y
    # echo web1 > /var/www/html/index.html
    # /etc/init.d/httpd start
    ifconfig lo:0 192.168.105.211 broadcast 192.168.105.211 netmask 255.255.255.255 up
    route add -host 192.168.105.211 dev lo:0

    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
    2.4,vos4.alv.pub configuration
    # yum install httpd -y
    # echo web2 > /var/www/html/index.html
    # /etc/init.d/httpd start
    ifconfig lo:0 192.168.105.211 broadcast 192.168.105.211 netmask 255.255.255.255 up
    route add -host 192.168.105.211 dev lo:0

    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce

客户端测试
==============
.. code-block:: bash

    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1

可见，成功实现负载均衡
那么下面我们进行高可用的测试，这里我们将vos1先停掉，看还能不能访问

.. code-block:: bash

    [root@kvm ~]# virsh shutdown vos1.alv.pub
    Domain vos1.alv.pub is being shutdown

    [root@kvm ~]# ping vos1
    PING vos1.alv.pub (192.168.105.201) 56(84) bytes of data.
    ^C
    --- vos1.alv.pub ping statistics ---
    5 packets transmitted, 0 received, 100% packet loss, time 4001ms

    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]#
    [root@kvm ~]#
    [root@kvm ~]# curl 192.168.105.211
    web1

那么现在我们把vos2也停掉，这下应该是肯定访问不了了的。

.. code-block:: bash

    [root@kvm ~]# virsh shutdown vos2.alv.pub
    Domain vos2.alv.pub is being shutdown

    [root@kvm ~]# ping -c 2 vos2
    PING vos2.alv.pub (192.168.105.202) 56(84) bytes of data.
    ^CFrom 192.168.105.30 icmp_seq=1 Destination Host Unreachable
    From 192.168.105.30 icmp_seq=2 Destination Host Unreachable

    --- vos2.alv.pub ping statistics ---
    2 packet [root@kvm ~]# curl 192.168.105.211
    ^C
    [root@kvm ~]# curl 192.168.105.211
    ^C

现在访问不了了，那么我们开启vos1，

.. code-block:: bash

    +[root@kvm ~]# virsh start vos1.alv.pub
    Domain vos1.alv.pub started
    [root@kvm ~]# ping -c 1 vos1
    PING vos1.alv.pub (192.168.105.201) 56(84) bytes of data.
    64 bytes from 192.168.105.201: icmp_seq=1 ttl=64 time=2.46 ms

    --- vos1.alv.pub ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 2.460/2.460/2.460/0.000 ms
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1

然后就又可以访问了。现在我们再关掉vos1开启vos2，然后发现，也是可以访问的，

.. code-block:: bash

    [root@kvm ~]# virsh shutdown vos1.alv.pub && virsh start vos2.alv.pub
    Domain vos1.alv.pub is being shutdown

    Domain vos2.alv.pub started
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web1


然后我们尝试把vos3也关掉，于是我们可以看到，再次访问时，就只能看到web2了，vos3和vos4是轮询负载均衡，vos1和vos2是高可用。

.. code-block:: bash

    [root@kvm ~]# virsh shutdown vos3.alv.pub
    Domain vos3.alv.pub is being shutdown

    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web2
    [root@kvm ~]# curl 192.168.105.211
    web2

.. image:: ../../images/keepalived1.png