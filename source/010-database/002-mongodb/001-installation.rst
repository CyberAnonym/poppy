安装mongodb
#################

这里我们安装mongodb企业版

参考地址： https://docs.mongodb.com/manual/tutorial/install-mongodb-enterprise-on-red-hat/


添加mangodbyum源
=====================

.. code-block:: bash

    $ vim  /etc/yum.repos.d/mongodb-enterprise.repo
    [mongodb-enterprise]
    name=MongoDB Enterprise Repository
    baseurl=https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/4.0/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc

通过yum安装mongodb
===========================

.. code-block:: bash

    $ sudo yum install -y mongodb-enterprise

启动mangodb
===============

.. code-block:: bash

    systemctl enable mongod
    systemctl start mongod


mongodb使用的端口：27017

