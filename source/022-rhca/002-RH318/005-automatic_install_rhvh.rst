第五章：自动化安装rhvh
##############################

安装rhvh的方式
======================

我们有三种方法可以安装rhvh
    #. 通过rhvm的光盘进行安装
    #. 通过kickstart自动安装
    #. 将rhel转变为rhvm。


下面我们来使用kickstart自动化安装rhvh

共享相关目录
=============

.. code-block:: bash

    [root@ipa ~]# mkdir -p /vdisk
    [root@ipa ~]# mkdir -p /export
    [root@ipa ~]# mkdir -p /iso
    [root@ipa ~]# mkdir -p /ks
    [root@ipa ~]# vim /etc/exports
    [root@ipa ~]# exportfs -arv
    exporting *:/vdisk
    exporting *:/iso
    exporting *:/export
    exporting *:/ks
    [root@ipa ~]# cd /ks/
    [root@ipa ks]# vim ks.cfg
    liveimg --url=http://192.168.127.252/xx/squashfs.img
    clearpart --all
    autopart --type=thinp
    rootpw --plaintext redhat
    timezone --utc Asia/Shanghai
    zerombr
    text
    reboot
    %post --erroronfail
    nodectl
    %end

然后将rhvh光盘里的那个squashfs.img结尾的文件，弄到http://192.168.127.252/alvin/的目录下去。 我们可以通过挂载rhvh光盘，然后找到那个rpm包，然后解压那个rpm包的方式获得那个文件，然后放到我们指定的目录去。




安装配置dhcp府服务
========================


配置tftp服务
===============



把RHEL变成RHVH
===================

安装好需要的包就可以了，
    #. 安装vdsm
    #. 安装ovirt-node-ng-nodectl

