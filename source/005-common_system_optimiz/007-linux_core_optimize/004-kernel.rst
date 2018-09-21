kernel
##########



内核的随机地址保护模式
=============================

::

    【kernel】
    ######################## cat /proc/sys/kernel/randomize_va_space
    # 默认值：2
    # 作用：内核的随机地址保护模式
    kernel.randomize_va_space = 1

内核panic时，1秒后自动重启
=================================

::

    ######################## cat /proc/sys/kernel/panic
    # 默认值：0
    # 作用：内核panic时，1秒后自动重启
    kernel.panic = 1


程序生成core时的文件名格式
===============================

::

    ######################## cat /proc/sys/kernel/core_pattern
    # 默认值：|/usr/libexec/abrt-hook-ccpp %s %c %p %u %g %t e
    # 作用：程序生成core时的文件名格式
    kernel.core_pattern = core_%e


是否启用sysrq功能
========================

:sysrq相关资料: https://www.ibm.com/developerworks/cn/linux/l-cn-sysrq/


::

    ######################## cat /proc/sys/kernel/sysrq
    # 默认值：0
    # 作用：是否启用sysrq功能
    kernel.sysrq = 0