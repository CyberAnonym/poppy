给grub设置用户名和密码
######################################

通过grub2-mkpasswd-pbkdf2生成密码
==============================================


执行生成加密密码的命令"grub2-mkpasswd-pbkdf2",两次输入相同密码，PBKDF2 hash of your password is 之后的部分就是加密后的密码


.. code-block:: bash

    [root@test1 ~]# grub2-mkpasswd-pbkdf2
    Enter password:
    Reenter password:
    PBKDF2 hash of your password is grub.pbkdf2.sha512.10000.53CB2BB4BF569F5B0106C365860315EF522DAD3BF8AAB903AEB1DF1CBAB43C4061DC26DB25E21E4F2816B6186ABDE7038D7DC56F77A9B0927EE16D79F0A02CA2.9968FB3BB23E16EB823E2752FE8B765F75F39D4B18F6E9A9741FF4B6598CDED644894D18A30096933E37B7E033271E7921BFF19558A7780267FB1C01BF73BC6D


然后我们将密码传到/boot/grub2/user.cfg文件里去

.. code-block:: bash

    $ GRUB2_PASSWORD='grub.pbkdf2.sha512.10000.53CB2BB4BF569F5B0106C365860315EF522DAD3BF8AAB903AEB1DF1CBAB43C4061DC26DB25E21E4F2816B6186ABDE7038D7DC56F77A9B0927EE16D79F0A02CA2.9968FB3BB23E16EB823E2752FE8B765F75F39D4B18F6E9A9741FF4B6598CDED644894D18A30096933E37B7E033271E7921BFF19558A7780267FB1C01BF73BC6D'
    $ echo "GRUB2_PASSWORD=$GRUB2_PASSWORD"  > /boot/grub2/user.cfg

然后使其生效

.. code-block:: bash

    grub2-mkconfig -o /boot/grub2/grub.cfg

然后重启服务器验证。









上面的方法是比较新的方式，旧方法也可参考下面



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