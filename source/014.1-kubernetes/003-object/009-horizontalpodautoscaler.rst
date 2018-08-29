horizontalpodautoscaler
##################################

horizontalpodautoscaler 简写是hpa  英文翻译下来就是水平pod自动扩展， 创建autoscale 就是创建的的horizontalpodautoscaler。


创建hpa
================

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl autoscale deploy nginx-deploy --min=1 --max=5
    horizontalpodautoscaler.autoscaling/nginx-deploy autoscaled


查看hpa
===========

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl get hpa
    NAME           REFERENCE                 TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
    nginx-deploy   Deployment/nginx-deploy   <unknown>/80%   1         5         2          59m