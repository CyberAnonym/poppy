packstack安装openstack
===================================

使用packstack去安装openstack


::

    开始安装：

    1.更新yum源：

    #yum update
    2.关闭NetworkManager：

    #systemctl stop NetworkManager.servicesystemctl disable NetworkManager.service
    3.重启网络：

    #systemctl restart network
    重启网络之后需要确保网络可以访问。

    4.闭防火墙：

    #setenforce 0

    #systemctl stop firewalld

    #systemctl disable firewalld

    5.更新device-mapper

    #yum update device-mapper
    6.安装rdo

    #yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
    7.安装packstack

    #yum install -y openstack-packstack
    8.安装openstack （这里会需要比较长的时间，尤其是中间会卡两次，这两次会需要比较长的时间，如果不报错，一定要等它安装结束。）

    #packstack --allinone