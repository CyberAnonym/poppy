useradd
##########
添加系统用户


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
