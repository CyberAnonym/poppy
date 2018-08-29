logs
#####


实时打印指定容器日志
============================

实时打印kube-system命名空间里 monitoring-influxdb-848b9b66f6-fwskn pod的日志

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl logs -f monitoring-influxdb-848b9b66f6-fwskn -n kube-system


实时打印指定容器日志，从最后n行开始
===============================================
从最后20行开始打印

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl logs -f --tail=20 monitoring-influxdb-848b9b66f6-fwskn -n kube-system