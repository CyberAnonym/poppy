报错处理
##############


is not mapped to any cell
=======================================
openstack dashboard界面创建实例的时候，创建失败，提示xxxxx is not mapped to any cell

.. code-block:: bash

    su -s /bin/sh -c 'nova-manage cell_v2 discover_hosts --verbose' nova


Failed to connect to server (code: 1006)
=======================================================

实例正常运行，但是打开控制台，却显示Failed to connect to server (code: 1006)， 原因可能是浏览器里输入的地址和/etc/nova/nova.conf里配置的vncserver_proxyclient_address的地址不一样。



hell