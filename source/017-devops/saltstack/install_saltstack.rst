
saltstack基本安装应用
-------------------------

SaltStack命令大全
：https://blog.csdn.net/bbwangj/article/details/78023354


Install epel repository
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # yum install epel-release -y

Install salt-master
~~~~~~~~~~~~~~~~~~~

::

    [root@saltstack ~]# yum install salt-master -y
    [root@saltstack ~]# salt --version
    salt 2015.5.10 (Lithium)

Install salt-minion
~~~~~~~~~~~~~~~~~~~

::

    # yum install salt-minion -y

Configure salt-minion
~~~~~~~~~~~~~~~~~~~~~

master的前面有两个空格，这里表示我要连接的saltstack的master是192.168.127.59

.. code:: bash

    # vim /etc/salt/minion
    master: 192.168.127.59

Configure salt-master
~~~~~~~~~~~~~~~~~~~~~

interface 前面同样有两个空格，否则启动的时候会报错。

::

    # vim /etc/salt/master
    interface: 192.168.127.59

启动salt-minion
~~~~~~~~~~~~~~~

.. code:: bash

    # systemctl start salt-minion

启动salt-master
~~~~~~~~~~~~~~~

.. code:: bash

    # systemctl start salt-master

测试saltstack
-------------

接下来的命令都在master上执行

查看minion列表
~~~~~~~~~~~~~~

.. code:: bash

    [root@saltstack _modules]# salt-key -L
    Accepted Keys:
    Denied Keys:
    Unaccepted Keys:
    saltstack.alv.pub
    Rejected Keys:

这里可以看到unaccepted Keys里面有我们的一个agent端,这里我们接受这个keys

::

    # salt-key -A
    y

(这里我们在db1上也安装了一个salt-minion,并配置启动了salt-minion,过程省略，和本文档上面安装配置salt-minion的一样。)
## docs

Salt编写自定模块：

官网文档：http://docs.saltstack.com/ref/modules/index.html#grains-data

Master上创建存放模块的目录：
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # mkdir -pv /srv/salt/_modules
    # cd /srv/salt/_modules

在\_modules目录下新建python文件作为自定义模块hello\_module.py
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    # vim hello_module.py
    #encoding = utf8

    def say_hello():
        return 'hello salt'

保存文件，然后执行同步modules命令 salt '\*' saltutil.sync\_modules

::

    [root@saltstack _modules]#  salt '*' saltutil.sync_modules
    db1.alv.pub:
        - modules.hello_module
    saltstack.alv.pub:
        - modules.hello_module

这样modules就算建好了，可以通过 salt '\*'
hello\_module.say\_hello来执行此自定义module

::

    [root@saltstack _modules]# salt '*' hello_module.say_hello
    saltstack.alv.pub:
        hello salt
    db1.alv.pub:
        hello salt

再来定义一个模块玩玩

这种salt的模块也就是一个python脚本，我们在里面写函数，然后让salt-master调用里面的函数实现一些功能。

我们return的东西，就是会打印出来的东西。

::

    [root@saltstack _modules]# vim whoyou.py
    #!/usr/bin/python
    #coding:utf-8
    import socket,subprocess
    hostname=socket.gethostname()
    whouser=subprocess.check_output('whoami',shell=True).split('\n')[0]

    def whathere():
            return ('This is '+ hostname + ' and user is ' + whouser)

- 这次我们只将模块同步到db1去


.. code:: bash

    [root@saltstack _modules]# salt 'db1.alv.pub' saltutil.sync_modules

    db1.alv.pub:
        - modules.whoyou

- 然后让db1上执行一下


.. code:: bash

    [root@saltstack _modules]# salt 'db1.alv.pub' whoyou.whathere
    db1.alv.pub:
        This is db1.alv.pub and user is root

这个时候如果我们是指定主机时指定\* 呢？
那么没被同步模块的服务器，会显示模块不可用。

.. code:: bash

    [root@saltstack _modules]# salt '*' whoyou.whathere
    db1.alv.pub:
        This is db1.alv.pub and user is root
    saltstack.alv.pub:
        Module 'whoyou' is not available.
    ERROR: Minions returned with non-zero exit code

指定主机名时也可以使用匹配

\`\`\`bash [root@saltstack \_modules]# salt '\*.alv.pub' whoyou.whathere
db1.alv.pub: This is db1.alv.pub and user is root saltstack.alv.pub:
Module 'whoyou' is not available. ERROR: Minions returned with non-zero
exit code

\`\`\`

salt 自带模块
-------------

test.ping
~~~~~~~~~~~~~~~

.. code:: bash

    [root@saltstack _modules]# salt '*' test.ping
    saltstack.alv.pub:
        True
    db1.alv.pub:
        True

cmd.run, 直接运行系统命令。
~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    [root@saltstack ~]# salt '*' cmd.run 'hostname'
    saltstack.alv.pub:
        saltstack.alv.pub
    db1.alv.pub:
        db1.alv.pub

