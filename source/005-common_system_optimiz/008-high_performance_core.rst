高性能linux服务器内核调优
##################################


首先，介绍一下两个命令

1、dmesg 打印系统信息。

 有很多同学们服务器出现问题，看了程序日志，发现没啥有用信息，还是毫无解决头绪，这时候，你就需要查看系统内核抛出的异常信息了，使用dmesg命令，可以查看系统信息，dmesg -c 清除已经看过的信息。

2、sysctl -p 生效内核配置

在我们修改内核参数文件/etc/sysctl.conf后，需要执行以下sysctl -p 来使参数生效。

nginx服务器内核调优
==============================

用户请求，最先进入的是nginx服务器，那我们首先就要对其进行内核调优。

首先，当然是文件描述符咯~

#增大文件描述符

::

    ulimit -n 65536
    echo -ne "
    * soft nofile 65536
    * hard nofile 65536
    " >>/etc/security/limits.conf

#修改系统线程限制

::

    echo -ne "
    * soft nproc 2048
    * hard nproc 4096
    " >>/etc/security/limits.conf

链接追踪表问题
===================

nginx服务器在开启防火墙时最容易遇到如下情况

执行dmesg命令，查看系统打印信息

nf_conntrack: table full, dropping packet

（链接追踪表已满）

这是相当常见的问题，而且十分严重，导致服务器随机丢弃请求，你的并发突破不了几千。

调优方式：

增加或者修改内核参数

::

    vim /etc/sysctl.conf
    net.nf_conntrack_max = 655360 （状态跟踪表的最大行数，16G的服务器）
    net.netfilter.nf_conntrack_tcp_timeout_established = 1200（设置超时时间）

修改完毕后执行sysctl-p生效命令。

time_wait
================

| 接下来，我们又会面临time_wait过多的情况。
| time_wait过多，会导致系统可用端口的减少，众所周知，linux随机端口的可用范围是32768-65535之间，用户通过80端口请求进来，服务器需要开启一个随机端口返回数据给用户，可用端口的减少必然影响到了用户的访问，接下来我们通过调整这两个内核参数来减少time_wait的数量
| 降低time_wait最大值，此操作会导致内核告警TCP: time wait bucket table overflow。但是可以提升并发，节约端口。
| net.ipv4.tcp_max_tw_buckets = 8000
| 增大可用端口范围，效果顾名思义
| net.ipv4.ip_local_port_range = 1024 65000

最后两个参数我忘记了是什么意思了，不过也加上吧 ：）

::

    net.ipv4.tcp_keepalive_time = 1200
    net.ipv4.tcp_max_syn_backlog = 81920

至此，你的nginx服务器可以愉快地跑起来了！

redis服务器内核调优
==========================

就一条

::

    vm.overcommit_memory = 1

| 为了避免当系统内存不足时，系统杀掉内存占用最大的程序（往往都是redis QAQ）。
| 不要忘了执行命令生效一下

elastic服务器内核调优
=================================

| 增大一个进程可以拥有的VMA(虚拟内存区域)的数量

::

    vm.max_map_count = 262144

| 降低使用交换分区的优先级（你还要在elastic程序中配置禁用交换分区）

::

    vm.swappiness = 1