garafana
##############

.. code-block:: bash

    https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml




grafana这里我们也是下载文件后修改一下

.. code-block:: bash

    $ kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
    $ kubectl edit svc monitoring-grafana -n kube-system #将ClusterIP改成NodePort，就可以通过外部访问了。


这里我们是将service的 spec.type的值设置为了NodePort, 然后添加了nodePort:30110




在grafara的dashboard里我可以导入k8s的node的dashbaord,  到这个链接下载json 导入  https://grafana.com/dashboards/3646


导入pod的dashboard  https://grafana.com/dashboards/3649

