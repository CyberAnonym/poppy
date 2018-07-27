iostat
#######


安装iostat命令
````````````````````
.. code-block:: bash

    yum install sysstat -y

查看所有磁盘io状态，每秒刷新一次
``````````````````````````````````````

.. code-block:: bash

    iostat 1

查看指定磁盘io状态，每秒刷新一次
`````````````````````````````````````

.. code-block:: bash

    iostat sda 1

