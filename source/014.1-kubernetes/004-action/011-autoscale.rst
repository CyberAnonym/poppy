autoscale
#################

还是先创建基本条件，deployment和service
====================================================

.. code-block:: bash

    $ kubectl create -f https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/k8s.yamls/nginx-deploy.yaml
    $ kubectl expose deployment nginx-deploy --name=nginx --port=80 --target-port=80 --protocol=TCP

autoscale一个deploy
=======================
这里的autuscale表示现在进行的动作是autuscale， autoscale一个deployment，deployment的名字是nginx-deploy, --min=1表示最小1个pod
--max=6表示最多6个pod，--cpu-percent=10表示当cpu使用率超过10%的时候就扩展pod数量（这里我们为了快速验证自动水平扩展所以设置为10，一般设置为80左右）

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl autoscale deploy nginx-deploy --min=1 --max=6 --cpu-percent=10
    horizontalpodautoscaler.autoscaling/nginx-deploy autoscaled



查看hpa
===========
hpa全称horizontalpodautoscaler。 下面我们可以看到replicas数量是1了，因为我们设置的最小值是一。

这里targets的值前面那个值是当前值，后面那个是触发扩展的值，如果前面那个值是unknow，可以用describe查看一下这个hpa，这里我们设置hpa的deployment,他的pod里必须要对容器做了资源限制，设置了resources:的，否则这里会报错，监控不到cpu的值。

.. code-block:: bash

    [alvin@k8s1]~% kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   0%/10%    1         6         1          3m


访问service，通过service调度到deploy里的pod
=======================================================
这里我们先确认下service的IP

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get svc -l run=nginx-deploy
    NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    nginx     ClusterIP   10.111.215.66   <none>        80/TCP    5d


然后开始curl访问这个service ip的80。

这里我们写个脚本来访问url

.. code-block:: bash

    [alvin@k8s2 ~]$ vim curl.sh
    #!/bin/bash

    for i in {1..100000}
    do
        curl -s 10.111.215.66 >/dev/null
    done
    [alvin@k8s2 ~]$ ./curl.sh &
    [1] 54987
    [alvin@k8s2 ~]$ ./curl.sh &
    [2] 55028
    [alvin@k8s2 ~]$ ./curl.sh &
    [3] 55078
    [alvin@k8s2 ~]$ ./curl.sh &
    [4] 55119



查看hpa状态，确认是否有扩展
================================

然后再查看hpa的状态

这里我们可以看到replicas的数量，变成了2.

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   19%/10%   1         6         2          9m
    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   10%/10%   1         6         2          10m



然后我们再起一个curl，加大访问量，

然后继续查看hpa的状态，replicas的数量，变成了3.

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   12%/10%   1         6         2          12m
    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   12%/10%   1         6         3          12m


查看pod状态，发现有一个是pending

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get pod
    NAME                            READY     STATUS    RESTARTS   AGE
    nginx-deploy-6dc465bbb6-4sskq   1/1       Running   0          17m
    nginx-deploy-6dc465bbb6-f9jbp   1/1       Running   0          7m
    nginx-deploy-6dc465bbb6-wbm5n   0/1       Pending   0          3m


describe 查看一下，发现有一个报错

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl describe pod nginx-deploy-6dc465bbb6-wbm5n
    Events:
      Type     Reason            Age               From               Message
      ----     ------            ----              ----               -------
      Warning  FailedScheduling  2m (x25 over 3m)  default-scheduler  0/3 nodes are available: 1 node(s) had taints that the pod didn't tolerate, 2 node(s) didn't have free ports for the requested pod ports.


这个报错，是因为我们在配置pod属性的时候在 ports:下面写了hostPort，就是容器所在主机需要监听的端口号，使用了这个参数后，就不能在同一个节点上启动多个该容器了。 真如上面的报错说的，没有可用端口了。

所以我们把创建那个deploy的方式改变一下，取消设置hostPort就好了。



现在master还不能运行普通pod，想要让master节点运行普通pod，可执行下面的命令

.. code-block:: bash

    $ kubectl taint nodes --all node-role.kubernetes.io/master-

让master节点恢复不运行普通pod，则执行下面的命令

.. code-block:: bash

    [root@k8s1 ~]# kubectl taint nodes k8s1.alv.pub node-role.kubernetes.io=master:NoSchedule
    node/k8s1.alv.pub tainted



最后再重新来一次
=====================
上面有过的一些东西修复掉，容器不用hostPort这个选项，当前我们的deployment是设置了4个pod


.. code-block:: bash

    [root@k8s1 ~]# kubectl get pod -o wide
    NAME                            READY     STATUS    RESTARTS   AGE       IP            NODE           NOMINATED NODE
    nginx-deploy-7c4c4f96cd-gj5wh   1/1       Running   0          2m        10.244.1.43   k8s2.alv.pub   <none>
    nginx-deploy-7c4c4f96cd-h7g5r   1/1       Running   0          2m        10.244.1.44   k8s2.alv.pub   <none>
    nginx-deploy-7c4c4f96cd-hq5ll   1/1       Running   0          2m        10.244.2.61   k8s3.alv.pub   <none>
    nginx-deploy-7c4c4f96cd-v5czh   1/1       Running   0          2m        10.244.2.62   k8s3.alv.pub   <none>

    [root@k8s1 ~]# kubectl autoscale deployment nginx-deploy --min=1 --max=6 --cpu-percent=5
    horizontalpodautoscaler.autoscaling/nginx-deploy autoscaled
    [root@k8s1 ~]# kubectl get hpa
    NAME           REFERENCE                 TARGETS        MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   <unknown>/5%   1         6         0          15s
    [root@k8s1 ~]# kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   0%/5%     1         6         1          1m

然后用我们的访问脚本访问

.. code-block:: bash

    [alvin@k8s2 ~]$ cat curl.sh
    #!/bin/bash

    for i in {1..100000}
    do
        curl -s 10.111.215.66 >/dev/null
    done
    [alvin@k8s2 ~]$ ./curl.sh &
    [1] 127810
    [alvin@k8s2 ~]$ ./curl.sh &
    [2] 127920
    [alvin@k8s2 ~]$ ./curl.sh &
    [3] 128050
    [alvin@k8s2 ~]$ ./curl.sh &
    [4] 128223
    [alvin@k8s2 ~]$ cat curl.sh
    [root@k8s1 ~]# kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   32%/5%    1         6         1          4m

然后pod要开始扩展了。

.. code-block:: bsah

    [root@k8s1 ~]# kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   32%/5%    1         6         1          4m
    [root@k8s1 ~]# kubectl get hpa
    NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   32%/5%    1         6         4          5m

