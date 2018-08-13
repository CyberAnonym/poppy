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

