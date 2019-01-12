kickstart
####################

kickstart文件制作与光盘镜像制作

kickstart是RedHat/CentOS/Fedora等系统实现无人值守自动化安装的一种安装方式，系统管理员可将安装过程中需要配置的所有参数集成于一个kickstart文件中，

而后在系统安装时，安装程序通过读取事先给定的这个kickstart文件自动化地完成配置并安装完成。


制作kickstart文件的方式
================================

#. 直接手动编辑，可以依据某个模板来进行修改；

#. 使用kickstart文件创建工具：system-config-kickstart进行配置，同样可以导入某个模板进行修改。

本文主要介绍使用 kickstart文件创建工具：system-config-kickstart 来定制kickstart：必须确保system-config-kickstart已经安装，如果没有安装可以使用yum安装：

    .. note::

        前提准备：
        要想配置kickstart ，首先要配置个本地yum源，要不然用system-config-kickstart时选不上包。
        而且，yum 源的名字一定是[base],要不然会报:


    这里我们先安装system-config-kickstart

    .. code-block:: bash

        yum install system-config-kickstart -y

    如果当前系统没有图形化，还需要安装图形化

    .. code-block:: bash

        yum groupinstall 'x window system' -y

    如果是用xshell连接的，这个时候就退出当前会话，然后重新连接。 然后执行system-config-kickstart去定义一个ks.cfg文件

    .. code-block:: bash

        system-config-kickstart

    设置好之后，我们保存在了/root目录下，然后修改下分区那里的东西，添加--encrypted --passphrase=wankaihao 用于加密分区

    .. code-block:: bash

        [root@common ~]# vim ks.cfg
        [root@common ~]# cat ks.cfg
        #platform=x86, AMD64, or Intel EM64T
        #version=DEVEL
        # Install OS instead of upgrade
        install
        # Keyboard layouts
        keyboard 'us'
        # Root password
        rootpw --iscrypted $1$jRGVLr3j$nmMBsbFlqUYJZqGPKGFH21
        # System language
        lang en_US
        # System authorization information
        auth  --useshadow  --passalgo=sha512
        # Use CDROM installation media
        cdrom
        # Use text mode install
        text
        firstboot --disable
        # SELinux configuration
        selinux --disabled

        # Firewall configuration
        firewall --disabled
        # Network information
        network  --bootproto=dhcp --device=eth0
        # Reboot after installation
        reboot
        # System timezone
        timezone Asia/Shanghai
        # System bootloader configuration
        bootloader --location=mbr
        # Clear the Master Boot Record
        zerombr
        # Partition clearing information
        clearpart --all --initlabel
        # Disk partitioning information
        part /boot --fstype="xfs" --size=1024
        part / --fstype="ext4" --grow --size=1 --encrypted --passphrase=wankaihao
        part /opt --fstype="xfs" --size=5000 --encrypted --passphrase=wankaihao
        part /usr/local/yunanbao --fstype="ext4" --size=5000 --encrypted --passphrase=wankaihao

        %post
        echo alvin >> /tmp/log
        %end
        [root@common ~]#

    用ksvalidator命令检查kickstart文件是否有语法错误

    .. code-block:: bash

        [root@common ~]# ksvalidator ks.cfg

制作光盘引导镜像
==========================

将bootloader、Kernel、initrd及kickstart文件制作成光盘镜像，以实现本地光盘镜像引导安装CentOS系统，其中anaconda应用程序位于initrd提供的rootfs中，

而后续安装用到的程序包来自阿里云镜像站点(mirrors.aliyun.com)，刚才在制作kickstart文件时已经手动指定。

#. 通过 df -h 命令确认光盘是否已挂载：

    .. code-block:: bash

        [root@common ~]# df -h|tail -1
        /dev/sr0                 4.3G  4.3G     0 100% /mnt/iso

#. 创建目录/data/centiso，并复制光盘的isolinux目录、刚才制作的kickstart文件centosks.cfg 到/data/centiso目录

    .. code-block:: bash

        cp -r /mnt/iso/isolinux /data/centiso/
        cp ks.cfg /data/centiso/

#. 修改/data/centiso/isolinux/isolinux.cfg配置文件，向默认启动的label所定义的内核传递参数，执行kickstart文件的存放位置





搭建基础环境

#yum install createrepo mkisofs isomd5sum squashfs-tools

#mkdir /root/PanISO

将/root/PanISO作为ISO的制作目录

::

    mount /dev/cdrom /media/
    cp -r /media/* /root/PanISO/
    cp  /media/.discinfo /root/PanISO/
    cp  /media/.treeinfo /root/PanISO/
    chmod +w /root/PanISO/isolinux/isolinux.cfg


修改isolinux.cfg文件，将“append initrd=initrd.img”后面的当前行内容删除，并加入“ks=cdrom:/isolinux/ks.cfg”。


::

    menu color timeout_msg 0 #ffffffff #00000000 none

    # Command prompt text
    menu color cmdmark 0 #84b8ffff #00000000 none
    menu color cmdline 0 #ffffffff #00000000 none

    # Do not display the actual menu unless the user presses a key. All that is displayed is a timeout message.

    menu tabmsg Press Tab for full configuration options on menu items.

    menu separator # insert an empty line
    menu separator # insert an empty line

    label linux
      menu label ^Install CentOS Linux 7
      kernel vmlinuz
      append initrd=initrd.img ks=cdrom:/isolinux/ks.cfg


.. code-block:: bash

    cp ks.cfg PanISO/isolinux/
    mkisofs -o Pan-7.3.iso -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long /root/PanISO/



kickstart设置逻辑卷
================================

::

    part /boot --fstype ext3 --size=400
    part swap --size=2048
    part pv.01 --size=1 --grow
    volgroup vg_rekfan pv.01
    logvol  /  --vgname=vg_rekfan  --size=40000  --name=lv_root
    logvol  /var  --vgname=vg_rekfan  --size=50000  --name=lv_var
    logvol  /tmp  --vgname=vg_rekfan  --size=2048  --name=lv_tmp
    logvol  /spare  --vgname=vg_rekfan  --size=1  --grow  --name=lv_spare