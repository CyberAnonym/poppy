modinfo
###########

查看指定模块信息
=======================
查看kvm模块信息

.. code-block:: bash

    [root@alvin ~]# modinfo kvm
    filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/arch/x86/kvm/kvm.ko.xz
    license:        GPL
    author:         Qumranet
    rhelversion:    7.4
    srcversion:     FA3AAB0FB1DD5C7B9D69811
    depends:        irqbypass
    intree:         Y
    vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions
    signer:         CentOS Linux kernel signing key
    sig_key:        DA:18:7D:CA:7D:BE:53:AB:05:BD:13:BD:0C:4E:21:F4:22:B6:A4:9C
    sig_hashalgo:   sha256
    parm:           ignore_msrs:bool
    parm:           min_timer_period_us:uint
    parm:           kvmclock_periodic_sync:bool
    parm:           tsc_tolerance_ppm:uint
    parm:           lapic_timer_advance_ns:uint
    parm:           vector_hashing:bool
    parm:           halt_poll_ns:uint
    parm:           halt_poll_ns_grow:uint
    parm:           halt_poll_ns_shrink:uint
