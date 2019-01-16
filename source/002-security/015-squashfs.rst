squashfs
##################

安装软件

yum install squashfs-tools -y

解压镜像获取squashfs
=============================



创建目录

.. code-block:: bash

    [root@test1 ~]# mkdir -p /mnt/{iso,rootfs}
    [root@test1 ~]# mkdir {myiso,squashfs}


挂载镜像

.. code-block:: bash

    [root@test1 ~]# mount /dev/sr0 /mnt/iso/
    mount: /dev/sr0 is write-protected, mounting read-only
    [root@test1 ~]#


拷贝镜像内容到本地

.. code-block:: bash

    [root@test1 ~]# cp -rap /mnt/iso/* myiso/


拷贝squashfs.img 到指定目录并解压

.. code-block:: bash

    [root@test1 ~]# cp myiso/LiveOS/squashfs.img squashfs/
    [root@test1 ~]# cd squashfs/
    [root@test1 squashfs]# unsquashfs squashfs.img


挂载rootfs.img

.. code-block:: bash

    [root@test1 squashfs]# mount squashfs-root/LiveOS/rootfs.img /mnt/rootfs/



测试、修改chroot
====================

测试chroot

.. code-block:: bash

    [root@test1 ~]# chroot /mnt/rootfs/
    bash-4.2#
    bash-4.2# echo alvin >> hello.txt
    bash-4.2# cat hello.txt
    alvin
    bash-4.2# ls
    bin  dev  etc  firmware  hello.txt  lib  lib64	lost+found  mnt  modules  proc	root  run  sbin  sys  tmp  usr	var
    bash-4.2# exit


刚才我们在rootfs里创建了一个文件，现在我们将修改后的内容打包,这里我们打包到为/tmp/squashfs1.img




打包squashfs.img
===========================

.. code-block:: bash

    umount /mnt/rootfs
    mksquashfs squashfs-root /tmp/squashfs.img -noappend -all-root


然后我们可以验证一下是squashfs1.img里的rootfs.img，是否是我们修改后的


.. code-block:: bash

    [root@test1 tmp]# unsquashfs squashfs.img
    Parallel unsquashfs: Using 4 processors
    1 inodes (16384 blocks) to write

    [=========================================================================================================================================================================================================================================================|] 16384/16384 100%

    created 1 files
    created 2 directories
    created 0 symlinks
    created 0 devices
    created 0 fifos
    [root@test1 tmp]# cd squashfs-root/
    [root@test1 squashfs-root]# mount LiveOS/rootfs.img /mnt/rootfs/
    [root@test1 squashfs-root]# ls /mnt/rootfs/
    bin  dev  etc  firmware  lib  lib64  lost+found  mnt  modules  ok  proc  root  run  sbin  sys  tmp  usr  var
    [root@test1 squashfs-root]# mksquashfs squashfs-root /tmp/squashfs1.img -noappend -all-root


如上所示，我们看到了我们之前创建的那个ok文件。


然后覆盖原镜像

[root@test1 tmp]# cp squashfs1.img ~/myiso/LiveOS/squashfs.img
cp: overwrite ‘/root/myiso/LiveOS/squashfs.img’? y


打包新的镜像
========================


    [root@test1 tmp]# cd
    [root@test1 ~]# mkisofs -o alvin_custom.iso -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long /root/myiso/
