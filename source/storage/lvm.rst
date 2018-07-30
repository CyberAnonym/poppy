lvm
###
lvm - logic volume manage

准备好物理磁盘或分区
==============================

.. code-block:: bash

    [root@teacher Desktop]# ls /dev/sdb
    /dev/sdb
    [root@teacher Desktop]# ls /dev/sdc
    /dev/sdc
    [root@teacher Desktop]# ls /dev/sdc*
    /dev/sdc  /dev/sdc1  /dev/sdc2
    [root@teacher Desktop]# ls /dev/sdd
    /dev/sdd


创建物理卷（pv）
======================

.. code-block:: bash

    [root@teacher Desktop]# pvcreate /dev/sdb
    [root@teacher Desktop]# pvcreate  /dev/sdc2
    [root@teacher Desktop]# pvs
      PV         VG   Fmt  Attr PSize  PFree
      /dev/sdb        lvm2 a--  80.00g 80.00g
      /dev/sdc2       lvm2 a--  39.99g 39.99g

创建卷组（vg）
================
.. code-block:: bash

    [root@teacher Desktop]# vgcreate /dev/vg0 /dev/sdb /dev/sdc2
      Volume group "vg0" successfully created
    [root@teacher Desktop]# vgs
      VG   #PV #LV #SN Attr   VSize   VFree
      vg0    2   0   0 wz--n- 119.98g 119.98g

创建逻辑卷
================
.. code-block:: bash

    [root@teacher Desktop]# lvcreate -L 10G -n /dev/vg0/lv01 /dev/vg0
      Logical volume "lv01" created
    [root@teacher Desktop]# lvs
      LV   VG   Attr      LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
      lv01 vg0  -wi-a---- 10.00g

格式后挂载使用
================
.. code-block:: bash

    [root@teacher Desktop]# mkfs.ext4 /dev/vg0/lv01
    [root@teacher Desktop]# mkdir /mnt/lv01
    [root@teacher Desktop]# mount /dev/vg0/lv01 /mnt/lv01
    [root@teacher Desktop]# vim /etc/fstab                         --设置开机自动挂载


查看逻辑卷状态
===================
.. code-block:: bash

    [root@teacher lv01]# pvs
      PV         VG   Fmt  Attr PSize  PFree
      /dev/sdb   vg0  lvm2 a--  80.00g 70.00g
      /dev/sdc2  vg0  lvm2 a--  39.98g 39.98g
    [root@teacher lv01]# vgs
      VG   #PV #LV #SN Attr   VSize   VFree
      vg0    2   1   0 wz--n- 119.98g 109.98g
    [root@teacher lv01]# lvs
      LV   VG   Attr      LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
      lv01 vg0  -wi-ao--- 10.00g

    ******************************************************************************************

    [root@teacher lv01]# pvdisplay /dev/sdb                        --详细显示pv状态
      --- Physical volume ---
      PV Name               /dev/sdb
      VG Name               vg0
      PV Size               80.00 GiB / not usable 4.00 MiB
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              20479
      Free PE               17919
      Allocated PE          2560
      PV UUID               Jqgzop-F0rK-gf8g-EwSZ-YsrM-eGYE-QojNTq

    *********************************************************************************************
    [root@teacher lv01]# vgdisplay vg0                            --详细显示卷组的信息
      --- Volume group ---
      VG Name               vg0
      System ID
      Format                lvm2
      Metadata Areas        2
      Metadata Sequence No  4
      VG Access             read/write
      VG Status             resizable
      MAX LV                0
      Cur LV                1
      Open LV               1
      Max PV                0
      Cur PV                2
      Act PV                2
      VG Size               119.98 GiB
      PE Size               4.00 MiB
      Total PE              30715
      Alloc PE / Size       2560 / 10.00 GiB
      Free  PE / Size       28155 / 109.98 GiB
      VG UUID               VQ56JI-lHJs-yHhk-p1fD-oj0a-mWcV-FQMzGd
    *********************************************************************************************
    [root@teacher lv01]# lvdisplay /dev/vg0/lv01                        --详细显示逻辑卷的信息
      --- Logical volume ---
      LV Path                /dev/vg0/lv01
      LV Name                lv01
      VG Name                vg0
      LV UUID                o2sCgf-mnnn-N1pN-JqzC-BxTc-tMYr-yXj9NW
      LV Write Access        read/write
      LV Creation host, time teacher.uplooking.com, 2015-04-08 16:51:55 +0800
      LV Status              available
      # open                 1
      LV Size                10.00 GiB
      Current LE             2560
      Segments               1
      Allocation             inherit
      Read ahead sectors     auto
      - currently set to     256
      Block device           253:0



扩展vg
==========
.. code-block:: bash

    [root@teacher lv01]# pvcreate /dev/sdd
      Physical volume "/dev/sdd" successfully created
    [root@teacher lv01]# pvs
      PV         VG   Fmt  Attr PSize  PFree
      /dev/sdb   vg0  lvm2 a--  80.00g 70.00g
      /dev/sdc2  vg0  lvm2 a--  39.98g 39.98g
      /dev/sdd        lvm2 a--  80.00g 80.00g
    [root@teacher lv01]# vgextend vg0 /dev/sdd                --向vg中添加pv
      Volume group "vg0" successfully extended
    [root@teacher lv01]# vgs
      VG   #PV #LV #SN Attr   VSize   VFree
      vg0    3   1   0 wz--n- 199.98g 189.98g



从卷组中移除pv
====================
.. code-block:: bash

    [root@teacher lv01]# vgreduce vg0 /dev/sdd
      Removed "/dev/sdd" from volume group "vg0"
    [root@teacher lv01]# vgs
      VG   #PV #LV #SN Attr   VSize   VFree
      vg0    2   1   0 wz--n- 119.98g 109.98g


删除PV
==========
.. code-block:: bash

    [root@teacher lv01]# pvremove /dev/sdd
      Labels on physical volume "/dev/sdd" successfully wiped
    [root@teacher lv01]# pvs
      PV         VG   Fmt  Attr PSize  PFree
      /dev/sdb   vg0  lvm2 a--  80.00g 70.00g
      /dev/sdc2  vg0  lvm2 a--  39.98g 39.98g

在线扩展lv：
====================
.. code-block:: bash

    [root@teacher lv01]# lvextend -v -L +10G /dev/vg0/lv01
                    -v:显示创建过程
                    -L:指定扩展的大小 （+10G:扩展10G,30G:扩展到30G）
    [root@teacher lv01]# lvs
      LV   VG   Attr      LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
      lv01 vg0  -wi-ao--- 20.00g
    [root@teacher lv01]# df -h | grep lv01                        --df查看没变化
    /dev/mapper/vg0-lv01  9.9G  151M  9.2G   2% /mnt/lv01


    [root@teacher lv01]# resize2fs /dev/vg0/lv01                    --在线扩展文件系统
            --如果报以下错误：please run "e2fsck -f /dev/vg0/lv01" first
            --直接执行提示的命令即可(e2fsck -f /dev/vg0/lv01)
    [root@teacher lv01]# df -h | grep lv01
    /dev/mapper/vg0-lv01   20G  156M   19G   1% /mnt/lv01

回缩逻辑卷
====================
.. code-block:: bash

    生产环境中要先备份数据，再回缩文件系统
    [root@teacher ~]# resize2fs /dev/vg0/lv01 10G                    --回缩文件系统
    [root@teacher ~]# e2fsck -f /dev/vg0/lv01                        --磁盘检测
    [root@teacher ~]# lvreduce -v -L 10G /dev/vg0/lv01                --回缩逻辑卷（回缩到10G）
    [root@teacher ~]# lvs
      LV   VG   Attr      LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
      lv01 vg0  -wi-a---- 10.00g
    [root@teacher ~]# mount /dev/vg0/lv01 /mnt/lv01
    [root@teacher ~]# df -h

拆除逻辑卷的过程
====================
.. code-block:: bash

    [root@teacher ~]# umount /mnt/lv01                        --卸载
    [root@teacher ~]# vim /etc/fstab                             --清除开机自动启动项
    [root@teacher ~]# lvremove /dev/vg0/lv01                     --删除lv
    [root@teacher ~]# vgremove vg0                            --删除vg
    [root@teacher ~]# pvremove /dev/sdc2                        --删除pv
    [root@teacher ~]# pvremove /dev/sdb                        --删除pv



查看lv的物理分布
=======================
.. code-block:: bash

    [root@teacher ~]# lsblk -f                            --查看lv的物理分布
    NAME   FSTYPE    LABEL                   UUID                                   MOUNTPOINT
    sda
    ├─sda1 ext4                              7631883b-5824-4ed5-a730-b8d2ea45c14d   /boot
    ├─sda2 ext4                              b18be717-ca34-41c2-8291-994f0a07d9a2   /
    ├─sda3 swap                              116f98e8-74bf-44e2-8787-07a9271ae2e5   [SWAP]
    ├─sda4
    ├─sda5 ext2                              0ecfcbe1-d9a3-4af5-b11a-e754e61725bc   /sda5
    ├─sda6 ext4      soft                    624daed7-28e7-462e-bb59-c0f806994167   /sda6
    ├─sda7 swap                              5d858574-18c1-4d62-9b84-5ec6dc205ae9   [SWAP]
    └─sda8 ext4                              9a216799-0764-4b9f-b81f-ce82361ebc10   /sda8
    sdb    LVM2_memb                         Aq6Dbw-PEX1-jsfX-pjb6-cKsQ-lzhr-61lj0y
    └─vg0-lv01 (dm-0)

    sdc
    ├─sdc1 linux_rai teacher.uplooking.com:0 33bcd246-b3a6-77d0-7666-a8f6b13f6521
    └─sdc2 LVM2_memb                         11C3kp-VePT-6Xfc-9m4G-4kYY-Tnmz-DEUcoz
    sdd    LVM2_memb                         xhdIyN-HRvB-wONX-hedx-mO2S-DatH-9332FJ
    sr0    iso9660   RHEL_6.4 x86_64 Disc 1





fdisk分区
==================

.. code-block:: bash

    fdisk /dev/sdb
    p #打印看看
    n #开始分区
        #回车
        #回车
    +500M
    w
    partprobe #通知内核重新读取分区表














