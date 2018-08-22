反向代理
#########

反向代理的内容，参考如下内容。

.. code-block:: bash

    server {
        charset utf-8;
        listen       80;
        server_name  alv.pub t.alv.pub sophiroth.com;

        proxy_set_header X-Forwarded-For $remote_addr;
        rewrite ^(.*) https://$server_name$1 permanent;


    }
    server {
        charset utf-8;
        listen       443 ssl;
        server_name  alv.pub t.alv.pub sophiroth.com;

        proxy_set_header X-Forwarded-Proto https;
        ssl_certificate      conf.d/alv.pub.pem;
        ssl_certificate_key  conf.d/alv.pub.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;
        proxy_set_header X-Forwarded-For $remote_addr;


        location ^~ /favicon.ico {
            root /home/alvin/ophira/static/img/;
        }
        location / {
            proxy_pass http://172.17.0.1:8001/;
        }
        location ^~ /zabbix/{
            proxy_pass http://172.17.0.1:801/zabbix/;
        }
         location ^~ /optimize/{
            proxy_pass https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/optimize_system.py;
        }
        location ^~ /open/api/weather/ {
            proxy_pass https://www.sojson.com/open/api/weather/;
        }
    }