uniq
####
将相连的重复的行和并

.. code-block:: bash

    [root@alvin tmp]# cat file
    aaa
    aaa
    aaa
    bbbbb
    bbbbb
    cc
    aaa
    [root@alvin tmp]# uniq file
    aaa
    bbbbb
    cc
    aaa
    [root@alvin tmp]# uniq -c file
          3 aaa
          2 bbbbb
          1 cc
          1 aaa
    [root@alvin tmp]#

一般我们可以配合sort使用，如果想让不相连的行也合并唯一。
-----------------------------------------------------------------

.. code-block:: bash

    [root@alvin tmp]# cat file
    aaa
    aaa
    aaa
    bbbbb
    bbbbb
    cc
    aaa
    [root@alvin tmp]# sort file |uniq -c
          4 aaa
          2 bbbbb
          1 cc
    [root@alvin tmp]#
