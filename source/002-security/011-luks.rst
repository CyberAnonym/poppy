luks
########

LUKS(Linux Unified Key Setup)为Linux硬盘加密提供了一种标准，操作简单，只有在挂载磁盘时需要输入密码，在写入和读取磁盘时不需要。
当然我们在日常的服务器运维中几乎很少会给磁盘进行加密，不过可以对U盘进行加密。

LUKS使用密码验证
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


使用秘钥免密码验证
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