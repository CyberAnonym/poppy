samba
############

samba服务主要是用来做目录共享的，可以像一个网盘一样共享给windows去挂载，也常用于将linux目录共享到windows系统。


下面我们来进行一些实例实际操作



以只读的方式共享/public目录给user1用户
===========================================

.. code-block:: bash

    [root@poppy ~]# mkdir -p /public
    [root@poppy ~]# vim /etc/samba/smb.conf
    [public]
        path = /public
    [root@poppy ~]# useradd user1
    [root@poppy ~]# pdbedit -a user1   ##为user1添加密码，这里设置的密码是samba服务使用的密码，非系统密码。
    [root@poppy ~]# setsebool -P samba_export_all_ro=on
    [root@poppy ~]# systemctl restart smb nmb

如果打开了防火墙，则要设置相应的防火墙策略，


- 客户端挂载

确认客户端能以只读的方式挂载

.. code-block:: bash

    [root@saltstack ~]# mkdir -p /public
    [root@saltstack ~]# df /public
    Filesystem                  1K-blocks    Used Available Use% Mounted on
    /dev/mapper/vg_root-lv_root  19396608 7454016  11942592  39% /
    [root@saltstack ~]#
    [root@saltstack ~]# yum install cifs-utils -y &>/dev/null
    [root@saltstack ~]# mount -t cifs //poppy1.alv.pub/public /public -o user=user1,password=sophiroth
    [root@saltstack ~]# df /public
    Filesystem              1K-blocks    Used Available Use% Mounted on
    //poppy1.alv.pub/public  19396608 2705164  16691444  14% /public
    [root@saltstack ~]# ls /public/
    [root@saltstack ~]# touch /public/ok
    touch: cannot touch ‘/public/ok’: Permission denied



以读写的方式将/files目录共享给user2和user3
====================================================

这里要注意，我们设置了acl权限让用户user2和user3拥有对/files目录的权限，又在samba的配置文件里添加write list=user2,user3， 这样这两个用户才能拥有对这个目录的权限，少设置一个地方都不行。

.. code-block:: bash

    [root@poppy ~]# mkdir -p /files
    [root@poppy ~]# touch /files/ok
    [root@poppy ~]# setsebool -P samba_export_all_rw on
    [root@poppy ~]# useradd user2;pdbedit -a user2
    [root@poppy ~]# useradd user3;pdbedit -a user3
    [root@poppy ~]# setfacl -m u:user2:rwx /files/
    [root@poppy ~]# setfacl -m u:user3:rwx /files/
    [root@poppy ~]# vim /etc/samba/smb.conf
    [files]
        path = /files
        write list = user2,user3
    [root@poppy ~]# systemctl restart smb nmb


- 客户端访问验证

.. code-block:: bash

    [root@saltstack ~]# mkdir -p /files
    [root@saltstack ~]# mount -t cifs //poppy1.alv.pub/files /files -o user=user2,password=sophiroth
    [root@saltstack ~]# ls /files/
    ok
    [root@saltstack ~]# touch /files/yes
    [root@saltstack ~]# ls -l /files/