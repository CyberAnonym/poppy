quota
#########

quota --  限制用户对磁盘空间的使用。


针对用户和组的磁盘配额实验

设置一个20G大小的分区做为配额限制分区：
==========================================

::

    [root@teacher ~]# fdisk /dev/sda
    [root@teacher ~]# partx -a /dev/sda
    [root@teacher ~]# ls /dev/sda*
    /dev/sda  /dev/sda1  /dev/sda2  /dev/sda3  /dev/sda4  /dev/sda5  /dev/sda6  /dev/sda7  /dev/sda8
    [root@teacher ~]# mkfs.ext4 /dev/sda8
    [root@teacher ~]# mkdir /sda8
    [root@teacher ~]# mount /dev/sda8 /sda8
    [root@teacher sda8]# chmod 1777 /sda8

添加配额限制参数
===========================

::

    [root@teacher ~]# vim /etc/fstab
    UUID=9a216799-0764-4b9f-b81f-ce82361ebc10 /sda8                 ext4    defaults,usrquota,grpquota      0 0

    [root@teacher sda8]# mount -o remount /dev/sda8
    [root@teacher sda8]# mount | grep /dev/sda8
    /dev/sda8 on /sda8 type ext4 (rw,usrquota,grpquota)

添加实验用户：
====================

::

    [root@teacher ~]# useradd u1 && passwd u1^C
    [root@teacher ~]# useradd u2 && passwd u2^C
    [root@teacher ~]# useradd u3 && passwd u3^C
    [root@teacher ~]# groupadd gquota
    [root@teacher ~]# usermod -g gquota u3
    [root@teacher ~]# id u3
    uid=1015(u3) gid=1018(gquota) groups=1018(gquota)

    [root@teacher sda8]# quotacheck -guv /sda8                --扫描/sda8分区，并创建正对用户和组的quota文件
                                                    --如果出现无权限创建，则需要关闭selinux
    [root@teacher sda8]# ls
    aquota.group  aquota.user  lost+found
    [root@teacher sda8]# ls -l
    total 32
    -rw------- 1 root root  6144 Apr  8 10:09 aquota.group
    -rw------- 1 root root  6144 Apr  8 10:09 aquota.user
    drwx------ 2 root root 16384 Apr  8 09:55 lost+found


编辑对u1用户的配额限制
================================

::

    [root@teacher sda8]# edquota -u u1
    Disk quotas for user u1 (uid 1013):
      Filesystem                   blocks       soft       hard     inodes     soft     hard
      /dev/sda8                         0        4096       5120          0        6        10
    [root@teacher sda8]# quotaon -a                        --启用配额限制

    #su - u1
    # cd /sda8
    [u1@teacher sda8]$ touch file{1,2,3,4,5}
    [u1@teacher sda8]$ touch file{6,7}
    sda8: warning, user file quota exceeded.
    [u1@teacher sda8]$ ls
    aquota.group  file1  file3  file5  file7
    aquota.user   file2  file4  file6
    [u1@teacher sda8]$ touch file{8,9,10}


编辑对gquota组的配额限制
===============================

::

    [root@teacher Desktop]# edquota -g gquota
    Disk quotas for group gquota (gid 1018):
      Filesystem                   blocks       soft       hard     inodes     soft     hard
      /dev/sda8                         0        3072       5120          0       3       5

    [root@teacher ~]# su - u3
    [u3@teacher ~]$ cd /sda8
    [u3@teacher sda8]$ ls
    aquota.group  aquota.user  file1  file2  file3  lost+found

验证文件个数限制
=========================

::

    [u3@teacher sda8]$ touch ufile{1,2,3}
    [u3@teacher sda8]$ touch ufile4
    sda8: warning, group file quota exceeded.
    [u3@teacher sda8]$ ls
    aquota.group  file1  file3       ufile1  ufile3
    aquota.user   file2  lost+found  ufile2  ufile4

    [u3@teacher sda8]$ touch ufile{5,6}
    sda8: write failed, group file limit reached.
    touch: cannot touch `ufile6': Disk quota exceeded

验证文件总大小的限制
==============================

::

    [u3@teacher sda8]$ dd if=/dev/zero of=/sda8/ufile1 bs=1M count=2^C
    [u3@teacher sda8]$ dd if=/dev/zero of=/sda8/ufile2 bs=1M count=2^C
    [u3@teacher sda8]$ dd if=/dev/zero of=/sda8/ufile3 bs=1M count=2^C



