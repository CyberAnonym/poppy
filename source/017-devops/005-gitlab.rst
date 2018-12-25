gitlab
###########

代码管理软件，常用的github和gitlab, github是共有的，gitlab是自己搭建的私有的git服务器。



搭建gitlab服务器
=======================

docker 的方式安装
----------------------------
（该方法不好用的时候，可以别下面写的别的方法安装）

.. code-block:: bash

    $ sudo mkdir -p /data/gitlab/config
    $ sudo mkdir -p /data/gitlab/logs
    $ sudo mkdir -p /data/gitlab/data


    $ sudo docker run --detach \
    --hostname $GIT_HOSTNAME \
    --publish 1443:443 --publish 180:80 --publish 122:22 \
    --name gitlab \
    --restart always \
    --memory  4048m \
    --volume /data/gitlab/config:/etc/gitlab \
    --volume /data/gitlab/logs:/var/log/gitlab \
    --volume /data/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest


yum 安装
---------------
参考该文档： https://blog.csdn.net/qwlovedzm/article/details/80312302


基础环境准备

::

    yum install curl policycoreutils openssh-server openssh-clients postfix
    systemctl start postfix

安装gitlab-ce

::

    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
    yum install -y gitlab-ce


.. note::

    注：由于网络问题，国内用户，建议使用清华大学的镜像源进行安装：

    ::

        $ vim /etc/yum.repos.d/gitlab-ce.repo
        [gitlab-ce]
        name=gitlab-ce
        baseurl=http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7
        repo_gpgcheck=0
        gpgcheck=0
        enabled=1
        gpgkey=https://packages.gitlab.com/gpg.key
        $ yum makecache
        $ yum install gitlab-ce



配置并启动gitlab-ce

::

    gitlab-ctl reconfigure


可以使用gitlab-ctl管理gitlab，例如查看gitlab状态：

::

    [root@git ~]# gitlab-ctl status
    run: alertmanager: (pid 31135) 156s; run: log: (pid 31152) 156s
    run: gitaly: (pid 30916) 161s; run: log: (pid 30932) 161s
    run: gitlab-monitor: (pid 30978) 159s; run: log: (pid 31063) 159s
    run: gitlab-workhorse: (pid 30876) 163s; run: log: (pid 30888) 163s
    run: logrotate: (pid 30090) 209s; run: log: (pid 30905) 162s
    run: nginx: (pid 30685) 185s; run: log: (pid 30895) 162s
    run: node-exporter: (pid 30955) 160s; run: log: (pid 30967) 160s
    run: postgres-exporter: (pid 31162) 155s; run: log: (pid 31173) 155s
    run: postgresql: (pid 28351) 286s; run: log: (pid 30848) 164s
    run: prometheus: (pid 31094) 158s; run: log: (pid 31125) 157s
    run: redis: (pid 28132) 292s; run: log: (pid 30841) 165s
    run: redis-exporter: (pid 31074) 159s; run: log: (pid 31083) 158s
    run: sidekiq: (pid 29694) 223s; run: log: (pid 30865) 163s
    run: unicorn: (pid 29560) 225s; run: log: (pid 30857) 164s


修改外部url

    这里我们修改下面这文件里external_url的值，改为我们用于访问gitlab的地址


::

    vim /etc/gitlab/gitlab.rb
    external_url 'http://git.alv.pub'

然后重启服务器

::

    gitlab-ctl restart


然后登录web访问
========================

这里我们使用的是180端口，所以访问地址是我们刚才那个域名加上端口

登录后，会设置管理员密码， 管理员账号是root。