kickstart
####################

kickstart文件制作与光盘镜像制作

kickstart是RedHat/CentOS/Fedora等系统实现无人值守自动化安装的一种安装方式，系统管理员可将安装过程中需要配置的所有参数集成于一个kickstart文件中，

而后在系统安装时，安装程序通过读取事先给定的这个kickstart文件自动化地完成配置并安装完成。

各类参数参考官方文档： https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/s1-kickstart2-options

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
        part /usr/local/alvin --fstype="ext4" --size=5000 --encrypted --passphrase=wankaihao

        %post
        echo alvin >> /tmp/log
        %end
        [root@common ~]#

    用ksvalidator命令检查kickstart文件是否有语法错误

    .. code-block:: bash

        [root@common ~]# ksvalidator ks.cfg


.. note::

    pre 和post都是执行命令，但是pre是在系统安装之前执行，就是连分区都还没用分的时候，就执行的命令，在initramfs里执行的。 而post是在系统装好之后执行的。
    pre可以用于在系统安装前定义些变量，比如定义分区时，某些盘或uuid之类的可以先执行命令获取，然后被ks.cfg去调用使用，比如在ks.cfg里的%include /tmp/part-includepart命令使用，


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

::

    #yum install createrepo mkisofs isomd5sum squashfs-tools

    #mkdir /root/myiso

将/root/myiso作为ISO的制作目录

::

    mount /dev/cdrom /media/
    cp -r /media/* /root/myiso/
    cp  /media/.discinfo /root/myiso/
    cp  /media/.treeinfo /root/myiso/
    chmod +w /root/myiso/isolinux/isolinux.cfg


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

    cp ks.cfg myiso/isolinux/
    mkisofs -o Pan-7.3.iso -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long /root/myiso/



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



更新软件仓库
=====================

更新了rpm信息之后，一定要记得指定groupfile，用-g参数，否则安装系统的时候会提示找不到组。

.. code-block:: bash

    createrepo --update -g /root/myiso/repodata/83b61f9495b5f728989499479e928e09851199a8846ea37ce008a3eb79ad84a0-c7-minimal-x86_64-comps.xml myiso/



hello