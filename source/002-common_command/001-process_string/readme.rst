字符串处理
########################

.. toctree::
    :maxdepth: 2

    001-awk
    002-sed
    003-sort
    004-uniq
    005-grep
    006-cut
    007-tail
    008-head
    009-wc
    010-less
    011-regular
    012-echo




- 日常工作使用时的结合

#. 查找tomcat日志里最近30天的所有用户的uid。

.. code-block:: bash

    for file in $(for DAY in {1..30};do ls catalina.out.`date -d "$DAY day ago" +%Y-%m-%d`.log ;done);do grep "userid\":\"" $file |awk -F "userid\":\"" '{print $2}'|awk -F '"' '{print $1}'|sort -nr|uniq >> /tmp/user.log;done
