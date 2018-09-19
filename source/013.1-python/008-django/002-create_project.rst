创建项目
###############



创建一个名为alvincmdb的项目
==================================

.. code-block:: bash

    [root@poppy opt]# django-admin startproject alvincmdb


启动这个项目
==================
这里我们使用的端口似乎8080

.. code-block:: bash

    [root@poppy opt]# cd alvincmdb/
    [root@poppy alvincmdb]# python manage.py runserver 0.0.0.0:8080

然后我们通过本地的8080端口就可以访问到该http服务了。