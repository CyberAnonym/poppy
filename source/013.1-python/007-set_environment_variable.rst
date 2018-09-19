设置环境变量
################

::


    将/root 加入到环境变量里，可以调用那里的包
    #vim /usr/local/lib/python2.7/site-packages/shenmin.pth
    /root



::

    ##创建项目环境变量
    cd /usr/local/python27/lib/python2.7/site-packages
    touch shenmin.pth
    # vim shenmin.pth

    /apps/apps-8pang
    /apps/apps-chima
    /apps/apps-common
    /apps/apps-qingbi
    /apps/apps-shenmin


::

    [root@poppy ~]# ll /var/www/webapp/ophira/ophira/
    total 32
    -rw-r--r--. 1 apache root    0 Sep 19 13:44 __init__.py
    -rw-r--r--. 1 apache root  118 Sep 19 13:48 __init__.pyc
    -rw-r--r--. 1 apache root 3739 Sep 19 13:44 settings.py
    -rw-r--r--. 1 apache root 3791 Sep 19 13:48 settings.pyc
    -rw-r--r--. 1 apache root 2297 Sep 19 13:44 urls.py
    -rw-r--r--. 1 apache root 2760 Sep 19 13:48 urls.pyc
    -rw-r--r--. 1 apache root   80 Sep 19 13:44 views.py
    -rw-r--r--. 1 apache root  389 Sep 19 13:44 wsgi.py
    -rw-r--r--. 1 apache root  573 Sep 19 13:48 wsgi.pyc

    [root@poppy ~]# vim /usr/lib64/python2.7/site-packages/ophira.pth
    /var/www/webapp/ophira
    [root@poppy ~]# python
    Python 2.7.5 (default, Apr 11 2018, 07:36:10)
    [GCC 4.8.5 20150623 (Red Hat 4.8.5-28)] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import ophira.settings
    >>>

