echo
##########

打印字符串，相当于python里的print


打印alvin
============

.. code-block:: bash

    echo hello

格式化打印，换行
===================
-e参数，表示格式化打印，会将相应的参数转为对应的形式，比如将\n转换为换行。

.. code-block:: bash
    :linenos:
    :emphasize-lines: 3

    [alvin@poppy ~]$ echo 'hello\nworld'
    hello\nworld
    [alvin@poppy ~]$ echo -e 'hello\nworld'
    hello
    world

显示结果定向至文件
=========================
.. code-block:: bash

    [alvin@poppy ~]$ echo 'Alvin Daily' > file
    [alvin@poppy ~]$ cat file
    Alvin Daily

显示结果追加至文件
=========================
.. code-block:: bash
    :linenos:
    :emphasize-lines: 3

    [alvin@poppy ~]$ cat file
    Alvin Daily
    [alvin@poppy ~]$ echo 'Yes this is Alvin' >> file
    [alvin@poppy ~]$ cat file
    Alvin Daily
    Yes this is Alvin

原样输出字符串，不进行转义或取变量(用单引号)
======================================================

.. code-block:: bash

    [alvin@poppy ~]$ name='alvin'
    [alvin@poppy ~]$ echo '$name\"'
    $name\"

显示命令执行结果
======================

.. code-block:: bash

    [alvin@poppy ~]$ echo `date`
    Mon Aug 13 17:14:20 CST 2018

