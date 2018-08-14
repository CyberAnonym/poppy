管理系统用户(综合篇)
###########################


创建用户
==================

参数和关键字解释：

* Uid： 用户id，user id
* Gid： 组id，group id

- -u 指定uid
- -g 指定主属组id
- -G 指定付属组id
- -d 指定home目录
- -s 指定shell
- -c 备注
- -M 不创建home目录
- -N 不创建组

Example:

- 创建用户user1

::

    useradd user1

给user1设置密码
::

    passwd user1

无交互式的方式给user1设置密码，密码设置为sophiroth
::

    echo sophiroth|passwd --stdin user1

创建用户user2，并指定uid为501
::

    useradd -u 501 user2

创建用户user3，指定uid为502，并指定gid为501，也就是user2的组，刚才创建user2的时候默认也创建了uid为502的组。
::

    useradd -u 502 -g 501 user3

用户添加的时候系统做的操作
=====================================
1，	用户添加的时候系统做了哪些事情呢？

#. 在/etc/passwd文件中加了一行
#. 在/etc/shadow文件中加了一行
#. 在/etc/group文件中加了一行
#. 在/etc/gshadow文件中加了一行
#. 在/home目录下建立一个和用户名同名的家目录，同时复制/etc/skel/所有的文件到此用户的家目录下

普通用户自己修改密码
================================

.. code-block:: bash
    :linenos:

    [root@os1 ~]# su - user1
    [user1@os1 ~]$ passwd
    Changing password for user user1.
    Changing password for user1.
    (current) UNIX password:
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.


查看普通用户
===========================

通过passwd文件查看普通用户的信息
-------------------------------------

.. code-block:: bash
    :linenos:

    [root@os1 ~]# tail -3 /etc/passwd
    user1:x:1010:1011::/home/user1:/bin/bash
    user2:x:501:501::/home/user2:/bin/bash
    user3:x:502:501::/home/user3:/bin/bash

通过id 查看普通用户的信息
----------------------------

.. code-block:: bash
    :linenos:

    [root@os1 ~]# id user2
    uid=501(user2) gid=501(user2) groups=501(user2)

通过finger查看用户的描述信息
-----------------------------

.. code-block:: bash
    :linenos:

    [root@os1 ~]# finger user1
    Login: user1          			Name:
    Directory: /home/user1              	Shell: /bin/bash
    Never logged in.
    No mail.
    No Plan.
    [root@os1 ~]#

用户的修改
=======================

修改主属组
----------------

这里我们可以看到user1当前的gid是1011，user2当前的gid是501， 通过usermod命令，我们可以将user2的gid改成1011.

.. code-block:: bash
    :emphasize-lines: 6

    [root@os1 ~]# id user1
    uid=1010(user1) gid=1011(user1) groups=1011(user1)
    [root@os1 ~]#
    [root@os1 ~]# id user2
    uid=501(user2) gid=501(user2) groups=501(user2)
    [root@os1 ~]# usermod -g 1011 user2
    [root@os1 ~]#
    [root@os1 ~]# id user2
    uid=501(user2) gid=1011(user1) groups=1011(user1)

修改副属组
-------------
::

    [root@os1 ~]# id user1
    uid=1010(user1) gid=1011(user1) groups=1011(user1)
    [root@os1 ~]# id user3
    uid=502(user3) gid=501(user2) groups=501(user2)
    [root@os1 ~]# usermod -G 1011 user3
    [root@os1 ~]# id user3
    uid=502(user3) gid=501(user2) groups=501(user2),1011(user1)

用户删除
=======================

用户删除的命令是userdel， 加-r ，会将 用户的home目录，和邮件等内容也全部删除，不加-r，则会保存那些数据

- 默认用户的家目录不删除

::

    [root@os1 ~]# userdel user1

- 删除用户的同时删除用户的家目录以及mail相关信息

::

    [root@os1 ~]# userdel -r user3

