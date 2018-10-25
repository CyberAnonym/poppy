第二章：安装rhvm
#####################



准备环境，挂载光盘
=========================
我们先把光盘挂到rhvm服务器上去,192.168.127.38是我的windows，一些资源都在我的windows上，然后将文件夹共享了出来。

.. code-block:: bash

    [root@rhevm ~]# mount //192.168.127.38/rhca//RH318/softAndDoc/ /alvin -o user=alvin.wan.cn@hotmail.com,password=mypassword
    [root@rhevm ~]# ll /alvin/
    total 14039429
    -rwxr-xr-x. 1 root root 9011552256 Oct  8 21:26 RHEL7RHV-4.1-20171204-x86_64.iso
    -rwxr-xr-x. 1 root root  495644672 Oct  8 20:28 rhel-7-server-rh-common-20170911.iso
    -rwxr-xr-x. 1 root root 3793747968 Oct  8 20:27 rhel-server-7.3-x86_64-dvd.iso
    -rwxr-xr-x. 1 root root     812635 Oct  8 20:16 rhev4.1安装指南.pdf
    -rwxr-xr-x. 1 root root    5301587 Oct  8 20:16 rhev4.1管理指南.pdf
    -rwxr-xr-x. 1 root root 1034944512 Oct  8 20:34 RHVH-4.1-20171002.1-RHVH-x86_64-dvd1.iso
    -rwxr-xr-x. 1 root root   34363924 Oct  8 20:17 virtio-win-1.8.0-1.el6.noarch.rpm
    -rwxr-xr-x. 1 root root         27 Oct  8 20:16 vm.txt




挂载光盘
=============

然后我们把光盘都挂载到指定的地方

.. code-block:: bash

    [root@rhevm ~]# umount /alvin
    [root@rhevm ~]# mkdir -p /rhv
    [root@rhevm ~]# mkdir -p /mnt/iso
    [root@rhevm ~]# mkdir -p /common
    [root@rhevm ~]# vim /etc/fstab
    //192.168.127.38/rhca//RH318/softAndDoc/ /alvin cifs defaults,_netdev,user=alvin.wan.cn@hotmail.com,password=mypassword 0 0
    /alvin/rhel-7-server-rh-common-20170911.iso /common iso9660 defaults 0 0
    /alvin/rhel-server-7.3-x86_64-dvd.iso /mnt/iso iso9660 defaults 0 0
    /alvin/RHEL7RHV-4.1-20171204-x86_64.iso /rhv    iso9660 defaults 0 0
    [root@rhevm ~]# mount -a
    mount: /dev/loop0 is write-protected, mounting read-only
    mount: /dev/loop1 is write-protected, mounting read-only
    mount: /dev/loop2 is write-protected, mounting read-only
    [root@rhevm ~]# df
    Filesystem                               1K-blocks      Used Available Use% Mounted on
    /dev/mapper/rhel-root                    195218296   3148972 192069324   2% /
    devtmpfs                                   8110020         0   8110020   0% /dev
    tmpfs                                      8125924        84   8125840   1% /dev/shm
    tmpfs                                      8125924      9080   8116844   1% /run
    tmpfs                                      8125924         0   8125924   0% /sys/fs/cgroup
    tmpfs                                      1625188        16   1625172   1% /run/user/42
    /dev/sda1                                   484004    168308    315696  35% /boot
    //192.168.127.38/rhca//RH318/softAndDoc/ 955661680 828817880 126843800  87% /alvin
    /dev/loop0                                  484028    484028         0 100% /common
    /dev/loop1                                 3704296   3704296         0 100% /mnt/iso
    /dev/loop2                                 8800344   8800344         0 100% /rhv

Configure yum repository
================================

.. code-block:: bash

    [root@rhevm ~]# vim /etc/yum.repos.d/rhv.repo
    [r1]
    name=r1
    baseurl=file:///common
    gpgcheck=0
    enable=1

    [r2]
    name=r2
    baseurl=file:///rhv/jb-eap-7-for-rhel-7-server-rpms
    gpgcheck=0
    enable=1


    [r3]
    name=r3
    baseurl=file:///rhv/rhel-7-server-rhv-4.1-rpms
    gpgcheck=0
    enable=1

    [r4]
    name=r4
    baseurl=file:///rhv/rhel-7-server-rhv-4-mgmt-agent-rpms
    gpgcheck=0
    enable=1

    [r5]
    name=r5
    baseurl=file:///rhv/rhel-7-server-rhv-4-tools-rpms
    gpgcheck=0
    enable=1

    [r6]
    name=r6
    baseurl=file:///rhv/rhel-7-server-rhvh-4-build-rpms
    gpgcheck=0
    enable=1

    [root@rhevm ~]# yum clean all
    Loaded plugins: langpacks, product-id, search-disabled-repos, subscription-manager
    This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    Cleaning repos: base r1 r2 r3 r4 r5 r6
    Cleaning up everything
    [root@rhevm ~]# yum repolist
