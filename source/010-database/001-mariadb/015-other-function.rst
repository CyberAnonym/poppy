其他功能
###########

MySQL开启general_log跟踪sql执行记录
===================================================


MySQL开启general_log跟踪sql执行记录

# 设置general log保存路径

# 注意在Linux中只能设置到 /tmp 或 /var 文件夹下，设置其他路径出错

# 需要root用户才有访问此文件的权限

Shell代码

::

    mysql>set global general_log_file='/tmp/general.lg';    #设置路径

    mysql>set global general_log=on;    # 开启general log模式

    mysql>set global general_log=off;   # 关闭general log模式

命令行设置即可,无需重启

在general log模式开启过程中，所有对数据库的操作都将被记录 general.log 文件



------------------------------------------------------------------------

或者

也可以将日志记录在表中

shell代码

      mysql>set global log_output='table'

运行后,可以在mysql数据库下查找 general_log表