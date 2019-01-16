给grub设置用户名和密码
######################################

1)、执行生成加密密码的命令"grub2-mkpasswd-pbkdf2",两次输入相同密码，PBKDF2 hash of your password is 之后的部分就是加密后的密码




给grub菜单加密，就是为了不让不法分子利用单用户模式修改root密码，请看操作记录



 在/etc/grub.d/00_header 文件末尾，添加以下内容

::

    cat <<EOF
    set superusers='admin'
    password admin qwe123
    E0F


重新编译生成grub.cfg文件

::

    grub2-mkconfig  -o  /boot/grub2/grub.cfg


重启做验证




grub参数解释
=======================

crashkernel=auto  #自动分配给内核预留的内存



::

    init=   ：指定Linux启动的第一个进程init的替代程序。
    root=   ：指定根文件系统所在分区，在grub中，该选项必须给定。
    ro,rw   ：启动时，根分区以只读还是可读写方式挂载。不指定时默认为ro。
    initrd  ：指定init ramdisk的路径。在grub中因为使用了initrd或initrd16命令，所以不需要指定该启动参数。
    rhgb    ：以图形界面方式启动系统。
    quiet   ：以文本方式启动系统，且禁止输出大多数的log message。
    net.ifnames=0：用于CentOS 7，禁止网络设备使用一致性命名方式。
    biosdevname=0：用于CentOS 7，也是禁止网络设备采用一致性命名方式。
                 ：只有net.ifnames和biosdevname同时设置为0时，才能完全禁止一致性命名，得到eth0-N的设备名。