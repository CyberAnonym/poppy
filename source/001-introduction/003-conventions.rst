文档约定
#########


The Poppy documentation uses several typesetting conventions.

声明
=========

以下形式的标志为注意项


.. note::

    该种标识表示备注，或提醒读者注意。


.. important::

    该种标识表示提示重要的信息。

.. warning::

    该种标识表示警告，注意，不注意可能会有问题。

.. tip::

    该种标识表示一个简单的提示，可能是告诉你一个小技巧。



命令提示符
===============

.. code-block:: bash

    $ command

命令前面使用$ 提示符表示该命令的执行者可以是包括root在内的任何用户。

.. code-block:: bash

    # command


命令前面使用# 提示符表示该命令需要root来执行，或是有sudo权限的用户在前面加上sudo 执行。

#如果没有出现在最前面，比如出现在命令后面，则可能表示注释， ## 两个井号表示注释。


.. note::

    没有命令提示符的命令属于早期编写的文档，没有表明是用root还是普通用户执行。