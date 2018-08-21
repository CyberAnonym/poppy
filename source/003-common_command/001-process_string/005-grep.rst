grep
####

过滤文本

echo 可以使用正则，正则语法 `点击这里`_

.. _点击这里 : ./011-regular.html

参数解释
==============

.. code-block:: text

    -E 开启正则匹配，如过滤包含aa或bb，使用grep -E "aa|bb" file
    -v 反向指定，过滤出不包含指定值的行， grep -v aa file
    -i 不区分大小写
    grep -a
    过滤二机制文件。

    grep -E 'a|b'  、
    过滤包含a 或者包含b的行

    grep -i
    不区分大小写

    grep -n
    顺便输出行号

    grep --color=auto
    将关键字加颜色

    grep -A2 '4' 3.sh
    过滤出包含指定字符串的内容并输出其下两行

    grep -B1 '4' 3.sh
    过滤出包含指定字符串的内容并输出其上两行


    grep -b2 '4' 3.sh
    过滤出包含4的行并输出其上下两行

过滤包含aa的行
===================

.. code-block:: bash

    [root@alvin tmp]# cat file
    aaa
    aaa
    aaa
    bbbbb
    bbbbb
    cc
    aaa
    [root@alvin tmp]# grep aa file
    aaa
    aaa
    aaa
    aaa


过滤出不包含aa的行
===========================
.. code-block:: bash

    [root@alvin tmp]# grep -v aa file
    bbbbb
    bbbbb
    cc

过滤出不包含aa和bb的行
===========================

.. code-block:: bash

    [root@alvin tmp]# grep -Ev "aa|bb" file
    cc



