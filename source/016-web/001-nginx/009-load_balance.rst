负载均衡
#########


这里我们通过nginx设置一个负载均衡，通过http://k8s2.shenmin.com:80访问进来的请求会被转发到 http://192.168.1.52:8080 和 http://192.168.1.53:8080 上去。

.. code-block:: bash

    # vim /etc/nginx/conf.d/java.conf
    upstream java {
        server 192.168.1.52:8080;
        server 192.168.1.53:8080;
    }
    server {
        charset utf-8;
        listen       80;
        server_name  k8s2.shenmin.com 192.168.1.52;
        proxy_set_header X-Forwarded-For $remote_addr;
        location / {
            proxy_pass http://java;
        }
    }