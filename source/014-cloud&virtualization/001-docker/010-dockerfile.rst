dockerfile
#############


编写一个用于运行一个java程序的dockerfile
===================================================

::

    $ suod vim Dockerfile
    FROM centos:7

    # MAINTAINER_INFO
    MAINTAINER Alvin Wan <alvin.wan@sophiroth.com>

    RUN python -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/pullLocalYum.py)"
    RUN yum install java -y
    ADD webmvc-0.0.1-SNAPSHOT-undertow.jar /tmp
    ENTRYPOINT [ "java", "-Xms1024", "-Xmx3000", "-jar", "/tmp/webmvc-0.0.1-SNAPSHOT-undertow.jar","--spring.profiles.active=test" ]
    $ sudo docker build -t registry.shenmin.com:30001/webmvc-undertow .

上传镜像到镜像服务器

::

    [root@k8s2 A_package]# docker images|grep webmvc
    registry.shenmin.com:30001/webmvc-undertow   latest              ddcd43785759        About a minute ago   746MB
    [root@k8s2 A_package]# cd
    [root@k8s2 ~]# docker push registry.shenmin.com:30001/webmvc-undertow
    The push refers to repository [registry.shenmin.com:30001/webmvc-undertow]
    5e4966cfffe7: Pushed
    56f33c85e06d: Pushed
    749e7f86429f: Pushed
    1d31b5806ba4: Pushed
    latest: digest: sha256:8907c212685b80c131e73047ee3823ec8c3b9f4a05475b24680e3ad0355d36cc size: 1166
    [root@k8s2 ~]#

其他节点下载镜像

::

    [root@k8s3 ~]# docker pull registry.shenmin.com:30001/webmvc-undertow
    Using default tag: latest
    latest: Pulling from webmvc-undertow
    256b176beaff: Pull complete
    534875052009: Pull complete
    053e6b63f4ce: Pull complete
    55387ac1a769: Pull complete
    Digest: sha256:8907c212685b80c131e73047ee3823ec8c3b9f4a05475b24680e3ad0355d36cc
    Status: Downloaded newer image for registry.shenmin.com:30001/webmvc-undertow:latest
    [root@k8s3 ~]#