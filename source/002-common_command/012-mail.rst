mail
####


查看当前系统下指定用户的邮件
=================================
.. code-block:: bash

    mail -u alvin

安装mailx
===============
安装mailx后可以通过配置/etc/mail.rc(centos下) 或/etc/nail.rc （ubuntu下）来设置linux下的邮件发件信息。

centos 下安装

.. code-block:: bash

    # yum install mailx -y


ubuntu下安装

.. code-block:: bash

    $ sudo apt-get install heirloom-mailx

配置mailx
================

.. code-block:: bash

    # vim /etc/mail.rc
    set from=notify@51alvin.com
    set smtp=smtp.exmail.qq.com
    set smtp-auth-user=notify@51alvin.com
    set smtp-auth-password=Alvin-Notify2016
    set smtp-auth=login

发送邮件
==========
发送邮件给alvin.wan@sophroth.com ，邮件内容是email content,邮件主题是mail subject

.. code-block:: bash

    # echo "email content"|mail -s "mail subject" alvin.wan@sophiroth.com