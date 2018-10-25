cifs文件系统常见报错
#############################

mount error(5): Input/output error
===========================================

这里我们挂载的是一个windows的目录共享，然后报了这样一个错误

.. code-block:: bash

    $ mount //alvin.alv.pub/rhca/ /alvin -o user=alvin.wan.cn@hotmail.com,password=password
    mount error(5): Input/output error
    Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

这是因为，我们使用的是域名，如果使用ip地址，就不会报错了。


.. code-block:: bash

    $ mount //192.168.127.38/d/ /alvin -o user=alvin.wan.cn@hotmail.com,password=password