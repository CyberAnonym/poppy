dashboard
###############

官方github地址：https://github.com/kubernetes/dashboard



创建dashboard
======================

.. code-block:: bash

    [root@k8s1 ~]# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    [root@k8s1 ~]# kubectl get service -n kube-system
    NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
    kube-dns               ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP   1h
    kubernetes-dashboard   ClusterIP   10.103.193.208   <none>        443/TCP         20m



这个时候就创建好了，但是如果访问dashboard还会需要做权限验证，所以我们还需要做如下操作


.. code-block:: bash

    [root@k8s1 ~]# vim dashboard-admin.yaml
    apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRoleBinding
    metadata:
      name: kubernetes-dashboard
      labels:
        k8s-app: kubernetes-dashboard
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: kubernetes-dashboard
      namespace: kube-system


然后这里我们可以通过nginx做代理，让外部网络可以访问

.. code-block:: bash

    # yum install nginx -y
    # vim /etc/nginx/nginx.conf
        location / {
                proxy_pass https://10.103.193.208:443;
        }


然后就可以访问了。
