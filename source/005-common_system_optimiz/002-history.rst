history
########
查看当前系统下的历史命令。


为history命令添加命令执行的日期

.. code-block:: bash

    grep "HISTTIMEFORMAT=" /etc/profile||echo 'export HISTTIMEFORMAT="[%F %T] "' >> /etc/profile