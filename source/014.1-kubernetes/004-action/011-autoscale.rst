autoscale
#################

还是先创建基本条件，deployment和service
====================================================

.. code-block:: bash

    $ kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=2
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
hpa全称horizontalpodautoscaler。 当前数量是2个pod。因为之前创建deploy时就是2个pod。

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   <unknown>/10%   1         6         2          6m


访问service，通过service调度到deploy里的pod
=======================================================
这里我们先确认下service的IP

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get svc -l run=nginx-deploy
    NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    nginx     ClusterIP   10.111.215.66   <none>        80/TCP    5d


然后开始curl访问这个service ip的80。
