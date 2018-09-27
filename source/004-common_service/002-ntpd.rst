ntpd
#######

ntpd - Network Time Protocol (NTP) daemon

ntpd 是时间服务器


安装ntpd服务
==============

.. code-block:: bash

    $ sudo yum install ntp -y


配置ntpd，设置允许访问的客户端地址范围
===========================================


.. code-block:: bash

    $ sudo vim /etc/ntp.conf
    restrict 192.168.127.0/24

设置防火墙规则，允许其他地址访问我们的ntp
===================================================

.. code-block:: bash

    $ sudo firewall-cmd --permanent --add-service=ntp
    $ sudo firewall-cmd --reload

启动ntpd
==============

.. code-block:: bash

    $ sudo systemctl start ntpd
    $ sudo systemctl enable ntpd



客户端使用
=====================

这里我们的ntp服务器的地址是ntp.alv.pub

.. code-block:: bash

    $ sudo ntpdate ntp.alv.pub


也可以使用chrony服务作为ntp的客户端，详情请阅读chrony服务章节。

