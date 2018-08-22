tcp转发
########

将本地666端口转发到本地105端口

::

    stream {
        upstream proxy_card {
            # simple round-robin 转发IP和端口
            server localhost:105;
            server localhost:105;
            #check interval=3000 rise=2 fall=5 timeout=1000;
            #check interval=3000 rise=2 fall=5timeout=1000
            #check interval=3000 rise=2 fall=5timeout=1000
            #check_http_send "GET /HTTP/1.0\r\n\r\n";
            #check_http_expect_alive http_2xxhttp_3xx;
        }
        server {
            listen 666; ##监听端口
            proxy_pass proxy_card;  #转发请求
        }
    }

本地的3389端口转发到另一台服务器的3389端口，（3389是windows远程桌面端口）

::

    stream {
        upstream bi_remote_desk {
            server 192.168.1.218:3389;
        }
        server {
            listen 3389; ##监听端口
            proxy_pass bi_remote_desk;  #转发请求
        }
    }


定义多个端口转发
======================

这是我的生产配置：

::

    #sudo vim /etc/nginx/nginx.conf
    stream {
        upstream bi_remote_desk {
            # simple round-robin 转发IP和端口
            server 192.168.0.234:3389;
            #check interval=3000 rise=2 fall=5 timeout=1000;
            #check interval=3000 rise=2 fall=5timeout=1000
            #check interval=3000 rise=2 fall=5timeout=1000
            #check_http_send "GET /HTTP/1.0\r\n\r\n";
            #check_http_expect_alive http_2xxhttp_3xx;
        }
        server {
            listen 3389; ##监听端口
            proxy_pass bi_remote_desk;  #转发请求
        }
        upstream 214_ssh {
            server 192.168.0.235:22;
        }
        server {
            listen 105; ##监听端口
            proxy_pass 214_ssh;  #转发请求
        }
    }