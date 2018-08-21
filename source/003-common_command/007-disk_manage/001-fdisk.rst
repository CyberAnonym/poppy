fdisk
#####

fdisk是下的一个磁盘分区工具


当前我们有一块磁盘sdb,我们来通过fdisk来对sdb进行分区。


创建一个20G的分区。
=====================
.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,9,18,29,33,34,37,40,52,57

    [alvin@poppy ~]$ lsblk
    NAME                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                   8:0    0   20G  0 disk
    ├─sda1                8:1    0  500M  0 part /boot
    ├─sda2                8:2    0    1G  0 part [SWAP]
    └─sda3                8:3    0 18.5G  0 part
      └─vg_root-lv_root 253:0    0 18.5G  0 lvm  /
    sdb                   8:16   0  300G  0 disk
    [alvin@poppy ~]$ sudo fdisk /dev/sdb
    Welcome to fdisk (util-linux 2.23.2).

    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table
    Building a new DOS disklabel with disk identifier 0xba6f9a48.

    Command (m for help): p

    Disk /dev/sdb: 322.1 GB, 322122547200 bytes, 629145600 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk label type: dos
    Disk identifier: 0xba6f9a48

       Device Boot      Start         End      Blocks   Id  System

    Command (m for help): n
    Partition type:
       p   primary (0 primary, 0 extended, 4 free)
       e   extended
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-629145599, default 2048):
    Using default value 2048
    Last sector, +sectors or +size{K,M,G} (2048-629145599, default 629145599): +20G
    Partition 1 of type Linux and of size 20 GiB is set

    Command (m for help): p

    Disk /dev/sdb: 322.1 GB, 322122547200 bytes, 629145600 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk label type: dos
    Disk identifier: 0xba6f9a48

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1            2048    41945087    20971520   83  Linux

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.
    Syncing disks.
    [alvin@poppy ~]$ lsblk
    NAME                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                   8:0    0   20G  0 disk
    ├─sda1                8:1    0  500M  0 part /boot
    ├─sda2                8:2    0    1G  0 part [SWAP]
    └─sda3                8:3    0 18.5G  0 part
      └─vg_root-lv_root 253:0    0 18.5G  0 lvm  /
    sdb                   8:16   0  300G  0 disk
    └─sdb1                8:17   0   20G  0 part


格式化分区
================
创建分区之后，需要格式化分区才能使用。

这里我们将分区格式化为ext4格式。

.. code-block:: bash

    [alvin@poppy ~]$ sudo mkfs.ext4 /dev/sdb1
    mke2fs 1.42.9 (28-Dec-2013)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    1310720 inodes, 5242880 blocks
    262144 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=2153775104
    160 block groups
    32768 blocks per group, 32768 fragments per group
    8192 inodes per group
    Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done

挂载使用分区
===================
这里我们将刚分的去挂载到/data/目录。

.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,3,14,15

    [alvin@poppy ~]$ sudo mkdir -p /data/
    [alvin@poppy ~]$
    [alvin@poppy ~]$ df -h
    Filesystem                      Size  Used Avail Use% Mounted on
    /dev/mapper/vg_root-lv_root      19G  1.4G   18G   8% /
    devtmpfs                        901M     0  901M   0% /dev
    tmpfs                           912M   12K  912M   1% /dev/shm
    tmpfs                           912M  8.6M  904M   1% /run
    tmpfs                           912M     0  912M   0% /sys/fs/cgroup
    /dev/sda1                       477M  115M  333M  26% /boot
    tmpfs                           183M     0  183M   0% /run/user/10001
    dc.alv.pub:/ldapUserData/alvin  983G  595G  346G  64% /sophiroth/alvin
    tmpfs                           183M     0  183M   0% /run/user/0
    [alvin@poppy ~]$ sudo mount /dev/sdb1 /data
    [alvin@poppy ~]$ df -h
    Filesystem                      Size  Used Avail Use% Mounted on
    /dev/mapper/vg_root-lv_root      19G  1.4G   18G   8% /
    devtmpfs                        901M     0  901M   0% /dev
    tmpfs                           912M   12K  912M   1% /dev/shm
    tmpfs                           912M  8.6M  904M   1% /run
    tmpfs                           912M     0  912M   0% /sys/fs/cgroup
    /dev/sda1                       477M  115M  333M  26% /boot
    tmpfs                           183M     0  183M   0% /run/user/10001
    dc.alv.pub:/ldapUserData/alvin  983G  595G  346G  64% /sophiroth/alvin
    tmpfs                           183M     0  183M   0% /run/user/0
    /dev/sdb1                        20G   45M   19G   1% /data


设置磁盘自动挂载
=========================

.. code-block:: bash

    [alvin@poppy ~]$ cat /etc/fstab

    #
    # /etc/fstab
    # Created by anaconda on Fri Aug 10 17:14:42 2018
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk'
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    /dev/mapper/vg_root-lv_root /                       xfs     defaults        0 0
    UUID=b231e29f-06b8-4840-952f-0f7464e626bd /boot                   ext4    defaults        1 2
    UUID=1f2b5236-60c0-4402-a262-08fb7ac91502 swap                    swap    defaults        0 0
    [alvin@poppy ~]$ sudo bash -c "echo '/dev/sdb1 /data ext4 defaults 0 0' >> /etc/fstab "
    [alvin@poppy ~]$ cat /etc/fstab

    #
    # /etc/fstab
    # Created by anaconda on Fri Aug 10 17:14:42 2018
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk'
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    /dev/mapper/vg_root-lv_root /                       xfs     defaults        0 0
    UUID=b231e29f-06b8-4840-952f-0f7464e626bd /boot                   ext4    defaults        1 2
    UUID=1f2b5236-60c0-4402-a262-08fb7ac91502 swap                    swap    defaults        0 0
    /dev/sdb1 /data ext4 defaults 0 0
    [alvin@poppy ~]$ sudo umount /data
    [alvin@poppy ~]$ sudo mount -a
    [alvin@poppy ~]$ df -h /data
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/sdb1        20G   45M   19G   1% /data

