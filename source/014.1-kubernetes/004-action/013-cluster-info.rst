cluster-info
#################


查看在集群中运行的插件
==========================

::

    [root@k8s1 ~]# kubectl cluster-info
    Kubernetes master is running at https://192.168.1.51:6443
    Heapster is running at https://192.168.1.51:6443/api/v1/namespaces/kube-system/services/heapster/proxy
    KubeDNS is running at https://192.168.1.51:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    monitoring-grafana is running at https://192.168.1.51:6443/api/v1/namespaces/kube-system/services/monitoring-grafana/proxy
    monitoring-influxdb is running at https://192.168.1.51:6443/api/v1/namespaces/kube-system/services/monitoring-influxdb/proxy
