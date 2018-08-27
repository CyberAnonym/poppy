namespace
##################

namespace是命名空间，默认的命名空间是default， 默认的k8s自己的组件所在的namespace是 kube-system.


- 获取指定kube-system命名空间的service信息。

.. code-block:: bash

    $ kubectl get service -n kube-system

