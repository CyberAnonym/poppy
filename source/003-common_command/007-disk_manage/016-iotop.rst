iotop
##########

iotop命令是用来查看系统进程的io的,有时我们希望知道到底哪个进程产生了IO，这个时候就需要iotop这个工具了。
它的输出和top命令类似，简单直观。官网：http://guichaz.free.fr/iotop/
需要Python 2.5（及以上版本）和 Linux kernel 2.6.20（及以上版本），TASK_DELAY_ACCT，CONFIG_TASKSTATS，TASK_IO_ACCOUNTING，CONFIG_VM_EVENT_COUNTERS这些内核选项开启



安装iotop
===============

::

    yum install iotop -y



使用iotop
================

直接执行iotop就行了

::

    iotop


相关参数
==============

这里我们参考下man手册

::

    名称
           iotop - 简单的top类I/O监视器
    总览
           iotop [OPTIONS]
    描述
           iotop根据Linux内核（需要2.6.20及以上）来监测I/O，并且能显示当前进程/线程的I/O使用率。
           Linux内核build的事后哦，需要开启CONFIG_TASK_DELAY_ACCT和CONFIG_TASK_IO_ACCOUNTING选项，这些选项依赖于CONFIG_TASKSTATS。<br>
         <strong> <span style="font-size: 14px;"> 在采样周期里，iotop按列显示每个进程/线程的I/O读写带宽，同时也显示进程/线程做swap交换和等待I/O所占用的百分比。
           每一个进程都会显示I/O优先级(class/level)，另外在最上面显示每个采样周期内的读写带宽。</span></strong><br><strong><span style="font-size: 14px;">
           使用左右箭头来改变排序，r用来改变排序顺序，o用来触发--only选项，p用来触发--processes选项。
           a用来触发--accumulated选项，q用来退出，i用来改变进程或线程的监测优先级，其它任继健是强制刷新。</span></strong>

    选项
           --version 显示版本号然后退出
           -h, --help 显示帮助然后退出
           -o, --only 只显示正在产生I/O的进程或线程。除了传参，可以在运行过程中按o生效。
           -b, --batch 非交互模式，一般用来记录日志
           -n NUM, --iter=NUM 设置监测的次数，默认无限。在非交互模式下很有用
           -d SEC, --delay=SEC 设置每次监测的间隔，默认1秒，接受非整形数据例如1.1
           -p PID, --pid=PID 指定监测的进程/线程
           -u USER, --user=USER 指定监测某个用户产生的I/O
           -P, --processes 仅显示进程，默认iotop显示所有线程
           -a, --accumulated 显示累积的I/O，而不是带宽
           -k, --kilobytes 使用kB单位，而不是对人友好的单位。在非交互模式下，脚本编程有用。
           -t, --time 加上时间戳，非交互非模式。
           -q, --quiet 禁止头几行，非交互模式。有三种指定方式。
                  -q     只在第一次监测时显示列名
                  -qq    永远不显示列名。
                  -qqq   永远不显示I/O汇总。



常用的操作就是我们的排序，使用左右箭头来改变排序，用于排序的列标题会加粗，r用来改变排序顺序，o用来触发--only选项，p用来触发--processes选项。
