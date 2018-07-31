softethervpn
#############

参考链接：https://blog.csdn.net/xufangfang99/article/details/77916749

安装SoftEtherVPN Server
==============================

安装编译环境

.. code-block:: bash

    yum -y install gcc

下载SoftEtherVPN Server For Linux

.. code-block:: bash

    wget http://www.softether-download.com/files/softether/v4.22-9634-beta-2016.11.27-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.22-9634-beta-2016.11.27-linux-x64-64bit.tar.gz

解压文件

.. code-block:: bash

    tar -zxvf softether-vpnserver-*.tar.gz

进入到解压目录

.. code-block:: bash

    cd vpnserver

启动安装脚本

.. code-block:: bash

    ./.install.sh

阅读License，根据提示，输入“1”然后回车确认。

如果提示不识别某些命令比如gcc，另行安装即可。如果没有异常则说明安装成功。

启动服务

.. code-block:: bash

    ./vpnserver start
    （停止服务命令为：./vpnserver stop）

    sed -ie  "/^exit/i /usr/local/vpnserver start" /etc/rc.d/rc.local  (设置配置开机启动)

在CentOS7以后可以用systemd启动vpnserver，先新建启动脚本/etc/systemd/system/vpnserver.service：

.. code-block:: bash

    vim /etc/systemd/system/vpnserver.service
    [Unit]
    Description=SoftEther VPN Server
    After=network.target

    [Service]
    Type=forking
    ExecStart=/root/vpnserver/vpnserver start
    ExecStop=/root/vpnserver/vpnserver stop

    [Install]
    WantedBy=multi-user.target

然后就可以通过systemctl start vpnserver启动了，并通过systemctl enable vpnserver设置开机自启。

启动成功后我们需要设置远程登录密码以便本地管理服务。运行下面的命令进入VPN的命令行：

.. code-block:: bash

    ./vpncmd

选择1. Management of VPN Server or VPN Bridge

这里需要选择地址和端口。默认443端口，如果需要修改，可以输入localhost:5555（实际端口），然后出现：

If connecting to the server by Virtual Hub Admin Mode, please input the Virtual Hub name.

If connecting by server admin mode, please press Enter without inputting anything.

Specify Virtual Hub Name:

这里就是指定一个虚拟HUB名字，用默认的直接回车就行。

Connection has been established with VPN Server "localhost" (port 5555).

You have administrator privileges for the entire VPN Server.

VPN Server>
这时我们需要输入ServerPasswordSet命令设置远程管理密码，确认密码后就可以通过Windows版的SoftEther VPN Server Manager远程管理了。