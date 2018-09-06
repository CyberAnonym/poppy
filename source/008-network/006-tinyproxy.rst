tinyproxy
##############
tinyproxy 是代理服务器，配置好tinyproxy服务后，在客户端ie浏览器里配合好tinyproxy服务器地址，就可以通过tinyproxy代理去上网了。

安装tinyproxy
======================

.. code-block:: bash

    $ sudo yum install tinyproxy -y

配置tinyproxy
===================



.. code-block:: bash

    $ sudo vim /etc/tinyproxy/tinyproxy.conf
    Allow 0.0.0.0/0


启动tinyproxy
====================

.. code-block:: bash

    $ sudo systemctl start tinyproxy
    $ sudo systemctl enable tinyproxy