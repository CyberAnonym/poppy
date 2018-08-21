安装部署
########


centos7下安装etcd
================================

.. code-block:: bash

    $ sudo yum install etcd

启动etcd
=============

.. code-block:: bash

    $ sudo systemctl enable etcd
    $ sudo systemctl start etcd


在etcd里创建一个目录
===============================

.. code-block:: bash

    [alvin@k8s1 ~]$ etcdctl mkdir /alvin
    [alvin@k8s1 ~]$ etcdctl ls
    /alvin


删除一个etcd里的目录
================================

.. code-block:: bash

    [alvin@k8s1 ~]$ etcdctl ls
    /alvin
    [alvin@k8s1 ~]$ etcdctl rmdir /alvin
    [alvin@k8s1 ~]$ etcdctl ls

etcd里新建一个文件
============================

.. code-block:: bash

    [root@k8s1 ~]# etcdctl ls
    /registry
    [root@k8s1 ~]# etcdctl set /k8s/network/config '{"Network": "10.255.0.0/16"}'
    {"Network": "10.255.0.0/16"}
    [root@k8s1 ~]# etcdctl ls
    /k8s
    /registry
    [root@k8s1 ~]# etcdctl get /k8s/network/config
    {"Network": "10.255.0.0/16"}


配置一下etcd，时其他主机也能访问这里的etcd服务
==========================================================


.. code-block:: bash

    [root@k8s1 ~]# vim /etc/etcd/etcd.conf
    [root@k8s1 ~]# grep -v ^# /etc/etcd/etcd.conf
    ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
    ETCD_LISTEN_CLIENT_URLS="http://localhost:2379,http://192.168.127.94:2379"
    ETCD_NAME="default"
    ETCD_ADVERTISE_CLIENT_URLS="http://192.168.127.94:2379"

