date
###############
date命令用于格式化打印当前日期。

Description
==============
Display the current time in the given FORMAT, or set the system date.




- 格式

    date +参数，  比如date +%Y,

    有多个参数的时候，可以继续写在后面，参数之间可以不用空格，也可以用字符串去连接参数，比如date +%Y-%m,  用于连接参数的字符串也可以是空格，但空格需要以字符串的数据类型表示，所以需要加引号，date +%Y' '%m


查看当前日期

.. code-block:: bash

    [root@natasha ~]# date
    Thu Aug  9 09:45:17 CST 2018


date的各种参数，在该日期使用时会打印的内容


.. code-block:: text

    date +%s 取时间戳

    向date命令传递参数适用‘+‘（加号），在传递的参数中

    %Y表示年 2018

    %m表示月 08

    %d表示天 09

    %H表示小时 09（表示的时间是00-23）

    %M表示分钟  45

    %S表示秒 12

    %s  （表示unix时间戳的秒数,这里示例的时间戳不对应上面的额准确时间）1533779327

    %B 英文月份 August

    %b 英文月份缩写 Aug

    %A 英文星期几 Thursday

    %a 英文星期几缩写 Thu



Example
===============

查看当前时间包含年月日时分秒
`````````````````````````````

.. code-block:: bash

    [root@natasha ~]# date  +%Y-%m-%d' '%H:%M:%S
    2018-08-09 09:37:06



指定前一天
````````````
date -d '1 days ago' +%Y%m%d


指定前一个月
``````````````````

date -d '1 month ago' +%Y%m%d

指定前五分钟
`````````````````````

date -d '5 minute ago' +%Y%m%d-%H:%M:%S

