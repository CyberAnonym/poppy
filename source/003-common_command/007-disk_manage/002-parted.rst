parted
#######

Linux下的分区工具，能分区gtp格式的。


查看当前系统磁盘分区状况
============================

.. code-block:: bash

    [root@poppy ~]# parted /dev/sda print            --打印分区信息
    [root@poppy ~]# parted /dev/sdb mkpart primary 1 2T
    Error: /dev/sdb: unrecognised disk label
    [root@poppy ~]# parted /dev/sdb mklabel msdos(gpt)    --指定分区表类型

    [root@poppy ~]# parted -l                            --查看分区信息


    [root@poppy ~]# parted /dev/sdb mkpart primary 2T 6T        --分区大于2T
    Error: partition length of 7812499456 sectors exceeds the
    msdos-partition-table-imposed maximum of 4294967295
    [root@poppy ~]# parted /dev/sdb mklabel gpt

    [root@poppy ~]# parted /dev/sdb mkpart primary 2T 6T        --创建成功


    [root@poppy ~]# parted /dev/sdb rm 1                    --删除分区
    [root@poppy ~]# parted /dev/sdb mklabel msdos            --变回msdos分区
    [root@poppy ~]# parted /dev/sdb mkpart extended 2T 4T        --建立扩展分区
    [root@poppy ~]# parted /dev/sdb mkpart logical 2000G 2100G    --建立逻辑分区
    [root@poppy ~]# parted -l
    [root@poppy ~]# parted /dev/sdb mkpart logical 2100G 2500G    --建立第二个逻辑
    Information: You may need to update /etc/fstab.

    [root@poppy ~]# parted -l
    Model: VMware, VMware Virtual S (scsi)
    Disk /dev/sda: 537GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system     Flags
     1      1049kB  211MB   210MB   primary  ext4            boot
     2      211MB   43.2GB  42.9GB  primary  ext4
     3      43.2GB  45.3GB  2147MB  primary  linux-swap(v1)


    Model: VMware, VMware Virtual S (scsi)
    Disk /dev/sdb: 8796GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type      File system  Flags
     1      1049kB  2000GB  2000GB  primary
     2      2000GB  4000GB  2000GB  extended               lba
     5      2000GB  2100GB  100GB   logical
     6      2100GB  2500GB  400GB   logical

