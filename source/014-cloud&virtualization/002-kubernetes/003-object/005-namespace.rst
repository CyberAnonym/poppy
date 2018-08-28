namespace
##################

namespace是命名空间，默认的命名空间是default， 默认的k8s自己的组件所在的namespace是 kube-system.


- 获取指定kube-system命名空间的service信息。

.. code-block:: bash

    $ kubectl get service -n kube-system


创建一个namespace
========================

- 创建一个名为poppy的namespace

.. code-block:: bash

    $ kubectl create namespace poppy

- 查看namespace列表

.. code-block:: bash

    $ kubectl get namespaces

查看指定namespace的对象
=============================

- 查看名为poppy的namespace的pod

.. code-block:: bash

    $ kubectl get pod -n poppy