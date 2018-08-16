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
    013-read
    014-seq
    015-vim



- 日常工作使用时的结合

#. 查找tomcat日志里最近30天的所有用户的uid。

.. code-block:: bash

    for file in $(for DAY in {1..30};do ls catalina.out.`date -d "$DAY day ago" +%Y-%m-%d`.log ;done);do grep "userid\":\"" $file |awk -F "userid\":\"" '{print $2}'|awk -F '"' '{print $1}'|sort -nr|uniq >> /tmp/user.log;done

#. 查找本书poppy里面用了多少linux下系统命令。

.. code-block:: bash

    $ cd poppy/source
    $ a=1;for i in `find . -name '*.rst'|awk -F "/" '{print $NF}'|awk -F "-" '{print $2}'|sed '/^$/d'|sed 's/.rst//'`;do which $i 2>/dev/null && ((a++));done|sort |cat -n
