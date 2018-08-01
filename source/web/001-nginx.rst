nginx
===========

yum安装nginx
====================

.. code-block:: bash 

    yum install nginx -y

启动关闭重启服务
=====================

.. code-block:: bash

    systemctl enable nginx  #开机自动启动
    systemctl start nginx
    systemctl stop nginx
    systemctl restart nginx
