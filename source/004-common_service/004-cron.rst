cron
####
linux下的定时任务

启动服务
============

.. code-block:: bash

    systemctl start crond


使用crontab设置定时任务
============================

为当前用户设置cron任务

.. code-block:: bash

    crontab -e

为指定用户alvin设置cron任务,每分钟执行一次ls

.. code-block:: bash

    crontab -e -u alvin
    * * * * * ls

查看alvin的cron任务

.. code-block:: bash

    crontab -l -u alvin


.. code-block:: text

    基本格式 :
    *　　*　　*　　*　　*　　command
    分　时　日　月　周　命令
    第1列表示分钟1～59 每分钟用*或者 */1表示
    第2列表示小时1～23（0表示0点）
    第3列表示日期1～31
    第4列表示月份1～12
    第5列标识号星期0～6（0表示星期天）
    第6列要运行的命令
    crontab文件的一些例子：
    30 21 * * * /usr/local/etc/rc.d/lighttpd restart
    上面的例子表示每晚的21:30重启apache。
    45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart
    上面的例子表示每月1、10、22日的4 : 45重启apache。
    10 1 * * 6,0 /usr/local/etc/rc.d/lighttpd restart
    上面的例子表示每周六、周日的1 : 10重启apache。
    0,30 18-23 * * * /usr/local/etc/rc.d/lighttpd restart
    上面的例子表示在每天18 : 00至23 : 00之间每隔30分钟重启apache。
    0 23 * * 6 /usr/local/etc/rc.d/lighttpd restart
    上面的例子表示每星期六的11 : 00 pm重启apache。
    0 */1 * * * /usr/local/etc/rc.d/lighttpd restart
    每一小时重启apache
    0 23-7/1 * * * /usr/local/etc/rc.d/lighttpd restart
    晚上11点到早上7点之间，每隔一小时重启apache
    0 11 4 * mon-wed /usr/local/etc/rc.d/lighttpd restart
    每月的4号与每周一到周三的11点重启apache
    0 4 1 jan * /usr/local/etc/rc.d/lighttpd restart
    一月一号的4点重启apache

