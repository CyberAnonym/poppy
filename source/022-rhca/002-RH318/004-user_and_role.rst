第四章：用户和角色还有权限的管理
########################################

配置ipa服务器
=====================

这里我们将ipa和存储都放在一台服务器上，是api服务器也是存储服务器，环境有需要的时候，放两台服务器也可以。

ipa服务器我们同样也是关闭了selinux和firewalld, 这里我们不考虑这些配置，直接关闭。

系统使用的是rhel7.3


安装软件
--------------
Identity Authentication

api-server是我们的目录服务，i代表的是Identity，验证，p是Policy，策略,a就是Audit,审计
这里我们要安装dns服务bind的一些软件，和ipa-server

.. code-block:: bash

    [root@ipa ~]# yum install bind bind-dyndb-ldap bind-libs bind-utils ipa-server ipa-server-dns -y



ipa-server的安装
------------------------
现在我们先安装dns, 如果提示是否要覆盖bind配置，就填写yes，确认覆盖

这里要注意，我们要配置的域，不要与已存在的域冲突，不要与/etc/resolv.conf里配置的信息冲突。 密码我们都设置成了redhat123

    - Existing BIND configuration detected, overwrite? [no]: yes
    - Do you want to configure DNS forwarders? [yes]: no
    - Continue to configure the system with these values? [no]: yes

.. code-block:: bash

    [root@ipa ~]# ipa-server-install --setup-dns
    ...
    ...
    Restarting the web server
    ==============================================================================
    Setup complete

    Next steps:
        1. You must make sure these network ports are open:
            TCP Ports:
              * 80, 443: HTTP/HTTPS
              * 389, 636: LDAP/LDAPS
              * 88, 464: kerberos
              * 53: bind
            UDP Ports:
              * 88, 464: kerberos
              * 53: bind
              * 123: ntp

        2. You can now obtain a kerberos ticket using the command: 'kinit admin'
           This ticket will allow you to use the IPA tools (e.g., ipa user-add)
           and the web user interface.

    Be sure to back up the CA certificate stored in /root/cacert.p12
    This file is required to create replicas. The password for this
    file is the Directory Manager password

然后要重新获取下管理员的密码，这里我们的密码之前设置的是redhat123

.. code-block:: bash

    [root@ipa ~]# kinit admin
    Password for admin@ALV.PUB:

.. note::

    因为环境里涉及到了kerberos，住寂寞就是主机名，IP就是IP，不可以通用的，长主机名不可和短主机名混用。


登录、使用ipa
==================

客户端做好域名解析之后，通过域名https://ipa.alv.pub访问ipa ，

.. image:: ../../../images/ha/020.png


用户名是admin,密码是我们前面设置的redhat123

.. image:: ../../../images/ha/021.png


然后user界面可以去添加用户，网络服务里可以去配置dns。

我们可以把我们的RHEVM添加到这里面来，添加进来之后，我们在这里创建的一系列用户名，就都可以再RHEVM里设置了。


添加dns解析
===============

现在我们点击 service, dns， 来添加一条dns解析
    先点击alv.pub. 表示我们是要在这个域里添加解析， 然后点add,然后填写解析信息

    .. image:: ../../../images/ha/022.png

    这样，我们就成功添加了

    .. image:: ../../../images/ha/023.png


    然后我们以同样的方式添加其他几台主机，rhvh1 rhvh2

添加用户
==============

这里我们添加一个用户tom

    .. image:: ../../../images/ha/024.png

然后用同样的方式添加一个bob


然后我们添加一个管理员账号，用于给普通用户授权




