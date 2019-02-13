alert(修改字段)
#######################


mysql里alert命令用来修改字段信息



alter|添加字段
---------------------------

::

    mysql> alter table clara add deptno int(10) not null;

alter|同时添加多个字段
===========================

::

    mysql> alter table clara add (mgrno int(10),mgr varchar(20));

alter|在指定字段后面添加字段
==================================

这里我们是指定在deptno后面添加一个hiredate的字段

::

    mysql> alter table clara add hiredate int(10) after deptno;

alter|在最前面添加字段
==================================

::

    mysql> alter table clara add empno int(10) first;

alter|修改字段信息
------------------------------


alter|改变字段信息和类型
==================================

使用change关键字时，字段后面需要再写上字段名，可以是新的字段名，也可以是原来的。

::

    mysql> alter table clara change eno eno char(20) not null;

alter|修改字段类型
==================================

这里我们使用到的关键字是modify，modify用于修改字段类型，不包括字段的名称

::

    mysql> alter table clara modify eno int(10) not null;

alter|修改字段类型和位置
==================================

这里我们将no换到了eno的后
同时我们之前设置的not null也失效了，因为刚才修改类型的时候没有加not null
将字段修改到最前端

::

    mysql> alter table clara modify eno int(10) first;

这里我们将policyGroup的位置放到id字段的后面。

::

    alter table apps_securitypolicy modify policyGroup longtext NOT NULL AFTER id

alter|删除字段
---------------------------

::

    mysql> alter table clara drop deptno;

alter|rename|修改表名
------------------------------

修改表名有三种方法

::

    mysql> alter table emp rename to emps;
    Query OK, 0 rows affected (0.00 sec)



