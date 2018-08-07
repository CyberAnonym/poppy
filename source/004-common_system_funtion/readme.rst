常用系统功能
####################

通过alias配置一个自定义命令
===================================
这里我们用alias定义一个新命令psnew, 执行psnew的效果就是ps -Ao user,pid,ppid,command

.. code-block:: bash
    :linenos:

    echo "alias psnew='ps -Ao user,pid,ppid,command'" >> /etc/bashrc
    source /etc/bashrc

