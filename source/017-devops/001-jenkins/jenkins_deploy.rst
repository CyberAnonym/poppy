jenkins docker deployment
###############################
Auto deploy all my service configuration file and bash scripts and python scripts and my codes.

software installation
-----------------------------

- Install docker-latest service

.. code-block:: bash

    sudo wget -P /etc/yum.repos.d/ https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sudo yum install docker-ce

- Start docker-latest service

.. code-block:: bash

    systemctl start docker
    systemctl enable docker


pull jenkins image
-------------------------

- docker jenkins image user manual

https://hub.docker.com/_/jenkins/

.. code-block:: bash

    docker pull jenkins

- run docker container

国内网络环境使得jenkins可能无法成功自动下载到一些插件，所以我是在海外的服务器上启动jenkins docker容器了，在海外的服务器上下载好了插件，然后将/jenkins目录copy了过来用的。

创建容器前，我们需要下创建目录，并修改目录权限，将所属者的uid改为1000，因为容器里使用的用户是jenkins，uid是1000.


.. code-block:: bash

    mkdir -p /jenkins
    chown 1000 /jenkins
    docker run -d -it --name jenkins -p 80:8080 -p 50000:50000 -v /jenkins/:/var/jenkins_home -v /etc/localtime:/etc/localtime --restart on-failure -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai jenkins

主要数据目录就是/jenkins目录了，映射到容器的/var/jenkins_home目录里，所以即使删除这个容器，只有要本地的/jenkins目录里的数据还在，重新创建一个容器的时候加你/jenkins目录重新挂进去后启动容器，看到访问到的内容就还是和之前的一样，还是以前的那些数据。



