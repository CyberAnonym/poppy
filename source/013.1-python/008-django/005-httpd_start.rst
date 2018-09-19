使用httpd服务启动django
##############################

.. code-block:: bash

    [root@poppy ~]# yum install mod_wsgi -y
    [root@poppy ~]# vim /usr/lib64/python2.7/site-packages/alvincmdb.pth
    /opt/alvincmdb
    [root@poppy ~]# vim /etc/httpd/conf/httpd.conf
    <VirtualHost *:80>
        ServerName poppy.alv.pub
        alias /static /opt/alvincmdb/static
        WSGIScriptAlias / /opt/alvincmdb/alvincmdb/wsgi.py
    </VirtualHost>
    <Directory /opt/alvincmdb>
        AllowOverride none
        Require all granted
    </Directory>
    [root@poppy ~]# vim /opt/alvincmdb/alvincmdb/settings.py
    DEBUG = False
    ALLOWED_HOSTS = ['poppy.alv.pub']
    [root@poppy ~]# chown apache /opt/alvincmdb/ -R
    [root@poppy ~]# systemctl restart httpd