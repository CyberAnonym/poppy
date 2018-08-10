netstst
############


语法
=======

.. code-block:: bash

    $ netstat (选项)

选项
=======

.. code-block:: bash

    -a或--all：显示所有连线中的Socket；
    -A<网络类型>或--<网络类型>：列出该网络类型连线中的相关地址；
    -c或--continuous：持续列出网络状态；
    -C或--cache：显示路由器配置的快取信息；
    -e或--extend：显示网络其他相关信息；
    -F或--fib：显示FIB；
    -g或--groups：显示多重广播功能群组组员名单；
    -h或--help：在线帮助；
    -i或--interfaces：显示网络界面信息表单；
    -l或--listening：显示监控中的服务器的Socket；
    -M或--masquerade：显示伪装的网络连线；
    -n或--numeric：直接使用ip地址，而不通过域名服务器；
    -N或--netlink或--symbolic：显示网络硬件外围设备的符号连接名称；
    -o或--timers：显示计时器；
    -p或--programs：显示正在使用Socket的程序识别码和程序名称；
    -r或--route：显示Routing Table；
    -s或--statistice：显示网络工作信息统计表；
    -t或--tcp：显示TCP传输协议的连线状况；
    -u或--udp：显示UDP传输协议的连线状况；
    -v或--verbose：显示指令执行过程；
    -V或--version：显示版本信息；
    -w或--raw：显示RAW传输协议的连线状况；
    -x或--unix：此参数的效果和指定"-A unix"参数相同；
    --ip或--inet：此参数的效果和指定"-A inet"参数相同。


实例
=======


列出所有端口 (包括监听和未监听的)
---------------------------------------

.. code-block:: bash

    $ netstat -a     #列出所有端口
    $ netstat -at    #列出所有tcp端口
    $ netstat -au    #列出所有udp端口

列出所有处于监听状态的 Sockets
------------------------------------------

.. code-block:: bash

    $ netstat -l        #只显示监听端口
    $ netstat -lt       #只列出所有监听 tcp 端口
    $ netstat -lu       #只列出所有监听 udp 端口
    $ netstat -lx       #只列出所有监听 UNIX 端口

显示每个协议的统计信息
-------------------------

.. code-block:: bash

    $ netstat -s   #显示所有端口的统计信息
    $ netstat -st   #显示TCP端口的统计信息
    $ netstat -su   #显示UDP端口的统计信息



在netstat输出中显示 PID 和进程名称
--------------------------------------------

.. code-block:: bash

    $ netstat -pt

netstat -p可以与其它开关一起使用，就可以添加“PID/进程名称”到netstat输出中，这样debugging的时候可以很方便的发现特定端口运行的程序。


持续输出netstat信息
------------------------------

.. code-block:: bash

    $ netstat -c  #每隔一秒输出网络信息


c后面数字，则是指定秒。 还可以用grep

- 每三秒打印一次包含192.168.127.59:80的端口信息

比如之前只有0.0.0.0:80的listen状态，执行该命令后，再访问我们的80服务。就可以能看到有新的信息打印出来了。

.. code-block:: bash

    [root@alvin ~]# netstat -anplcut 3|grep "192.168.127.59:80 "
    tcp        0      0 192.168.127.59:80       192.168.127.38:55152    ESTABLISHED 1133/nginx: worker
    tcp        0      0 192.168.127.59:80       192.168.127.38:55153    ESTABLISHED 1131/nginx: worker

显示网络接口列表
----------------------

.. code-block:: bash

    $ netstat -i

显示详细信息，像是ifconfig使用netstat -ie。

.. code-block:: bash
    :linenos:

    [alvin@alvin ~]$ netstat -ie
    Kernel Interface table
    ens32: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.127.59  netmask 255.255.255.0  broadcast 192.168.127.255
            ether 00:00:00:00:00:59  txqueuelen 1000  (Ethernet)
            RX packets 45389  bytes 3763809 (3.5 MiB)
            RX errors 0  dropped 9  overruns 0  frame 0
            TX packets 37467  bytes 4193607 (3.9 MiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    ens34: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 172.25.254.232  netmask 255.255.255.0  broadcast 172.25.254.255
            ether 00:0c:29:7d:72:61  txqueuelen 1000  (Ethernet)
            RX packets 328  bytes 37361 (36.4 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 109  bytes 20156 (19.6 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            loop  txqueuelen 1  (Local Loopback)
            RX packets 218  bytes 23587 (23.0 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 218  bytes 23587 (23.0 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
