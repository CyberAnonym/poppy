htpasswd添加用户名密码验证
####################################



通过htpasswd命令生成用户名及对应密码数据库文件
============================================================


.. code-block:: bash

    $ mkdir -p /etc/nginx/dbs
    $ htpasswd -c /etc/nginx/dbs/rhca.db alvin
    New password:   #输入密码
    Re-type new password:   #确认密码
    Adding password for user alvin
    $ chmod 600 /etc/nginx/dbs/rhca.db
    $ chown nginx:nginx /etc/nginx/dbs/ -R



将验证信息配置到nginx的配置文件里去
============================================

这里我们在需要验证的地方添加auth_basic和auth_basic_user_file这两行内容。


.. code-block:: bash

    $ vi /etc/nginx/conf.d/rhca_exam.conf
    location / {
        auth_basic "alvin";
        auth_basic_user_file /etc/nginx/dbs/rhca.db;
            root /var/www/rhca_exam/build/html/;
    }
