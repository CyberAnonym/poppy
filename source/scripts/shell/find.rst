
find
##############

.. contents::


查看指定目录内两分钟内有修改的文件
``````````````````````````````````````
::

    find /var/log -cmin -2

查看两天内有修改过的文件
````````````````````````````

::

    find . -ctime -2

查看指定目录内命名为指定名称的文件
``````````````````````````````````````````
::

    find . -name original-ks.cfg

支持通配符,使用通配符的是要要加引号。

::

    find /var/log/ -name '*.log'


要忽略 a 目录：
```````````````````
::

    find . -path ./a -prune -o -type f -name s.txt -print


查找当前目录下的所有*.doc文件并将所有结果复制到 /tmp/doc 目录下
```````````````````````````````````````````````````````````````

.. code-block:: bash

    find . -iname "*.doc" -type f -exec cp {} /tmp/doc /;