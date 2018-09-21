wsgi
#########

部署一个wsgi的应用，这里我们部署一个django项目，这个项目就是我写的。

ophira介绍
==================
Ophira 项目是一个django+html+css+js+jquery+iView结合运用的项目，目前正在开发中。


已开发的代码已部署在https://alv.pub 上。

安装部署ophira
========================

依赖环境
------------------

ophira使用的python版本为python2.7，django版本是1.8.2.， 使用mysql数据库。

本次部署演示我们所在的主机名叫poppy.alv.pub， 可以通过主机名访问，能解析成该主机IP。

下载ophira
-------------------

.. code-block:: bash

    # yum install git -y
    # cd /opt/
    # git clone https://github.com/AlvinWanCN/ophira.git
    # cd ophira


修改数据库地址或设置本地解析
-----------------------------------

源代码中设置的连接数据库的地址是maxsclae.alv.pub,配置在ophira/ophira/settings.py里面。
我们可以修改数据库地址，或设置一个本地解析将maxscale.alv.pub 解析为我们自己的数据库ip。


.. code-block:: bash

    # vim ophira/settings.py
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'ophira',
            'HOST': 'maxscale.alv.pub',
            'USER': 'alvin',
            'PASSWORD': 'sophiroth',
            'PORT': 4006

        }
    }


创建数据库
----------------------

这里的数据库账号，根据实际情况设置

.. code-block:: sql

    CREATE DATABASE `ophira` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
    grant all privileges on ophira.* to 'alvin'@'%' identified by 'sophiroth';


安装依赖包
------------------


.. code-block:: bash

    sudo yum install mysql-devel -y
    sudo yum install python-devel -y
    sudo yum install python2-pip -y
    sudo pip install -U pip
    sudo pip install django==1.8.2
    sudo pip install django-cors-headers
    sudo pip install pymysql
    sudo pip install MySQL-python
    sudo pip install lxml


同步数据库
------------------

.. code-block:: bash

    python  manage.py  validate/check  #检测数据库配置是否有错 旧版本是vilidate,新新版是check

    python  manage.py  makemigrations  #创建对应数据库的映射语句

    python  manage.py  syncdb   同步或者映射数据库


启动服务
-----------------

这里我们有两种方式，一种是用python启动，让systemd服务托管我们的服务，另一种是配置apache httpd服务，让httpd来管理我们的django。

部署到apache httpd 服务
++++++++++++++++++++++++++++++++


.. code-block:: bash

    [root@poppy ~]# yum install mod_wsgi -y
    [root@poppy ~]# vim /usr/lib64/python2.7/site-packages/ophira.pth
    /opt/ophira
    [root@poppy ~]# vim /etc/httpd/conf/httpd.conf
    <VirtualHost *:80>
        ServerName poppy.alv.pub
        alias /static /opt/ophira/static
        WSGIScriptAlias / /opt/ophira/ophira/wsgi.py
    </VirtualHost>
    <Directory /opt/ophira>
        AllowOverride none
        Require all granted
    </Directory>
    [root@poppy ~]# vim /opt/ophira/ophira/settings.py
    DEBUG = False
    ALLOWED_HOSTS = ['poppy.alv.pub']
    [root@poppy ~]# chown apache /opt/ophira/ -R
    [root@poppy ~]# systemctl restart httpd



- 访问


http://poppy.alv.pub



