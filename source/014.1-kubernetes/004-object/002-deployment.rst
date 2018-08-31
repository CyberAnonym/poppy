deployment
###########################



run 创建的是deployment， deployment简写可以写deploy。

deployment是pod的控制器，用来管理容器的。

查看kubectl run的帮助
==========================================

::

    kubectl run --help



创建一个指定多个参数的deployment
=======================================

这里run后面的nginx-deploy是本次创建的deploy的名称。

--image=指定的是镜像名和版本，

nginx是镜像名，冒号:后面的是镜像版本。

--port是指定容器的打开端口。

--replicas=2 代表启动并保持2个pod。

下面的kubectl get 的状态里， Running表示pod已经在运行了。   ContainerCreating表示pod正在创建，一般是pod所分配到的node上还没有下载好镜像，正在下载镜像，等待一会在get查看就好了。

.. code-block:: bash

    [root@k8s1 ~]# kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=2
    deployment.apps/nginx-deploy created
    [root@k8s1 ~]#
    [root@k8s1 ~]# kubectl get deployment
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    nginx-deploy   2         2         2            1           6s
    [root@k8s1 ~]#
    [root@k8s1 ~]# kubectl get pod
    NAME                          READY     STATUS              RESTARTS   AGE
    nginx-deploy-5b595999-cqwkd   0/1       ContainerCreating   0          9s
    nginx-deploy-5b595999-f4m8x   1/1       Running             0          9s
    [root@k8s1 ~]#
    [root@k8s1 ~]# kubectl get pod -o wide
    NAME                          READY     STATUS              RESTARTS   AGE       IP            NODE               NOMINATED NODE
    nginx-deploy-5b595999-cqwkd   0/1       ContainerCreating   0          20s       <none>        k8s2.shenmin.com   <none>
    nginx-deploy-5b595999-f4m8x   1/1       Running             0          20s       10.244.2.10   k8s3.shenmin.com   <none>

    root@k8s1 ~]# kubectl get pod -o wide
    NAME                          READY     STATUS    RESTARTS   AGE       IP            NODE               NOMINATED NODE
    nginx-deploy-5b595999-cqwkd   1/1       Running   0          3m        10.244.1.9    k8s2.shenmin.com   <none>
    nginx-deploy-5b595999-f4m8x   1/1       Running   0          3m        10.244.2.10   k8s3.shenmin.com   <none>


删除一个pod，验证其保持pod数量的功能
=====================================================

这里可以看到有两个pod，我们删除其中一个，然后再get查看，发现原有的那个pod已经被删除了，通过pod名称可以判断。然后又重新启动了一个pod。

.. code-block:: bash

    [root@k8s1 ~]# kubectl get pod -o wide
    NAME                          READY     STATUS    RESTARTS   AGE       IP            NODE               NOMINATED NODE
    nginx-deploy-5b595999-cqwkd   1/1       Running   0          3m        10.244.1.9    k8s2.shenmin.com   <none>
    nginx-deploy-5b595999-f4m8x   1/1       Running   0          3m        10.244.2.10   k8s3.shenmin.com   <none>
    [root@k8s1 ~]#
    [root@k8s1 ~]# kubectl delete pod nginx-deploy-5b595999-cqwkd
    pod "nginx-deploy-5b595999-cqwkd" deleted

    [root@k8s1 ~]#
    [root@k8s1 ~]# kubectl get pod -o wide
    NAME                          READY     STATUS    RESTARTS   AGE       IP            NODE               NOMINATED NODE
    nginx-deploy-5b595999-94z9p   1/1       Running   0          14s       10.244.1.10   k8s2.shenmin.com   <none>
    nginx-deploy-5b595999-f4m8x   1/1       Running   0          5m        10.244.2.10   k8s3.shenmin.com   <none>


通过yaml文件创建一个deployment
===========================================

.. code-block:: bash

    [alvin@k8s1 ~]$ vim registry.yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: registry
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            run: registry
        spec:
          containers:
          - name: registry
            resources:
              limits:
                cpu: 2
                memory: 200Mi
              requests:
                cpu: 0.5
                memory: 100Mi
            image: registry:2
            ports:
            - containerPort: 5000
              protocol: TCP
              name: registry-port
            volumeMounts:
            - name: registry-nfs-data
              mountPath: /var/lib/registry
              readOnly: false
            - name: registry-nfs-config
              mountPath:  /etc/docker/registry
              readOnly: true
          volumes:
          - name: registry-nfs-data
            nfs:
              server: 192.168.127.54
              path: '/registry/data'
          - name: registry-nfs-config
            nfs:
              server: 192.168.127.54
              path: '/registry/config'

.. code-block:: bash

    $ kubectl create -f registry.yaml