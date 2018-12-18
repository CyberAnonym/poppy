kvm常用命令
#############


查看当前正在运行的虚拟机
=============================

.. code-block:: bash

    virsh list

查看所有虚拟机
=======================


.. code-block:: bash

    virsh list --all


启动指定虚拟机
===================
启动名为db2.alv.pub的虚拟机

.. code-block:: bash

    virsh start db2.alv.pub


打开指定虚拟机的图形化控制台
=====================================

打卡db2.alv.pub的图形化控制台

.. code-block:: bash

    virt-viewer db2.alv.pub