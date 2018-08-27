service
#####################

service可以简写为svc。

service是用于为pod提供固定访问端点的， service的网络是用于节点之间访问的。

expose用于创建一个service，将deployment管理的pod的端口给映射到service上。

service在被pod访问的时候，是可以用service的名称来访问的，因为service name 会被自动添加dns里，能够解析为这个service的IP地址。


这里我们先创建一个deployment

.. code-block:: bash

    $ kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=2

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
