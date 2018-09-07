myapp
######

创建一个myapp的deploy
============================

.. code-block:: bash

    $ kubectl run myapp --image=ikubernetes/myapp:v1 --replicas=2


创建myapp的service
==============================

.. code-block:: bash

    $ kubectl expose deployment myapp --name=myapp --port=80


访问myapp service
========================

这里我们是exec到busybox pod的容器里去访问

查看主页

::

    / # wget -q  -O - myapp
    Hello MyApp | Version: v1 | <a href="hostname.html">Pod Name</a>


查看主机名

::

    / # wget -q  -O - myapp/hostname.html
    myapp-848b5b879b-q59pl


验证负载均衡，访问myapp 200次,结果显示，其中一个调度了87次，另一个113次。

::

    / # for i in `seq 1 200`;do wget -q  -O - myapp/hostname.html;done|sort |uniq -c
         87 myapp-848b5b879b-q59pl
        113 myapp-848b5b879b-sblxj


测试灰度发布
======================

我们下开一个窗口访问myapp,每秒访问一次

::

    for i in `seq 1 200`;do wget -q -O - myapp;sleep 1;done


然后另一个窗口将镜像版本更新到v2

::

    kubectl set image deployment myapp myapp=ikubernetes/myapp:v2


然后在第一个窗口里就可以看到v1版本开始变成v2了，v1和v2都有，再然后就都是v2了。

