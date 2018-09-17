dmesg
#######

Linux dmesg命令用于显示开机信息。

kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。开机信息亦保存在/var/log目录中，名称为dmesg的文件里。

语法
======

.. code-block::  bash

    dmesg [-cn][-s <缓冲区大小>]


参数说明：
-------------

- -c 　显示信息后，清除ring buffer中的内容。
- -s<缓冲区大小> 　预设置为8196，刚好等于ring buffer的大小。
- -n 　设置记录信息的层级。


实例
======

显示开机信息

::

    # dmesg |less
    WARNING: terminal is not fully functional
    [  0.000000] Initializing cgroup subsys cpuset
    [  0.000000] Initializing cgroup subsys cpu
    [  0.000000] Linux version 2.6.32-21-generic (buildd@rothera) (gcc version 4.4.3 (Ub
    untu 4.4.3-4ubuntu5) ) #32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2010 (Ubuntu 2.6.32-21.3
    2-generic 2.6.32.11+drm33.2)
    [  0.000000] KERNEL supported cpus:
    [  0.000000]  Intel GenuineIntel
    [  0.000000]  AMD AuthenticAMD
    [  0.000000]  NSC Geode by NSC
    [  0.000000]  Cyrix CyrixInstead
    [  0.000000]  Centaur CentaurHauls
    [  0.000000]  Transmeta GenuineTMx86
    [  0.000000]  Transmeta TransmetaCPU
    [  0.000000]  UMC UMC UMC UMC
    [  0.000000] BIOS-provided physical RAM map:
    [  0.000000] BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
    [  0.000000] BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
    [  0.000000] BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
    [  0.000000] BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
    [  0.000000] BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
    [  0.000000] BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
    [  0.000000] BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
    [  0.000000] BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)

    ……省略部分内容


显示开机信息

::

    #pwd   //查看当前所在目录
    /home/hnlinux/
    # dmesg > boot.msg //将开机信息保存到 boot.msg文件中
    #ls //显示当前目录文件
    boot.msg