内存优化
#############

- 内存的特点:

    速度快,所存数据不会保存,内存的最大消耗来源于进程

-测试内存速度：

    安装软件:memtest86+-4.10-2.el6.x86_64.rpm
    执行 memtest-setup命令 多出一个操作系统

- 内存存储的数据有那些?

    程序代码,程序定义的变量(初始化和未初始化),继承父进程的环境变量,进程读取的文件,程序需要的库文件.还有程序本身动态申请的内存存放自己的数据
    除了进程以外还有内核也要占用,还有buffer和cache,还有共享内存(如共享库)
    我们使用管道符| 进程之间通讯也要使用到内存,socket文件

- 那我们可以优化哪部分程序?

    内核内存不能省
    buffer/cache不能省
    进程通讯不省

- 系统支持的内存大小：

    2的32次方 32位系统支持的内存  windows受到约束  linux只要换个pae(物理地址扩展)内核 可以支持2的36次方
    2的64次方

- 查看系统内存信息

.. code-block:: bash

    [root@alvin ~]# free -m
		        total   	    used 	free 	shared 	buffers 	cached
    Mem: 	1010 	    981 		29 		0 		145 		649
    -/+ buffers/cache: 	186 		824
    Swap: 	2047 	    0 		    2047

    share 在6之前包括6，这个地方永远都是0，已经被废弃了，rhel7里面已经可以正常显示
    # cat /proc/meminfo | grep -i shm   share就是这个值,free和vmstat都是从/proc/meminfo文件里面搜集的信息
    Shmem:             26620 kB

    used包括buffers和cached，是已使用的内存+buffers+cached ，剩下的是free
    -/+ buffers/cache:        186       824
    186是减去buffers和cached之后的物理内存，824是总内存减去186之后的值

    buffers  索引缓存 存inode信息
    cached 页缓存    存block信息
            catched实验:
                # watch -n 0.5 free -m  监控内存信息
                在另外一个窗口dd一个1G的文件，观察buffer和cache
                # dd if=/dev/zero of=abc bs=1000M count=1
                从/dev/zero里面读了1G数据到cache里面
                dd之前:
                             total	     used       free     shared    buffers     cached
                Mem:     3724    619        3105          0         59        242
                dd之后:
                             total	     used       free     shared    buffers   cached
                Mem:     3724    1652       2071          0         59       1246

            buffers实验:
                #find /      把/下所有文件都列出来  会读到directory block，通过inode找到文件名，有多少个文件就会读多少次目录块，所以我们现在的查找实际上是块操作，所以使用的是buffer
                find之后:
                             total	     used       free     shared    buffers     cached
                Mem:     3724    1713       2010          0         95       1246

.. code-block:: bash

    [root@alvin ~]# vmstat
    procs -----------memory----------           ---swap--   -----io---- 	--system-- -----cpu------
    r b 	swpd   free   buff       cache     	si 	so     	bi 	bo 	in 	 cs 	       us sy id wa st
    0 0 	0 	    48584 118300 663564   	0  	0  	        12 23 	60  240 	   3  2   95 0  0

- procs:

    r   正在运行或可运行的进程数，如果长期大于cpu个数，说明cpu不足，需要增加cpu
    b  block  但是这个是阻塞，表示在等待资源的进程数，比如正在等待I/O、或者内存交换等。  由于硬盘速度特别慢而导致内存同步的时候没成功，那么现在告诉程序，说你先不要产生数据，这就是阻塞
    b越大证明硬盘压力很大

- memory

	swpd 切换到内存交换区的内存数量(k表示)。如果swpd的值不为0，或者比较大，比如超过了100m，只要si、so的值长期为0，系统性能还是正常
	free 当前的空闲页面列表中内存数量(k表示)
	buff 作为buffer cache的内存数量
	cache: 作为page cache的内存数量
- swap

    si swapin    把swap分区的数据放到内存
    so swapout  把内存数据放到磁盘
    通过上面两个可以分析内存的使用情况，如果swap有数据是不是内存不够用了？不一定，因为系统会把一些用不到的进程放到swap里面，把腾出来的空间做缓存，如果发现si,so里面有数据，说明内存可能不够用了

- IO

    bi blockin 这个是块 进来  ，把块儿从硬盘搬进来，也就是说bi是读
    bo blockout  把块儿从内存搬到硬盘，也就是说bo是写

    实验:
        # vmstat -1
        # dd if=/dev/zero  of=/aa bs=1G count=1   //这条命令之后查看bo的数值，发现bo产生数据
        记录了1+0 的读入
        记录了1+0 的写出
        1073741824字节(1.1 GB)已复制，4.90872 秒，219 MB/秒

        #find /        //这条命令之后查看bi，发现bi产生数据
        如果 一直开着vmstat发现bo 5秒钟一个数，这就是因为脏数据5秒钟一次
        如果要拿这个数据做图，bo的第一个数据一定要剔除到，这个数字是上一次重启到敲vmstat这条命令之间的平均值，所以这个数字没用

- system 显示采集间隔内发生的中断数

	in 列表示在某一时间间隔中观测到的每秒设备中断数。
	cs列表示每秒产生的上下文切换次数

-cpu：

    剩下的就是cpu的各种使用百分比

以上解释都可以查看man手册:#man vmstat


buffer/cache
==================
根据时间和数据大小同步  主要用于写缓存

内核里面的一套系统：伙伴系统，负责把内存里面的数据往硬盘上搬

- rhel5：

kswapd pdflush

kswapd负责说什么时候搬数据

pdflush负责干活儿,他会一直开启着

- rhel6:

kswapd负责说什么时候搬数据，但是干活儿的不是pdflush了

有需要搬的数据的时候，才产生一个进程---> flush 主设备号:从设备号 负责搬数据

已经同步到硬盘的数据就是干净数据

.. code-block:: bash

    # cat /proc/sys/vm/dirty_    查看的是脏数据（缓存内还没来得急同步到硬盘的数据）
    dirty_background_bytes     dirty_expire_centisecs
    dirty_background_ratio     dirty_ratio
    dirty_bytes                dirty_writeback_centisecs

    [root@alvin ~]# cat /proc/sys/vm/dirty_expire_centisecs   //想知道这里面是什么可以使用下面的man或者kernel-doc查看
    2999        //单位百分之一秒，这里也就是30秒，30秒之后标记为脏数据，意味着用户写的数据在30秒之后才有可能被刷入磁盘，在这期间断电可能会丢数据

    [root@alvin ~]# cat /proc/sys/vm/dirty_writeback_centisecs
    499         //  5秒钟往硬盘同步一次数据5秒同步一次脏数据（在缓存中的）

    假如我内存1G
    1秒  100M
    2秒  300M
    3秒  400M
    4秒  400M
    还没到5秒，但是内存使用已经超过1G了，这时候怎么办？下面的文件来解决
    [root@alvin ~]# cat /proc/sys/vm/dirty_ratio
    40          //如果单个进程占用的buffer/cache达到内存总量的40%,立刻同步。

    假如我内存1G，一个进程
    1秒  1M
    2秒  3M
    3秒  4M
    4秒  40M
    那要是1000个进程呢？这时候怎么办？下面的文件来解决
    [root@alvin ~]# cat /proc/sys/vm/dirty_background_ratio
    10          //所有进程占用的buffer/cache使得剩余内存低于内存总量的10%，立刻同步

    # cat /proc/sys/vm/dirty_background_bytes //上面的ratio文件用百分比，这个用字节限制，但是百分比存在的时候，字节不生效
    0

如果服务器是一个数据服务器，比如NAS，dirty_writeback和dirty_ratio里面的数值可以适当改大一点,存储需要频繁读数据的时候，可以直接从内存里面读，而且在同步数据的时候会使用更大的连续的块儿。


释放buffer/cache
=======================
.. code-block:: bash

    [root@alvin ~]# cat /proc/sys/vm/drop_caches
    0
    1 释放buffer
    3 buffer/cache都释放

    需要编译安装一个程序，在make的时候报错内存不足，这时候就可以释放一下缓存，一般情况下不要用
    # watch -n 0.5 free -m
    # echo 3 > /proc/sys/vm/drop_caches


内存如果真耗尽了，后果无法预测

OOM进程  OOM killer
============================

当内存耗尽的时候，系统会出现一个OOM killer进程在系统内随机杀进程

每个运行的程序都会有一个score(分)，这个是不良得分，所以谁分高，就杀谁

如果还不行的话，他会自杀，也就是杀kernel，就会出现内核恐慌(panic),所以会死机

实验：

.. code-block:: bash

    #cat
    # ps -el | grep cat
    0 S     0  9566  2975  0  80   0 - 25232 n_tty_ pts/1    00:00:00 cat

    # cat /proc/9566/oom_score
    1
    # cat /proc/9566/oom_adj
    0 可以用这个值干预上面oom得分
    -17 15     -17免杀，15是先干掉

    # echo 15 > /proc/9566/oom_adj

    # echo f > /proc/sysrq-trigger   //启动OOM_KILLER 必杀一个
    # cat    //因为上面已经把9566的adj改成了15，所以这次启动杀死了cat进程
     已杀死

swap
=======

那么到底怎么解决内存耗尽的问题？swap

假如a，b，c已经把内存占满了，那么来了个d，内核先看看abc谁不忙，就把谁的数据先放到swap里面去，比如a不用，把a的数据放到swap里面去，释放出来的空间给d

swap分区分多大？现在内存很大比如256G，那么就没必要2倍了。。。

- 什么样的数据才能往swap里面放？

.. code-block:: bash

    # cat /proc/meminfo | grep -i active
     Active:           233836 kB
     Inactive:        1280348 kB
     Active(anon):     138780 kB
     Inactive(anon):    26740 kB
     Active(file):      95056 kB
     Inactive(file):  1253608 kB

    active活跃数据，inactive非活跃数据，又分为匿名数据和文件数据
    匿名数据不能往swap里面放
    文件形式的active不能往swap里放，只有文件的inactive才能往swap放
    所以并不是有了swap，内存就解决了

- 什么时候放进去？根据swap_tendency（swap趋势）

swap_tendency = mapped_ratio/2 + distress + vm_swappiness

这就是swap趋势，如果这个值到达100，就往交换分区里面放，如果小于100，尽量不往里面放，但是就算到100，也只能说内核倾向与要往swap里面放，但也不一定放

系统就只开放第三个给用户设置

.. code-block:: bash

    # cat /proc/sys/vm/swappiness  swap的喜好程度，范围0-100
      60


使用内存文件系统
=====================
.. code-block:: bash

    #df -h
    tmpfs                 1.9G  224K  1.9G   1% /dev/shm  （共享内存）
    tmpfs   内存里面的临时文件系统  系统会承诺拿出50%（这里是2G）的空间来做SHM，只是承诺，实际用多少给多少，如果内存比较富裕的情况下，我们可以拿内存当硬盘使用

    #mount  -t tmpfs -o size=1000M tmpfs /mnt   //挂内存
    #dd if=/dev/zero of=/mnt/file1 bs=1M count=800
    记录了800+0 的读入
    记录了800+0 的写出
    838860800字节(839 MB)已复制，0.310507 秒，2.7 GB/秒    //这里用的是内存的速度
    # dd if=/dev/zero of=/tmp/file1 bs=1M count=800 oflag=direct
     记录了800+0 的读入
     记录了800+0 的写出
     838860800字节(839 MB)已复制，8.77251 秒，95.6 MB/秒   //这里用的是硬盘的速度

    如果临时对某一个目录有较高的io需求，可以使用上面的方法使用内存
    ----------------------------------------------------------------------------------------------
    # mount -t tmpfs -o size=20000M tmpfs /mnt    //发现这样也可以，为什么，这只是承诺给20G，并没有实际给20G

    #dd if=/dev/zero of=/mnt/file1   //不指定多大，把swap关闭（如果不关会等半天），这样就会把内存耗尽，


虚拟内存和物理内存
===========================

- 查看：

.. code-block:: bash

        #top
        VIRT RES SHR

- 虚拟内存：

应用程序没办法直接使用物理内存，每个程序都有一个被内核分配给自己的虚拟内存

- 虚拟内存申请：

32位CPU,2^32也就是4G

64位cpu,2^64

每个程序都最多能申请4G的虚拟内存，但是现在这4G内存还和物理内存没关系呢，a说我先用100M，然后内核就会把100M映射给物理内存

VIRT就是程序运行的时候说申请的虚拟内存，RES就是映射的内存

- 为什么要有虚拟内存？

    跟开发有关系，内存是有地址空间的，开发者在调用内存的时候如果直接调用物理内存，开发者不知道哪块儿地址被占用了，所以在中间内核站出来给开发者分配，开发者只需要提出需要多大内存，由内核来解决你的内存就可以了

    程序1 程序2

    4G     4G

    kernel

    物理内存

    以上3层，第一层就是程序可以使用的虚拟内存，程序可以跟内核申请需要多少内存，内核就分配相应大小的物理内存给程序就可以了

========================

- 映射表：

概念：

内存是分页的，1个page是4k(默认值),在硬盘上分块，硬盘数据和内存数据是一一对应

问题：

 条目非常多，查询特别慢

解决：

 固有方法：
  硬件TLB ，在cpu里面，用来解决查询映射表慢的问题，第一次查询过之后把结果缓存到TLB里面，以后再查的时候就可以直接从TLB里面提取
    # yum install x86info
    # x86info  -a  可以查询TLB信息
    自定义方法：

        如果page变大，条目就会变少，这样就会提高查询速度

        大于4k的分页称为hugepage 巨页 ，但是这个需要程序支持

        那我们现在的操作系统是否支持巨页

        .. code-block:: bash

            # cat /proc/meminfo | grep -i hugepage
            AnonHugePages:     26624 kB
            HugePages_Total:       0      我现在没有巨页
            HugePages_Free:        0
            HugePages_Rsvd:        0
            HugePages_Surp:        0
            Hugepagesize:       2048 kB    说明现在我的系统支持2M的巨页

            假如一个程序需要200M的巨页，那么就要把total改成100
            #echo 100 > /proc/sys/vm/nr_hugepages  //修改巨页total数目

            #mkdir dir1
            #mount -t hugetlbfs none /dir1    那么现在程序使用/dir1就可以了

- 外翻：

    TLB(Translation Lookaside Buffer)传输后备缓冲器是一个内存管理单元用于改进虚拟地址到物理地址转换速度的缓存。TLB是一个小的，虚拟寻址的缓存，其中每一行都保存着一个由单个PTE组成的块。如果没有TLB，则每次取数据都需要两次访问内存，即查页表获得物理地址和取数据


进程间通信(IPC)
========================

- 种类：

 进程间通信的方式有5种:

 1.管道(pipe)      本地进程间通信，用来连接不同进程之间的数据流

 2.socket    网络进程间通信，套接字(Socket)是由Berkeley在BSD系统中引入的一种基于连接的IPC，是对网络接口(硬件)和网络协议(软件)的抽象。它既解决了无名管道只能在相关进程间单向通信的问题，又解决了网络上不同主机之间无法通信的问题。

 以上两种unix遗留下来的

 3.消息队列(Message Queues)  消息队列保存在内核中，是一个由消息组成的链表。

 4.共享内存段(Shared Memory)  共享内存允许两个或多个进程共享一定的存储区，因为不需要拷贝数据，所以这是最快的一种IPC。

 5.信号量集(Semaphore Arrays)	    System V的信号量集表示的是一个或多个信号量的集合。

- 查看：

    ipc 进程间通信

    #ipcs   //这条命令可以看到后3种,前两种可以通过文件类型查看

- 含义：

    管道
        a | b

        在内存打开一个缓冲区，a把结果存到缓冲区，b去缓冲区里面拿数据

        管道通信的时候 独木桥：特点-->只能一个人 单向  先进先出

        3个人过桥，一个一个的过，那如果100个人过，速度会很慢，所以管道传输的数据有限

    socket

        IE浏览器  访问网站 通过端口 端口在系统内实际不存在是个伪概念，只是一个标识，
        a会打开一个buffer  b会打开一个buffer  ，这两个buffer用来接受数据包，并且重组，交给apache的socket，apache就会去socket接受数据



    消息队列

        跟管道基本一样  也是独木桥，也是单向，先进先出，但是他会对消息进程排队，谁着急谁先走，那么过河的人多了之后，同样也是数据传输较慢

    共享内存段

        开辟一块内存，a把数据全都丢到共享内存里面，b去共享内存拿数据，而且b可以按需选择拿哪些数据

        共享内存段在oracle里面肯定要使用

    信号量
            在a和b之间传递信号，a把一个文件锁住给b发一个信号，说这个文件我正在使用

            信号所携带的数据量非常有限，只能指定信号是干什么用的



==============================================

查看内存使用情况
[root@alvin ~]# sar -r 1 1
01时31分38秒   kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
01时31分39秒   6045368     1917916        24.08        67236       649020     2435764     17.73

kbcommit：保证当前系统所需要的内存,即为了确保不溢出而需要的内存(RAM+swap).
%commit：这个值是kbcommit与内存总量(包括swap)的一个百分比.
