mail
####


查看当前系统下指定用户的邮件
=================================
.. code-block:: bash

    mail -u alvin

发送邮件
==========
发送邮件给alvin.wan@sophroth.com ，邮件内容是email content,邮件主题是mail subject

.. code-block:: bash

    # echo "email content"|mail -s "mail subject" alvin.wan@sophiroth.com