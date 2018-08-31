load
#########


保存镜像

保存镜像到文件，然后导入镜像
========================================

- 这里我们先拉取一个nginx镜像

.. code-block:: bash

    [root@natasha ~]# docker pull nginx
    Using default tag: latest
    Trying to pull repository docker.io/library/nginx ...
    latest: Pulling from docker.io/library/nginx
    be8881be8156: Already exists
    65206e5c5e2d: Pull complete
    8e029c3e2376: Pull complete
    Digest: sha256:291e15f504cdc40aeedcd29b59f0079c794e18f22cd8a6a6d66d646b36f1d51b
    Status: Downloaded newer image for docker.io/nginx:latest
    [root@natasha ~]#
    [root@natasha ~]# docker images|grep nginx
    docker.io/nginx                            latest              71c43202b8ac        35 hours ago        109 MB
    docker.io/nginx                            <none>              c82521676580        5 weeks ago         109 MB

- 保存镜像nginx:latest到文件nginx_latest.tar

.. code-block:: bash

    [root@natasha ~]# docker save nginx:latest > nginx_latest.tar

- 删除原镜像

.. code-block:: bash

    [root@natasha ~]# docker rmi nginx:latest
    Untagged: nginx:latest
    Untagged: docker.io/nginx@sha256:291e15f504cdc40aeedcd29b59f0079c794e18f22cd8a6a6d66d646b36f1d51b
    Deleted: sha256:71c43202b8ac897ff4d048d3b37bdf4eb543ec5c03fd017c3e12c616c6792206
    Deleted: sha256:f7c97da96a4a835f13805b82395478a170c9092390702d7e1da9f0ebc339b7ce
    Deleted: sha256:5182900c1c2256da84d827f0e0878e61f26fbc70784496a0b56be260ff380d3d
    [root@natasha ~]# docker images|grep nginx
    docker.io/nginx                            <none>              c82521676580        5 weeks ago         109 MB

导入镜像
==================
一般导出然后导入镜像，是为了将本地镜像保存，然后传递到其他服务器上去，在其他服务器上直接导入，这样其他服务器就不用去网络下载了。

尤其比如使用k8s的时候，一些k8s的镜像我们内地的网络访问不到，于是可以先从海外的服务器上下载镜像，然后导出，然后传到内地的服务器上，然后导入。

.. code-block:: bash

    [root@natasha ~]# docker load < nginx_latest.tar
    7f2cffb520ed: Loading layer [==================================================>] 54.32 MB/54.32 MB
    64ef7c2d456f: Loading layer [==================================================>] 3.584 kB/3.584 kB
    Loaded image: nginx:latest
    [root@natasha ~]#
    [root@natasha ~]# docker images|grep nginx
    nginx                                      latest              71c43202b8ac        35 hours ago        109 MB
    docker.io/nginx                            <none>              c82521676580        5 weeks ago         109 MB
