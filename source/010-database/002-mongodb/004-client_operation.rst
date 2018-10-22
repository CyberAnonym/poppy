客户端操作
################


linux下连接目标mongodb
========================


.. code-block:: bash

    $ mongo mongodb.alv.pub

查看数据库
=================

::

    show dbs;


建立test 数据库
====================

::

    use test;

往testdb表插入数据
=========================

::

    db.testdb.insert({"test1":"alvin"})


查询testdb数据看看是否成功
=================================

::

    db.testdb.find();

删除刚才插入的那条数据
============================

::

    db.testdb.remove({"test1":"alvin"})


