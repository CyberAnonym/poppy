centos7优化启动项，关闭一些不必要开启的服务
####################################################

CentOS7已不再使用chkconfig 管理启动项

使用 systemctl list-unit-files 可以查看启动项



::

    systemctl list-unit-files | grep enable 过滤查看启动项如下

    abrt-ccpp.service                                enabled abrt为auto bug report的缩写 用于bug报告 关闭
    abrt-oops.service                                enabled ----------------------
    abrt-vmcore.service                              enabled ----------------------
    abrt-xorg.service                                enabled ----------------------
    abrtd.service                                      enabled   ----------------------
    auditd.service                                   enabled 安全审计 保留
    autovt@.service                               enabled 登陆相关 保留
    crond.service                                          enabled 定时任务 保留
    dbus-org.freedesktop.NetworkManager.service    enabled 桌面网卡管理 关闭
    dbus-org.freedesktop.nm-dispatcher.service         enabled ----------------------
    getty@.service                                enabled tty控制台相关 保留
    irqbalance.service                          enabled 优化系统中断分配 保留
    kdump.service                                enabled 内核崩溃信息捕获 自定
    microcode.service                        enabled 处理器稳定性增强 保留
    NetworkManager-dispatcher.service              enabled 网卡守护进程 关闭
    NetworkManager.service                        enabled ----------------------
    postfix.service                            enabled 邮件服务 关闭
    rsyslog.service                              enabled 日志服务 保留
    snmpd.service                                enabled snmp监控 数据抓取 保留
    sshd.service                                  enabled ssh登陆 保留
    systemd-readahead-collect.service             enabled 内核调用--预读取 保留
    systemd-readahead-drop.service                enabled ----------------------
    systemd-readahead-replay.service              enabled ----------------------
    tuned.service                                     enabled #tuned 是服务端程序，用来监控和收集系统各个组件的数据，并依据数据提供的信息动态调整系统设置，达到动态优化系统的目的;
    default.target                                 enabled 默认启动项 multi-user.target的软连接 保留
    multi-user.target                             enabled 启动用户命令环境 保留
    remote-fs.target                               enabled 集合远程文件挂载点 自定
    runlevel2.target                              enabled 运行级别 用于兼容6的SysV 保留
    runlevel3.target                              enabled ----------------------
    runlevel4.target                              enabled ----------------------



默认状态下，这下服务可以设置关闭
=======================================

.. code-block:: bash

systemctl disable NetworkManager-dispatcher.service  #网卡守护进程 关闭
systemctl disable dbus-org.freedesktop.NetworkManager.service  #桌面网卡管理 关闭
systemctl disable postfix.service   # 邮件服务 关闭