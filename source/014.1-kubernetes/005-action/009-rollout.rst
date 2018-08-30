rollout
############################


通过rollout查看更新状态
===============================
在灰度发布更新镜像的时候，我能也可以查看更新的进度。

下面我们再次更新一下，然后通过rollout status 查看精度

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl set image deployment myapp myapp=ikubernetes/myapp:v3
    deployment.extensions/myapp image updated
    [alvin@k8s1 ~]$ kubectl rollout status deployment myapp
    Waiting for deployment "myapp" rollout to finish: 1 out of 2 new replicas have been updated...
    Waiting for deployment "myapp" rollout to finish: 1 out of 2 new replicas have been updated...
    Waiting for deployment "myapp" rollout to finish: 1 out of 2 new replicas have been updated...
    Waiting for deployment "myapp" rollout to finish: 1 old replicas are pending termination...
    Waiting for deployment "myapp" rollout to finish: 1 old replicas are pending termination...
    deployment "myapp" successfully rolled out

