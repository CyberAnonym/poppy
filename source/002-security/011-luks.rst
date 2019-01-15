luks
########



LUKS(Linux Unified Key Setup)为Linux硬盘加密提供了一种标准，操作简单，只有在挂载磁盘时需要输入密码，在写入和读取磁盘时不需要。
当然我们在日常的服务器运维中几乎很少会给磁盘进行加密，不过可以对U盘进行加密。

1. LUKS使用密码验证
============================

#. 准备一块没有格式化的磁盘

    这里我们准备了一块名为sdb的20G的磁盘

    .. code-block:: bash

        [root@common ~]# lsblk
        NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda               8:0    0  100G  0 disk
        ├─sda1            8:1    0    1G  0 part /boot
        └─sda2            8:2    0   99G  0 part
          └─centos-root 253:0    0   99G  0 lvm  /
        sdb               8:16   0   20G  0 disk
        sr0              11:0    1  4.3G  0 rom

#. 对磁盘进行分区，不格式化

    .. note::

        这里分区后不要格式化

    下面我们通过fdisk /dev/sdb 创建了一个sdb1,10G的空间，创建过程在本文中不表现

    .. code-block:: bash

        [root@common ~]# lsblk
        NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda               8:0    0  100G  0 disk
        ├─sda1            8:1    0    1G  0 part /boot
        └─sda2            8:2    0   99G  0 part
          └─centos-root 253:0    0   99G  0 lvm  /
        sdb               8:16   0   20G  0 disk
        └─sdb1            8:17   0   10G  0 part
        sr0              11:0    1  4.3G  0 rom


#. 利用cryptsetup对磁盘进行加密格式化

    .. code-block:: bash

        [root@common ~]# cryptsetup luksFormat /dev/sdb1

        WARNING!
        ========
        This will overwrite data on /dev/sdb1 irrevocably.

        Are you sure? (Type uppercase yes): YES
        Enter passphrase for /dev/sdb1:
        Verify passphrase:

#. 打开并自动挂载加密的磁盘

    .. code-block:: bash

        [root@common ~]# cryptsetup luksOpen /dev/sdb1 test
        Enter passphrase for /dev/sdb1:
        [root@common ~]#
        [root@common ~]# ls /dev/mapper/
        centos-root  control  test

#. 格式化映射的设备，格式化成ext4文件系统

    .. code-block:: bash

        [root@common ~]# mkfs.ext4 /dev/mapper/test


#. 挂载

    .. code-block:: bash

        [root@common ~]# mount /dev/mapper/test /mnt/test/
        [root@common ~]#
        [root@common ~]# ls /mnt/test/
        lost+found
        [root@common ~]#
        [root@common ~]# df -TH
        Filesystem              Type      Size  Used Avail Use% Mounted on
        /dev/mapper/centos-root xfs       107G  1.2G  106G   2% /
        devtmpfs                devtmpfs  498M     0  498M   0% /dev
        tmpfs                   tmpfs     510M     0  510M   0% /dev/shm
        tmpfs                   tmpfs     510M  8.0M  502M   2% /run
        tmpfs                   tmpfs     510M     0  510M   0% /sys/fs/cgroup
        /dev/sda1               xfs       1.1G  139M  925M  14% /boot
        tmpfs                   tmpfs     102M     0  102M   0% /run/user/0
        /dev/mapper/test        ext4       11G   38M  9.9G   1% /mnt/test
        [root@common ~]# touch /mnt/test/alvin
        [root@common ~]# ll /mnt/test/alvin
        -rw-r--r--. 1 root root 0 Jan 11 14:37 /mnt/test/alvin
        [root@common ~]#
        [root@common ~]# lsblk
        NAME            MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
        sda               8:0    0  100G  0 disk
        ├─sda1            8:1    0    1G  0 part  /boot
        └─sda2            8:2    0   99G  0 part
          └─centos-root 253:0    0   99G  0 lvm   /
        sdb               8:16   0   20G  0 disk
        └─sdb1            8:17   0   10G  0 part
          └─test        253:1    0   10G  0 crypt /mnt/test
        sr0              11:0    1  4.3G  0 rom


#. 使用完成后卸载，卸载挂载点test

    .. code-block:: bash

        umount /mnt/test

#. 关闭映射设备

    .. code-block:: bash

        [root@common ~]# cryptsetup luksClose test
        [root@common ~]# ls /dev/mapper/

.. note::

    上述过程中，对分区的读写操作是不会出现输入密码验证的，只有在关闭映射的设备之后再重新打开时才会要求输入密码，这时候起到了加密的作用。

.. tip::

    另外注意luks是Linux特有的，在unix、mac、windows等操作系统下通过luks加密的磁盘是无法打开的。


2. 使用秘钥免密码验证
==============================

#. 使用随机数生成一个密码文件，为4096位即可

    .. code-block:: bash

        dd if=/dev/urandom of=/passwd_test bs=4096 count=1

#. 对密码文件设置权限，其他人不允许读取和写入，600

    .. code-block:: bash

        chmod 600 /passwd_test

#. 用key加密对上面做的/dev/sdc1加密

    .. code-block:: bash

        cryptsetup luksAddKey /dev/sdb1 /passwd_test

#. 编辑/etc/crypttab，配置认证秘钥

    这个配置就是会将/dev/sdb1在开机的时候映射到/dev/mapper/test

    .. code-block:: bash

        [root@common ~]# vi /etc/crypttab
        [root@common ~]# cat /etc/crypttab
        test /dev/sdb1 /passwd_test

#. 编辑/etc/fstab，配置开机自动挂载

    .. code-block:: bash

        [root@common ~]# vi /etc/fstab
        [root@common ~]# tail -1 /etc/fstab
        /dev/mapper/test /mnt/test ext4 defaults 0 0


    上面配置完成后，重启系统，/mnt/test会自动挂载。

手动用keyfile进行映射

.. code-block:: bash

    cryptsetup luksOpen -d /passwd_test /dev/sdb1 test

3. 加密根分区免密进系统
===================================


加密根分区
--------------------


.. code-block:: bash

    [root@test3 ~]# lsblk
    NAME                                          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                                             8:0    0   20G  0 disk
    ├─sda1                                          8:1    0    1G  0 part  /boot
    └─sda2                                          8:2    0   19G  0 part
      └─luks-7c9f8240-a395-4541-90db-e66456aec1be 253:0    0   19G  0 crypt /

将根分区所在的加密设备，放入变量，便于后续使用

.. code-block:: bash

    ROOT_DEVICE=/dev/sda2

.. note::

    如果当前系统使用的是逻辑卷，比如lsblk的状态是这样的

    .. code-block:: bash

        [root@test4 ~]# lsblk
        NAME                                            MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
        sda                                               8:0    0   20G  0 disk
        ├─sda1                                            8:1    0    1G  0 part  /boot
        └─sda2                                            8:2    0   19G  0 part
          └─centos-root                                 253:0    0   19G  0 lvm
            └─luks-73585d9b-b7f6-4473-8aa3-4b380930eab8 253:1    0   19G  0 crypt /
        sr0                                              11:0    1  4.3G  0 rom

    那么ROOT_DEVICE=/dev/centos/root


创建key file
-------------------

#. 使用随机数生成一个密码文件，为4096位即可

    .. code-block:: bash

        dd if=/dev/urandom of=/tmp/keyfile bs=4096 count=1

#. 对密码文件设置权限，其他人不允许读取和写入，600

    .. code-block:: bash

        chmod 600 /tmp/keyfile

#. 用key加密对上面做的$ROOT_DEVICE加密

    .. code-block:: bash

        cryptsetup luksAddKey $ROOT_DEVICE /tmp/keyfile


修改initramfs
---------------------------


创建新的initramfs，忽略systemd
----------------------------------------------
因为systemd会让luks使用密码进行验证，如果不禁用的话，后续修改grub制定keyfile那些操作也不会生效。

.. code-block:: bash

    mkdir -p initramfs
    cd initramfs
    dracut -o "systemd" no-systemd-initramfs.img


解压initramfs
+++++++++++++++++++++++++

.. code-block:: bash

    [root@auto3 initramfs]# /usr/lib/dracut/skipcpio no-systemd-initramfs.img  | zcat | cpio -id --no-absolute-filenames
    [root@auto3 initramfs]# ls
    bin  dev  etc  init  lib  lib64  no-systemd-initramfs.img  proc  root  run  sbin  shutdown  sys  sysroot  tmp  usr  var
    [root@auto3 initramfs]# mv no-systemd-initramfs.img ..



.. note::

    如果上面的命令解压的时候没有解压成功，可以使用下面的命令

    .. code-block:: bash

        cpio -idmv < no-systemd-initramfs.img

添加keyfile到initramfs的根
--------------------------------------

.. code-block:: bash

    [root@auto3 initramfs]# cp /tmp/keyfile .

注释一行包含unicode的参数，避免开机报错
-------------------------------------------------------

这里我们注销一行内容，注销的内容是 #inst_key_val 1  /etc/vconsole.conf rd.vconsole.font.unicode vconsole.font.unicode UNICODE vconsole.unicode

如果不注销这行内容，启动系统时会报错/etc/vconsole.conf: line 1: vconsole.font.unicode=1: command not found， 虽然不影响进入系统，但没有这个报错出现会更好。

.. code-block:: bash

    [root@auto3 initramfs]# sed -i 's/.*unicode.*/#&/' usr/lib/dracut/hooks/cmdline/20-parse-i18n.sh

设置initramfs里的etc/crypttab
-----------------------------------------

.. code-block:: bash

    uuid=`blkid $ROOT_DEVICE|awk -F 'UUID="' '{print $2}' |awk -F '"' '{print $1}'`  #根分区在$ROOT_DEVIC
    echo "luks-$uuid /dev/disk/by-uuid/$uuid /keyfile" > etc/crypttab

打包新的initramfs.img
-------------------------------------

.. code-block:: bash

    [root@auto3 initramfs]# find . | cpio -c -o > ../initrd.img

用新的initramfs.img替换旧的
----------------------------------------

.. code-block:: bash

    [root@auto3 initramfs]# cp /boot/initramfs-3.10.0-957.el7.x86_64.img /boot/initramfs-3.10.0-957.el7.x86_64.img.bak
    [root@auto3 initramfs]# \cp ../initrd.img /boot/initramfs-3.10.0-957.el7.x86_64.img


修改grub
--------------

.. code-block:: bash

    sed -i.bak 's/crashkernel=auto/& rd.luks.key=\/keyfile/' /etc/default/grub
    grub2-mkconfig >/etc/grub2.cfg

重启验证
--------------

    .. code-block:: bash

        reboot