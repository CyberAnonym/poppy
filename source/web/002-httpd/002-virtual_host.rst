virtual host
################
apache的虚拟主机配置

下面我们配置两个虚拟主机，实现以下效果：

#. 访问qq.com, 会访问到/qq目录里的内容
#. 访问weibo.com，会访问到/weibo目录里的内容。

.. code-block:: bash

    echo 127.0.0.1 qq.com >> /etc/hosts
    echo 127.0.0.1 weibo.com >> /etc/hosts
    mkdir -p /{qq,weibo}
    echo qq > /qq/index.html
    echo weibo > /weibo/index.html
    semanage fcontext -a -t httpd_sys_content_t '/qq(/.*)?'
    semanage fcontext -a -t httpd_sys_content_t '/weibo(/.*)?'
    restorecon -Rv /qq
    restorecon -Rv /weibo
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
    cp /usr/share/doc/httpd-2.4.6/httpd-vhosts.conf /etc/httpd/conf.d/
    echo '
    #Define Virtual host
    <VirtualHost *:80>
        DocumentRoot /qq
        ServerName qq.com
    </VirtualHost>
    #Grant permission to the directory
    <Directory "/qq">
        Require all granted
    </Directory>

    <VirtualHost *:80>
        DocumentRoot /weibo
        ServerName weibo.com
    </VirtualHost>
    <Directory "/weibo">
        Require all granted
    </Directory>
    ' >> /etc/httpd/conf.d/httpd-vhosts.conf
    systemctl restart httpd
    curl qq.com
    curl weibo.com
