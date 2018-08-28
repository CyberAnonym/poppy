service
#####################

service可以简写为svc。

service是用于为pod提供固定访问端点的， service的网络是用于节点之间访问的。

expose用于创建一个service，将deployment管理的pod的端口给映射到service上。

service在被pod访问的时候，是可以用service的名称来访问的，因为service name 会被自动添加dns里，能够解析为这个service的IP地址。

service 使用ipvs规则，把所有访问service cluster-ip的请求全部调度至它用标签选择器关联到的各pod后端的。

通过kubectl describe svc $service_name



创建个deployment
=============================

这里我们先创建一个deployment

.. code-block:: bash

    $ kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=2

查看deployment的描述信息
======================================
名称为nginx-deploy， labels就是标签，这里的标签是run=nginx-deploy，默认将名字赋值给run作为标签。

.. code-block:: bash

    [root@k8s1 ~]# kubectl describe deploy nginx-deploy
    Name:                   nginx-deploy
    Namespace:              default
    CreationTimestamp:      Mon, 27 Aug 2018 17:18:41 +0800
    Labels:                 run=nginx-deploy
    Annotations:            deployment.kubernetes.io/revision=1
    Selector:               run=nginx-deploy
    Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  25% max unavailable, 25% max surge
    Pod Template:
      Labels:  run=nginx-deploy
      Containers:
       nginx-deploy:
        Image:        nginx:1.14-alpine
        Port:         80/TCP
        Host Port:    0/TCP
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Progressing    True    NewReplicaSetAvailable
      Available      True    MinimumReplicasAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-deploy-5b595999 (2/2 replicas created)
    Events:          <none>



然后我们将这个名为nginx-deploy的deployment给暴露出来，放到service里。

以下命令中，--target-port=80 表示目标deployment里的pod提供服务的端口是80， --port=8000 表示service这里提供服务的端口是8000.

.. code-block:: bash

    $ kubectl expose deployment nginx-deploy --name=nginx --port=8000 --target-port=80 --protocol=TCP

然后我们查看一下，确认service创建完成，而且可以访问。


.. code-block:: bash

    [root@k8s1 ~]# kubectl get service
    NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
    kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    5h
    nginx        ClusterIP   10.110.69.178   <none>        8000/TCP   1m
    [root@k8s1 ~]# curl 10.110.69.178:8000
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>


查看service的描述信息
==================================

service信息里有一行 Selector, 就是标签选择器，通过标签选择器来将请求调度到后端的pod

.. code-block:: bash

    [root@k8s1 ~]# kubectl describe svc nginx
    Name:              nginx
    Namespace:         default
    Labels:            run=nginx-deploy
    Annotations:       <none>
    Selector:          run=nginx-deploy
    Type:              ClusterIP
    IP:                10.110.69.178
    Port:              <unset>  8000/TCP
    TargetPort:        80/TCP
    Endpoints:         10.244.1.10:80,10.244.2.10:80
    Session Affinity:  None
    Events:            <none>
    [root@k8s1 ~]#


