usermod
###########

所以的所属组有主属组和附属组，主属组只有一个，附属组可以有多个， 正常情况下，该用户的主属组就是该用户创建的一个文件或目录所属组。


修改poppy用户的附属组，添加附属组为root
==================================================

.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,4,5

    [root@poppy ~]# id poppy
    uid=1000(poppy) gid=1000(poppy) groups=1000(poppy)
    [root@poppy ~]#
    [root@poppy ~]# usermod -aG root poppy
    [root@poppy ~]# id poppy
    uid=1000(poppy) gid=1000(poppy) groups=1000(poppy),0(root)

修改poppy用户的主属组，该为sophiroth组
=================================================
.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,4,6

    [root@poppy ~]# id poppy
    uid=1000(poppy) gid=1000(poppy) groups=1000(poppy),0(root)
    [root@poppy ~]#
    [root@poppy ~]# usermod -g sophiroth poppy
    [root@poppy ~]#
    [root@poppy ~]# id poppy
    uid=1000(poppy) gid=10001(sophiroth) groups=10001(sophiroth),0(root)
