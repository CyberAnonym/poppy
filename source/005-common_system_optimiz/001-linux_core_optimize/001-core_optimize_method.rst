优化Linux内核参数的方法
##################################

这里我们举例通过修改内核参数开启路由转发功能,控制该功能的是/proc/sys/net/ipv4/ip_forward这个文件的值，若为0，是关闭，若为1，则是开启。

直接修改文件（临时生效）
===============================


.. code-block:: bash

    $ sudo echo "1" > /proc/sys/net/ipv4/ip_forward

一条命令修改（临时生效）
===========================

.. code-block:: bash

    $ sudo sysctl -w net.ipv4.ip_forward=1

修改配置文件（永久生效）
============================


- 先修改/etc/sysctl.conf

.. code-block:: bash

    $ sudo vim /etc/sysctl.conf
    net.ipv4.ip_forward = 1

- 然后执行以下命令，永久生效

.. code-block:: bash

    $ sudo sysctl -p

- 查看验证

.. code-block:: bash

    $ cat /proc/sys/net/ipv4/ip_forward

.. note::

    在/etc/sysctl.conf 文件里写的配置，比如我们填写net.ipv4.ip_forward = 1，代表我们要将后面的这个值1写入到 /proc/sys/net/ipv4/ip_forward，也就是将.换成/，然后前面加上/proc/sys/，
    这个配置文件里配置的内核参数，都是才/proc/sys目录下的。

