autofs
###########


目标nfs服务的配置环境
--------------------------------------


.. code-block:: bash

    [root@dc ~]# cat /etc/exports
    /ldapUserData/alvin	*(rw,async)

    [root@dc ~]# showmount -e  dc.alv.pub
    Export list for dc.alv.pub:
    /ldapUserData/alvin *



安装autofs
-------------

.. code-block:: bash

    yum -y install autofs

配置autofs
-------------------

.. code-block:: bash

    echo "/sophiroth auto.sophiroth rw,nosuid --timeout=60" >>/etc/auto.master
    echo "* ops1.alv.pub:/ldapUserData/&" >> /etc/auto.sophiroth


启动autofs，并设置开机自动启动
------------------------------------

.. code-block:: bash

    systemctl start autofs
    systemctl enable autofs


访问相关目录
---------------

.. code-block:: bash

    [root@ops2 ~]# ll /sophiroth/alvin
    ls: cannot open directory /sophiroth/alvin: Permission denied
    [root@ops2 ~]# su - alvin
    Last login: Fri Feb  9 05:20:54 EST 2018 on pts/2
    [alvin@ops2 ~]$ pwd
    /sophiroth/alvin