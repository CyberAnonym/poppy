registry
###########

创建ssl验证的

查看列表 https://k8s1.shenmin.com:5443/v2/nginx/tags/list


下载docker镜像
======================

.. code-block:: bash

    $ sudo docker pull registry:2
    $ HOSTNAME='k8s1.alv.pub'

在服务器端创建自定义签发的CA证书
============================================

.. code-block:: bash

    $ HOSTNAME='k8s1.shenmin.com'
    $ sudo mkdir -p /docker/certs
    $ sudo openssl req \
      -newkey rsa:4096 -nodes -sha256 -keyout /docker/certs/${HOSTNAME}.key \
      -x509 -days 365 -out /docker/certs/${HOSTNAME}.crt

上面创建证书的步骤的时候主要是在Common Name (eg, your name or your server's hostname) []:k8s1.alv.pub 这一行的后面，写上我们的用于解析到我们这台服务器的域名。


创建用于用户验证的相关文件和目录
========================================

.. code-block:: bash

    $ sudo mkdir -p /docker/auth
    $ sudo bash -c ' docker run --entrypoint htpasswd registry:2 -Bbn user1 123456 >> /docker/auth/htpasswd'
    $ sudo bash -c ' docker run --entrypoint htpasswd registry:2 -Bbn user2 123456 >> /docker/auth/htpasswd'

    $ sudo service docker restart


创建容器
===============

.. code-block:: bash

    $ sudo docker run -d -p 5443:5000 --restart=always --name registry-ssl \
      -v /docker/auth:/auth \
      -e "REGISTRY_AUTH=htpasswd" \
      -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
      -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
      -v /docker/certs:/certs \
      -v /data/registry:/var/lib/registry \
      -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/${HOSTNAME}.crt \
      -e REGISTRY_HTTP_TLS_KEY=/certs/${HOSTNAME}.key \
      registry:2


将证书传到需要使用registry的客户端并设置证书
=============================================================

- 这里我们把crt证书传到k8s2服务器上去。

.. code-block:: bash

    $ scp /docker/certs/${HOSTNAME}.crt k8s2:~

- 然后去k8s2上，将证书放到相应的目录下

这里我们的证书名是k8s1.alv.pub.crt

ubuntu系统下这样操作：

    .. code-block:: bash

        $ HOSTNAME='k8s1.alv.pub'
        $ sudo mkdir -p /etc/docker/certs.d/${HOSTNAME}:5443
        $ sudo cp ~/${HOSTNAME}.crt/etc/docker/certs.d/${HOSTNAME}:5443/


centos系统下这样操作：

    .. code-block:: bash

        $ HOSTNAME='k8s1.alv.pub'
        $ sudo mkdir -p /etc/docker/certs.d/${HOSTNAME}:5443
        $ sudo cp ${HOSTNAME}.crt /etc/docker/certs.d/${HOSTNAME}:5443


redhat系统下据说参考这个命令 ： cp ~/domain.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt

不过我没验证过，实际上我觉得可能和centos一样，也可能就是上面这个命令。


确认不使用代理
======================
该操作是可选操作。

如果docker使用了代理，/lib/systemd/system/docker.service文件里的环境变量设置了HTTPS_PROXY的值，那么需要在HTTPS_PROXY=后面添加我们的域名“k8s1.alv.pub"，多个地址时用逗号','分隔。

.. code-block:: bash

    $ sudo vim /lib/systemd/system/docker.service
    $ sudo systemctl daemon-reload
    $ sudo systemctl restart docker

登录远程docker仓库
============================

这里我们的docker 仓库地址是https://k8s1.alv.pub:5443, 我们使用如下命令登录登录仓库

- 交互式登录

    .. code-block:: bash

        $ sudo docker login k8s1.alv.pub:5443
        (用户名)
        (密码)

- 非交互式登录
    这里我们的用户名是user1,密码是123456

    .. code-block:: bash

        [alvin@k8s2 ~]$ sudo docker login  k8s1.alv.pub:5443 -uuser1 -p123456
        WARNING! Using --password via the CLI is insecure. Use --password-stdin.
        WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
        Configure a credential helper to remove this warning. See
        https://docs.docker.com/engine/reference/commandline/login/#credentials-store

        Login Succeeded



push或pull (上传或下载)镜像
=====================================

打一个tag，将一个本地镜像tag为我们目标私有仓库的镜像
----------------------------------------------------------------

.. code-block:: bash

    [alvin@k8s2 ~]$ sudo docker images|grep nginx
    nginx                                              latest              c82521676580        5 weeks ago         109MB
    nginx                                              1.14-alpine         acc350649a48        7 weeks ago         18.6MB
    [alvin@k8s2 ~]$
    [alvin@k8s2 ~]$ sudo docker tag acc350649a48 k8s1.alv.pub:5443/nginx/1.14-alpine

上传镜像到私有仓库
---------------------------

.. code-block:: bash

    [alvin@k8s2 ~]$ sudo docker push k8s1.alv.pub:5443/nginx/1.14-alpine
    The push refers to repository [k8s1.alv.pub:5443/nginx/1.14-alpine]
    2eb31a989e11: Pushed
    b87bb670f898: Pushed
    841051620742: Pushed
    717b092b8c86: Pushed
    latest: digest: sha256:c5fd932af67a2051ea8f784e4911bd8a1f29a7f9fcc4192e64f3f593878b114a size: 1153
    [alvin@k8s2 ~]$

删除原有本地镜像
------------------------------

.. code-block:: bash

    [alvin@k8s2 ~]$ sudo docker rmi k8s1.alv.pub:5443/nginx/1.14-alpine
    Untagged: k8s1.alv.pub:5443/nginx/1.14-alpine:latest
    Untagged: k8s1.alv.pub:5443/nginx/1.14-alpine@sha256:c5fd932af67a2051ea8f784e4911bd8a1f29a7f9fcc4192e64f3f593878b114a
    [alvin@k8s2 ~]$

从私有仓库上下载镜像
-------------------------------

.. code-block:: bash

    [alvin@k8s2 ~]$ sudo docker pull k8s1.alv.pub:5443/nginx/1.14-alpine
    Using default tag: latest
    latest: Pulling from nginx/1.14-alpine
    Digest: sha256:c5fd932af67a2051ea8f784e4911bd8a1f29a7f9fcc4192e64f3f593878b114a
    Status: Downloaded newer image for k8s1.alv.pub:5443/nginx/1.14-alpine:latest
    [alvin@k8s2 ~]$
    [alvin@k8s2 ~]$ sudo docker images|grep nginx
    nginx                                              latest              c82521676580        5 weeks ago         109MB
    nginx                                              1.14-alpine         acc350649a48        7 weeks ago         18.6MB
    k8s1.alv.pub:5443/nginx/1.14-alpine                latest              acc350649a48        7 weeks ago         18.6MB
