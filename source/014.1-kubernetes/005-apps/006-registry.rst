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

    HOSTNAME='k8s1.shenmin.com'
    mkdir -p /docker/certs
    openssl req \
      -newkey rsa:4096 -nodes -sha256 -keyout /docker/certs/${HOSTNAME}.key \
      -x509 -days 365 -out /docker/certs/${HOSTNAME}.crt

创建用于用户验证的相关文件和目录
========================================

.. code-block:: bash

    mkdir -p /docker/auth
    docker run --entrypoint htpasswd registry:2 -Bbn user1 123456 >> /docker/auth/htpasswd
    docker run --entrypoint htpasswd registry:2 -Bbn user2 123456 >> /docker/auth/htpasswd

    sudo service docker restart


创建容器
===============

.. code-block:: bash

    docker run -d -p 5443:5000 --restart=always --name registry-ssl \
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

    scp ${hostname}.crt k8s2:~

- 然后去k8s2上，将证书放到相应的目录下

这里我们的证书名是k8s1.alv.pub.crt

ubuntu系统下这样操作：

    .. code-block:: bash

        HOSTNAME='k8s1.alv.pub'
        sudo mkdir -p /etc/docker/certs.d/${HOSTNAME}:5443
        sudo cp ~/${HOSTNAME}.crt/etc/docker/certs.d/${HOSTNAME}:5443/


centos系统下这样操作：

    .. code-block:: bash

        HOSTNAME='k8s1.alv.pub'
        sudo mkdir -p /etc/docker/certs.d/${HOSTNAME}:5443
        sudo cp ${HOSTNAME}.crt /etc/docker/certs.d/${HOSTNAME}:5443


redhat系统下据说参考这个命令 ： cp ~/domain.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt

不过我没验证过，实际上我觉得可能和centos一样，也可能就是上面这个命令。


确认不使用代理
======================
该操作是可选操作。

如果docker使用了代理，/lib/systemd/system/docker.service文件里的环境变量设置了HTTPS_PROXY的值，那么需要在HTTPS_PROXY=后面添加我们的域名“k8s1.alv.pub"，多个地址时用逗号','分隔。

.. code-block:: bash

    $ sudo vim /lib/systemd/system/docker.service


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

        $ sudo docker login  k8s1.alv.pub:5443 -uuser1 -p123456