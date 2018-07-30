firewalld
##################

firewalld是centos7下提供的防火墙服务


启动和关闭firewalld
=========================

.. code-block:: bash

    systemctl firewalld start
    systemctl firewalld stop
    systemctl firewalld restart

查看当前防火墙规则列表
=========================

.. code-block:: bash

    firewall-cmd --list-all

将默认区域设置为信任
============================
调整防火墙信任区域，简化对后续各种服务的防护

.. code-block:: bash

    firewall-cmd --set-default-zone=trusted


对所有网络开放http服务
=======================================================
我们需要永久生效该规则，所以加上--permanent参数。

.. code-block:: bash

    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload
    firewall-cmd --list-all

对所有网络开放tcp80端口
===============================

.. code-block:: bash

    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --reload
    firewall-cmd --list-all


删除已开放的httpd服务
===========================

.. code-block:: bash

    firewall-cmd --permanent --remove-service=http
    firewall-cmd --reload
    firewall-cmd --list-all

在public区打开http服务
=================================

.. code-block:: bash

    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --reload#firewall-cmd --list-all


指定网络中将本地端口5423转发到80
=================================================
将本地端口5423转发到80

.. code-block:: bash

    firewall-cmd --permanent --zone=trusted --add-forward-port=port=5423:proto=toport=80

拒绝指定网络的所有请求
=================================
拒绝192.168.2.0/24的请求

.. code-block:: bash

    firewall-cmd --permanent --add-source=192.168.2.0/24 --zone=block