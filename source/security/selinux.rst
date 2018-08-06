selinux
############
SELinux -- Security Enhanced Linux

通过管理系统的selinux行为，在出现网络服务受到攻击时确保其安全性

布尔值（bool）是启动/禁用一组策略的开关，上下文（context）是位于可决定访问权限的进程、文件和端口上的标签。

enforce

更改SELinux模式
=========================

SELinux有三种模式， 强制模式，许可模式和禁用模式

.. code-block:: text

    #     enforcing - SELinux security policy is enforced.
    #     permissive - SELinux prints warnings instead of enforcing.
    #     disabled - No SELinux policy is loaded.


- 查看当前selinux模式

.. code-block:: bash

    [root@saltstack ~]# getenforce
    Enforcing

- 将默认的SELinux模式改为许可模式，并重新启动

.. code-block:: bash

    [root@saltstack ~]# sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
    [root@saltstack ~]# grep '^SELINUX'  /etc/selinux/config
    SELINUX=permissive
    SELINUXTYPE=targeted
    root@saltstack ~]# reboot

- 将默认SELinux更改为强制模式

.. code-block:: bash

    [root@saltstack ~]# sed -i 's/SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
    [root@saltstack ~]# grep '^SELINUX'  /etc/selinux/config
    SELINUX=enforcing
    SELINUXTYPE=targeted
    [root@saltstack ~]# reboot


更改SELinux上下文
======================

初始SELinux上下文
------------------------
通常，文件父目录的SElinux上下文决定该文件的初始SElinux上下文，父目录的上下文会分配给新建文件，这适用于vim、cp和touch等命令，但是，如果文件是在其他位置创建并且权限得以保留（如使用mv 或cp -a），
那么原始SElinux上下文不会发生改变。

.. code-block:: bash

    [root@alvin ~]# ls -Zd /var/www/html/
    drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/
    [root@alvin ~]# touch /var/www/html/index.html
    [root@alvin ~]# ls -Z /var/www/html/index.html
    -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/index.html

更改文件的SELinux上下文
--------------------------------
可使用两个命令来更改文件的SElinux上下文：chcon和restorecon。
chcon命令将文件的上下文更改成已指定为该命令参数的上下文，**-t选项经常用于指定上下文的类型。**

restorecon 命令是更改文件或目录的SELinux上下文的首选方法。 不同于chcon，在使用此命令时，不会明确指定上下文，他使用SELinux策略中的规则来确定应该是那种文件的上下文。

.. note::

    不应该使用chcon来更改文件的SElinux上下文，在明确指定上下文时可能会出错。如果在系统启动时重新标记了其文件系统，文件上下文将会还原为默认上下文。

.. code-block:: bash

    [root@alvin ~]# mkdir -p /poppy
    [root@alvin ~]#
    [root@alvin ~]# ls -Zd /poppy
    drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /poppy
    [root@alvin ~]# chcon -t httpd_sys_content_t /poppy
    [root@alvin ~]# ls -Zd /poppy
    drwxr-xr-x. root root unconfined_u:object_r:httpd_sys_content_t:s0 /poppy
    [root@alvin ~]# restorecon -v /poppy
    restorecon reset /poppy context unconfined_u:object_r:httpd_sys_content_t:s0->unconfined_u:object_r:default_t:s0
    [root@alvin ~]# ls -Zd /poppy
    drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /poppy

定义SELinux默认文件上下文规则
--------------------------------------
semanage fcontext 命令可用于显示或修改restorecon命令用来设置默认文件上下文的规则。它使用扩展正则表达式来指定路径和文件名， fcontext规则中最常见的扩展正则表达式是（/.*）?
这意味着：“（可选）匹配/后跟任意数量的字符”。它将会匹配在表达式前面列出的目录并递归地匹配该目录中的所有内容。

restorecon命令是policycoreutil软件包的一部分；semanage是policycoreutil-python软件包的一部分。

.. code-block:: bash

    [root@alvin ~]# touch /tmp/{file1,file2}
    [root@alvin ~]# ls -Z /tmp/file*
    -rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /tmp/file1
    -rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /tmp/file2
    [root@alvin ~]# mv /tmp/file1 /var/www/html/
    [root@alvin ~]# cp /tmp/file2 /var/www/html/
    #实验发现mv会保留原context，cp会使用目标目录的默认context
    [root@alvin ~]# ls -Z /var/www/html/file*
    -rw-r--r--. root root unconfined_u:object_r:user_tmp_t:s0 /var/www/html/file1
    -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2
    #查看所有目录的默认context值。
    [root@alvin ~]# semanage fcontext -l|grep '/var/www(/.*)?'
    /var/www(/.*)?                                     all files          system_u:object_r:httpd_sys_content_t:s0
    /var/www(/.*)?/logs(/.*)?                          all files          system_u:object_r:httpd_log_t:s0
    #重置context值。
    [root@alvin ~]# restorecon -vR /var/www/
    restorecon reset /var/www/html/file1 context unconfined_u:object_r:user_tmp_t:s0->unconfined_u:object_r:httpd_sys_content_t:s0
    #现在查看就发现file1的context值已经变成那个目录下的默认的context值了。
    [root@alvin ~]# ls -Z /var/www/html/file*
    -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file1
    -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2

使用semanage为新目录添加上下文。

.. code-block:: bash

    [root@alvin ~]# mkdir /alvin
    [root@alvin ~]# touch /alvin/index.html
    [root@alvin ~]# ls -Zd /alvin/
    drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /alvin/
    [root@alvin ~]# ls -Z /alvin/
    -rw-r--r--. root root unconfined_u:object_r:default_t:s0 index.html
    [root@alvin ~]# semanage fcontext -a -t httpd_sys_content_t '/alvin(/.*)?'
    [root@alvin ~]# restorecon -RFv /alvin/
    restorecon reset /alvin context unconfined_u:object_r:default_t:s0->system_u:object_r:httpd_sys_content_t:s0
    restorecon reset /alvin/index.html context unconfined_u:object_r:default_t:s0->system_u:object_r:httpd_sys_content_t:s0
    [root@alvin ~]# ls -Zd /alvin/
    drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /alvin/
    [root@alvin ~]# ls -Z /alvin/
    -rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 index.html

更改SELinux上下文
------------------------


查看当前SELinux的布尔值
============================
bool值是启动或禁用一组策略的开关。

- 查看所有策略的selinux bool值。

.. code-block:: bash

    getsebool -a

- 查看指定内容的selinux bool值

.. code-block:: bash

    getsebool zabbix_can_network

对指定服务设置SELinux bool值
====================================


.. code-block:: bash

    setsebool zabbix_can_network on
    getsebool zabbix_can_network #然后再查看验证一下。

对指定端口设置context
============================
我们在apache服务上又监听了一个端口8998，需要在selinux里为这个端口设置httpd_port_t的context才能启动服务。

.. code-block:: sh

    semanage port -a -t http_port_t -p tcp 8998

查看所有端口的context
=============================

.. code-block:: sh

    semanage port -l

selinux日志/排错
=========================

.. code-block:: sh

    yum install setroubleshoot
    sealert -a /var/log/audit/audit.log