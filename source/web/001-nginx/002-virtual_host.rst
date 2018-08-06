virtual host
###############



.. code-block:: bash

    nginx_conf=/etc/nginx/conf.d/sophiroth.conf
    echo '127.0.0.1 aaa.qq.com ' >> /etc/hosts
    echo '127.0.0.1 bbb.qq.com' >> /etc/hosts
    mkdir -p /{aaa,bbb}
    echo aaa >> /aaa/index.html
    echo bbb >> /bbb/index.html
    semanage fcontext -a -t httpd_sys_content_t '/aaa(/.*)?'
    semanage fcontext -a -t httpd_sys_content_t '/bbb(/.*)?'
    restorecon -Rv /aaa/
    echo '
    server {
        charset utf-8;
        listen       80;
        server_name  aaa.qq.com;
        location / {
            root /aaa;
        }
    }
    server {
        charset utf-8;
        listen       80;
        server_name  bbb.qq.com;
        location / {
            root /bbb;
        }
    }
    ' >> $nginx_conf
    systemctl restart nginx
    curl aaa.qq.com
    curl bbb.qq.com