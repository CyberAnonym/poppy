配置
#####

修改绑定的ip和端口
========================
这里我们将端口从默认的27017改成了27018


.. code-block:: bash

    $ vim /etc/mongod.conf
    net:
      port: 27018
      bindIp: 0.0.0.0
    $ systemctl restart mongod
    $ lsof -i:27018  #confirm.

