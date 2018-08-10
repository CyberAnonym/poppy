rmmod
#########
卸载模块， 或者说卸载驱动

卸载kvm_intel
=================

.. code-block:: bash

    [root@dhcp ~]# rmmod kvm_intel
    [root@dhcp ~]# rmmod kvm_intel
    rmmod: ERROR: Module kvm_intel is not currently loaded


卸载后再执行就会提示已经不在了。 想要重新加载的话，可以执行 modprobe kvm_intel 。