edit
########################

创建一个deployment
===============================================
.. code-block:: bash

    [root@k8s1 ~]# kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=2 -n poppy
    deployment.apps/nginx-deploy created

编辑deployment
========================
这里我们把replicas的数量改成4

.. code-block:: bash

    $ kubectl edit deploy nginx-deploy  -n poppy


然后查看pod数量，发现现在是4个pod了。

.. code-block:: bash

    $ kubectl get pod -n poppy