registry
###########

创建ssl验证的

#查看列表 https://k8s1.shenmin.com:5443/v2/nginx/tags/list

这里我们registry所在服务器使用的域名是registry.alv.pub



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


使用k8s创建registry
===========================

这里我们registry所在服务器使用的域名是registry.alv.pub

现在我们使用k8s来创建registry 的deployment， 私有仓库是需要存储镜像，如果存储在host上面，那么下次deployment将pod调度到别的node上去之后，就没有之前的镜像数据了。

所以这里我们使用nfs来存储数据。

创建nfs存储卷
-----------------------
我们先在一台专门用于存储数据的服务器上创建一个用于存储registry数据的目录，然后将它用nfs共享。

.. code-block:: bash

    [root@dc ~]# yum install nfs-utils -y
    [root@dc ~]# mkdir -p /registry/data
    [root@dc ~]# mkdir -p /registry/config
    [root@dc ~]# vim /etc/exports
    /registry   *(rw,async,no_root_squash)
    [root@dc ~]# systemctl start nfs-server
    [root@dc ~]# systemctl enable nfs-server
    [root@dc ~]# exportfs -rv
    exporting *:/registry
    [root@dc ~]#
    [root@dc ~]# showmount -e localhost
    Export list for localhost:
    /registry           *

编写registry配置文件
------------------------------------

然后编写registry的配置文件，这里我们主要是将delete设置为true，这样才能删除镜像。

.. code-block:: bash

    [root@dc ~]# vim /registry/config/config.yml
    version: 0.1
    log:
      level: info
      formatter: text
      fields:
        service: registry
        environment: production
    storage:
      cache:
        layerinfo: inmemory
      filesystem:
        rootdirectory: /var/lib/registry
      delete:
        enabled: true
    http:
      addr: :5000
      debug:
        addr: :5001

编写registry的yaml文件
----------------------------------

这里我的nfs服务器所在的ip是192.168.127.54， 所以下面的文件中我写的是这个IP。

.. code-block:: bash

    [alvin@k8s1 ~]$ vim registry.yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: registry
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            run: registry
        spec:
          containers:
          - name: registry
            resources:
              limits:
                cpu: 2
                memory: 200Mi
              requests:
                cpu: 0.5
                memory: 100Mi
            image: registry:2
            ports:
            - containerPort: 5000
              protocol: TCP
              name: registry-port
            volumeMounts:
            - name: registry-nfs-data
              mountPath: /var/lib/registry
              readOnly: false
            - name: registry-nfs-config
              mountPath:  /etc/docker/registry
              readOnly: true
          volumes:
          - name: registry-nfs-data
            nfs:
              server: 192.168.127.54
              path: '/registry/data'
          - name: registry-nfs-config
            nfs:
              server: 192.168.127.54
              path: '/registry/config'

    ---

    apiVersion: v1
    kind: Service
    metadata:
      name: registry-svc
      labels:
        run: registry-svc
    spec:
      ports:
      - port: 5000
        protocol: TCP
      selector:
        run: registry
      type: NodePort
      ports:
      - port: 5000
        targetPort: 5000
        nodePort: 30001


创建registry的deployment 和service
----------------------------------------

.. code-block:: bash

    $ kubectl create -f registry.yaml

修改客户端docker配置，使得私有仓库可用
----------------------------------------------

这里我们使用的是非ssl的http私有仓库，所以需要修改docker的启动配置

.. code-block:: bash

    [root@k8s2 ~]# vim /lib/systemd/system/docker.service
    ExecStart=/usr/bin/dockerd --insecure-registry registry.alv.pub:3000
    [root@k8s2 tmp]# systemctl daemon-reload
    [root@k8s2 tmp]# systemctl restart docker

为本地镜像打tag，打为私有仓库的地址
-------------------------------------------

.. code-block:: bash

    [root@k8s2 ~]# docker pull busybox
    Using default tag: latest
    latest: Pulling from library/busybox
    Digest: sha256:cb63aa0641a885f54de20f61d152187419e8f6b159ed11a251a09d115fdff9bd
    Status: Image is up to date for busybox:latest
    [root@k8s2 ~]# docker images|grep busybox
    busybox                                            latest              e1ddd7948a1c        4 weeks ago         1.16MB
    [root@k8s2 ~]# docker tag e1ddd7948a1c registry.alv.pub:30001/busybox:latest

push镜像到私有仓库
---------------------------
也就是将镜像传到私有仓库里去

.. code-block:: bash

    [root@k8s2 ~]# docker push registry.alv.pub:30001/busybox:latest
    The push refers to repository [registry.alv.pub:30001/busybox]
    f9d9e4e6e2f0: Pushed
    latest: digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd size: 527

从私有仓库里pull镜像
-----------------------------

.. code-block:: bash

    [root@k8s2 ~]# docker pull registry.alv.pub:30001/busybox:latest
    latest: Pulling from busybox
    Digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd
    Status: Image is up to date for registry.alv.pub:30001/busybox:latest



创建docker-registry-web
====================================

在用于nfs的服务器上创建docker-registry-web的配置文件目录
-------------------------------------------------------------------------

.. code-block:: bash

    # mkdir -p  /k8sshare/docker-registry-web/config/
    # vim /k8sshare/docker-registry-web/config/config.yaml
    registry:
      # Docker registry url
      url: http://registry.alv.pub:30001/v2
      # Docker registry fqdn
      name: Alvin Internal Docker Registry
      # To allow image delete, should be false
      readonly: false
      auth:
        # Disable authentication
        enabled: false
      delete:
        enabled: true


共享配置文件目录
-----------------------------
.. code-block:: bash

    # vim /etc/exports
    /k8sshare/docker-registry-web/config *(rw,async,no_root_squash)
    # exportfs -rv


编写用于创建deploy和service的yaml
-------------------------------------------------

.. code-block:: bash


    [root@k8s1 ~]# vim registry-web.yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: registry-web
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            run: registry-web
        spec:
          containers:
          - name: registry-web
            resources:
              limits:
                cpu: 2
                memory: 500Mi
              requests:
                cpu: 0.5
                memory: 100Mi
            image: hyper/docker-registry-web
            ports:
            - containerPort: 8080
              protocol: TCP
              name: reg-web-port
            volumeMounts:
            - name: registry-web-nfs-config
              mountPath:  /conf
              readOnly: true
          volumes:
          - name: registry-web-nfs-config
            nfs:
              server: 192.168.127.54
              path: '/k8sserver/docker-registry-web/config'

    ---

    apiVersion: v1
    kind: Service
    metadata:
      name: registry-web-svc
      labels:
        run: registry-web-svc
    spec:
      selector:
        run: registry
      type: NodePort
      ports:
      - port: 8080
        targetPort: 8080
        nodePort: 30002
