create
############

创建一个busybox pod
=========================

.. code-block:: bash

    [root@k8s1 ~]# vim busybox.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
      namespace: default
    spec:
      containers:
      - image: busybox
        command:
          - sleep
          - "3600"
        imagePullPolicy: IfNotPresent
        name: busybox
      restartPolicy: Always
    [root@k8s1 ~]# kubectl create -f busybox.yaml
    pod/busybox created

进入到pod里操作
=======================


.. code-block:: bash

    [root@k8s1 ~]# kubectl exec busybox  -it sh
    / # hostname
    busybox


