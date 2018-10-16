集群lvm
#############

Install lvm2-cluster and dlm
=========================================

.. code-block:: bash

    yum install  lvm2-cluster dlm -y


.. note::

    默认情况下没有开启集群逻辑卷



enable cluster lvm
============================

.. code-block:: bash

    lvmconf --enable-cluster


Disable local logic volume
========================================

disable the lvm metadata function.

.. code-block:: bash

    systemctl stop lvm2-lvmetad.service