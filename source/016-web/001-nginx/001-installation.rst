安装nginx
#############

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

nginx配置检测
===================
在修改配置了配置之后，需要重新启动服务的时候，先用nginx -t检测一下配置有没有错误。

.. code-block:: bash

    nginx -t