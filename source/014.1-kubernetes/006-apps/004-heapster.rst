heapster
##############


.. code-block:: bash

    $ kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
    $ kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml


然后要修改一点内容

::

    $ kubectl edit deploy  heapster -n kube-system
    - --source=kubernetes:https://kubernetes.default #修改前
    - --source=kubernetes:https://kubernetes.default?useServiceAccount=true&kubeletHttps=true&kubeletPort=10250&insecure=true 修改后
