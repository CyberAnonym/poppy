delete
#########

删除各种对象，如pod，service，deployment，都是用delete命令删除。


先创建一个deploy
======================

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl run nginx --image=nginx
    deployment.apps/nginx created

删除指定deploy
================

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl delete deploy nginx
    deployment.extensions "nginx" deleted

