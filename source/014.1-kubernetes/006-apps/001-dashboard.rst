dashboard
###############

官方github地址：https://github.com/kubernetes/dashboard



创建dashboard
======================

.. code-block:: bash

    [alvin@k8s1 ~]$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
    [alvin@k8s1 ~]$ kubectl get service -n kube-system
    NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
    kube-dns               ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP   1h
    kubernetes-dashboard   ClusterIP   10.103.193.208   <none>        443/TCP         20m



这个时候就创建好了，但是如果访问dashboard还会需要做权限验证，所以我们还需要做如下操作


.. code-block:: bash

    [alvin@k8s1 ~]$ vim dashboard-admin.yaml
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
    [alvin@k8s1 ~]$ kubectl create -f dashboard-admin.yaml


.. note::

    上面是之前版本的步骤，如果上面的步骤之后还是无法正常访问dashboad, 可以用这里的步骤创建。

    .. code-block:: bash

        apiVersion: v1
        kind: ServiceAccount
        metadata:
          labels:
            k8s-app: kubernetes-dashboard
          name: admin
          namespace: kube-system
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: admin
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: cluster-admin
        subjects:
        - kind: ServiceAccount
          name: admin
          namespace: kube-system


然后我们查看一下token

::

    kubectl get secret -n kube-system  #查看一下那个secret的名字
    kubectl describe secret admin-token-c9kql -n kube-system    ##这条命令后面的admin-token-c9kql,根据我们的实际的secret名而定。


从上面的命令中查看


然后这里我们可以通过nginx做代理，让外部网络可以访问

.. code-block:: bash

    # yum install nginx -y
    # vim /etc/nginx/nginx.conf
        location / {
                proxy_pass https://10.103.193.208:443;
        }


然后就可以访问了。


谷歌浏览器如果访问不了，可以使用火狐浏览器去访问https的链接。