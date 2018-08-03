ssh
###
ssh - Secure Shell

安装ssh服务
===============
.. code-block:: bash

    yum install openssh-server


配置文件
===============

.. code-block:: bash

    vim /etc/ssh/sshd_config

拒绝指定网络的用户访问
==================================

.. code-block:: bash

    vim /etc/ssh/sshd_config
    DenyUsers *@192.168.127.*


连接目标ssh服务
====================

- ssh客户端需要安装想用的工具，这里我们安装openssh-clients

.. code-block:: bash

    yum install openssh-clients

- 这里我们连接dc.alv.pub的ssh服务，使用默认端口

.. code-block:: bash

    ssh dc.alv.pub

- 如果ssh服务端口有修改，比如修改成了662，那么这里我们使用662端口去访问ssh服务

.. code-block:: bash

    ssh -p 662 dc.alv.pub

- 指定端口使用scp复制

.. code-block:: bash

    scp -P662 dc.alv.puub:/tmp/file.txt /tmp/file.txt

