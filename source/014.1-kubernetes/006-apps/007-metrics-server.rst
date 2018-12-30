metrics-server
#################################

deploy 的yaml所在目录: https://github.com/kubernetes-incubator/metrics-server/tree/master/deploy


创建部署
================

.. code-block:: bash

    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-delegator.yaml
    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-reader.yaml
    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-apiservice.yaml
    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-deployment.yaml
    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-service.yaml
    kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/resource-reader.yaml

然后要编辑修改下metric-server的deployment，因为还缺少点东西，不补上会报错


.. code-block:: bash

    kubectl edit deploy metrics-server -n kube-system   (添加在imagePullPolicy后面)

            command:
            - /metrics-server
            - --kubelet-insecure-tls
            - --kubelet-preferred-address-types=InternalIP


..
    command:
    - /metrics-server
    - --source=kubernetes:https://kubernetes.default


