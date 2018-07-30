apache
===========

yum安装apache
====================

.. code-block:: bash

    yum install httpd -y

启动关闭重启服务
=====================

.. code-block:: bash

    systemctl enable httpd  #开机自动启动
    systemctl start httpd
    systemctl stop httpd
    systemctl restart httpd
