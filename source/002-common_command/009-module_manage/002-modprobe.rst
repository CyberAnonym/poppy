modprobe
#############


加载和kvm_intel模块
==============================

.. code-block:: bash


    # modprobe kvm_intel

移除kvm_intel模块
========================




.. code-block:: bash
    :linenos:
    :emphasize-lines: 5

    [root@alvin ~]# lsmod |grep kvm
    kvm_intel             170086  0
    kvm                   566340  1 kvm_intel
    irqbypass              13503  1 kvm
    [root@alvin ~]# modprobe -r kvm_intel
    [root@alvin ~]# lsmod |grep kvm
    [root@alvin ~]#
    [root@alvin ~]# modprobe kvm_intel
    [root@alvin ~]# lsmod |grep kvm
    kvm_intel             170086  0
    kvm                   566340  1 kvm_intel
    irqbypass              13503  1 kvm
    [root@alvin ~]# modprobe -r kvm_intel
    [root@alvin ~]#