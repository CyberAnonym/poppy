vlock
#########

vlock(virtual console lock)
功能说明：锁住虚拟终端。


安装vlock
=====================

.. code-block:: bash

    yum install vlock -y



参数
===============

　-a或–all        锁住所有的终端阶段作业，如果您在全屏幕的终端中使用本参数，则会将用键盘切换终端机的功能一并关闭。

　-c或–current    锁住目前的终端阶段作业，此为预设值。

　-h或–help       在线帮助。

　-v或–version    显示版本信息。




使用vlock锁住所有终端
========================

.. code-block:: bash

    vlock -a


执行vlock -a之后，无法alt+F2 切换到其他终端。
