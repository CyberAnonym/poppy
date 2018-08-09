常用系统功能
####################

通过alias配置一个自定义命令
===================================
这里我们用alias定义一个新命令psnew, 执行psnew的效果就是ps -Ao user,pid,ppid,command

.. code-block:: bash
    :linenos:

    echo "alias psnew='ps -Ao user,pid,ppid,command'" >> /etc/bashrc
    source /etc/bashrc

命令传参自动补全
===================
一般命令我们直接能按tab键自动补全，但命令后面的传参就不行了，能使用哪些传参我们可能都不知道，除非我们安装了bash-completion,

比如输入到systemctl status zabbix-，按tab，就能将可能出现的传输到打印到下一行了。

安装bash-completion

.. code-block:: bash

    # yum install -y bash-completion


安装好这个后各种命令都能tab补全参数了， 尤其使用nmcli之类的命令，很是好用，nmcli connection 然后按tab,后面的参数就出来了，输入一个参数后再按tab，就显示剩下的参数。