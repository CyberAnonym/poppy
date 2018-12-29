strace
###########


简介
========

strace常用来跟踪进程执行时的系统调用和所接收的信号。 在Linux世界，进程不能直接访问硬件设备，当进程需要访问硬件设备(比如读取磁盘文件，接收网络数据等等)时，必须由用户态模式切换至内核态模式，通 过系统调用访问硬件设备。strace可以跟踪到一个进程产生的系统调用,包括参数，返回值，执行消耗的时间。

安装strace
================

::

    yum install strace -y


输出参数含义
===============

::

    root@ubuntu:/usr# strace cat /dev/null
    execve("/bin/cat", ["cat", "/dev/null"], [/* 22 vars */]) = 0
    brk(0)                                  = 0xab1000
    access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
    mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f29379a7000
    access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
    ...
    brk(0) = 0xab1000
    brk(0xad2000) = 0xad2000
    fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
    open("/dev/null", O_RDONLY) = 3
    fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
    read(3, "", 32768) = 0
    close(3) = 0
    close(1) = 0
    close(2) = 0
    exit_group(0) = ?

每一行都是一条系统调用，等号左边是系统调用的函数名及其参数，右边是该调用的返回值。
strace 显示这些调用的参数并返回符号形式的值。strace 从内核接收信息，而且不需要以任何特殊的方式来构建内核。


strace参数


::

    c 统计每一系统调用的所执行的时间,次数和出错的次数等.
    -d 输出strace关于标准错误的调试信息.
    -f 跟踪由fork调用所产生的子进程.
    -ff 如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号.
    -F 尝试跟踪vfork调用.在-f时,vfork不被跟踪.
    -h 输出简要的帮助信息.
    -i 输出系统调用的入口指针.
    -q 禁止输出关于脱离的消息.
    -r 打印出相对时间关于,,每一个系统调用.
    -t 在输出中的每一行前加上时间信息.
    -tt 在输出中的每一行前加上时间信息,微秒级.
    -ttt 微秒级输出,以秒了表示时间.
    -T 显示每一调用所耗的时间.
    -v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出.
    -V 输出strace的版本信息.
    -x 以十六进制形式输出非标准字符串
    -xx 所有字符串以十六进制形式输出.
    -a column
    设置返回值的输出位置.默认 为40.
    -e expr
    指定一个表达式,用来控制如何跟踪.格式如下:
    [qualifier=][!]value1[,value2]...
    qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.感叹号是否定符号.例如:
    -eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open表示跟踪除了open以外的其他调用.有两个特殊的符号 all 和 none.
    注意有些shell使用!来执行历史记录里的命令,所以要使用\\.
    -e trace=set
    只跟踪指定的系统 调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all.
    -e trace=file
    只跟踪有关文件操作的系统调用.
    -e trace=process
    只跟踪有关进程控制的系统调用.
    -e trace=network
    跟踪与网络有关的所有系统调用.
    -e strace=signal
    跟踪所有与系统信号有关的 系统调用
    -e trace=ipc
    跟踪所有与进程通讯有关的系统调用
    -e abbrev=set
    设定 strace输出的系统调用的结果集.-v 等与 abbrev=none.默认为abbrev=all.
    -e raw=set
    将指 定的系统调用的参数以十六进制显示.
    -e signal=set
    指定跟踪的系统信号.默认为all.如 signal=!SIGIO(或者signal=!io),表示不跟踪SIGIO信号.
    -e read=set
    输出从指定文件中读出 的数据.例如:
    -e read=3,5
    -e write=set
    输出写入到指定文件中的数据.
    -o filename
    将strace的输出写入文件filename
    -p pid
    跟踪指定的进程pid.
    -s strsize
    指定输出的字符串的最大长度.默认为32.文件名一直全部输出.
    -u username
    以username 的UID和GID执行被跟踪的命令


命令实例
============


从启动开始监控我的一个python程序

::

    strace -tt -f  /usr/bin/python2 manage.py runserver 0.0.0.0:8001


通用的完整用法：

::

    strace -o output.txt -T -tt -e trace=all -p 28979

上面的含义是 跟踪28979进程的所有系统调用（-e trace=all），并统计系统调用的花费时间，以及开始时间（并以可视化的时分秒格式显示），最后将记录结果存在output.txt文件里面。

strace案例
=============

用strace调试程序
-----------------------

在理想世界里，每当一个程序不能正常执行一个功能时，它就会给出一个有用的错误提示，告诉你在足够的改正错误的线索。但遗憾的是，我们不是生活在理想世界 里，起码不总是生活在理想世界里。有时候一个程序出现了问题，你无法找到原因。
这就是调试程序出现的原因。strace是一个必不可少的 调试工具，strace用来监视系统调用。你不仅可以调试一个新开始的程序，也可以调试一个已经在运行的程序（把strace绑定到一个已有的PID上 面）。
首先让我们看一个真实的例子：启动KDE时出现问题
前一段时间，我在 启动KDE的时候出了问题，KDE的错误信息无法给我任何有帮助的线索。

::

    _KDE_IceTransSocketCreateListener: failed to bind listener
    _KDE_IceTransSocketUNIXCreateListener: ...SocketCreateListener() failed
    _KDE_IceTransMakeAllCOTSServerListeners: failed to create listener for local

    Cannot establish any listening sockets DCOPServer self-test failed.

对 我来说这个错误信息没有太多意义，只是一个对KDE来说至关重要的负责进程间通信的程序无法启动。我还可以知道这个错误和ICE协议（Inter Client Exchange）有关，除此之外，我不知道什么是KDE启动出错的原因。

我决定采用strace看一下在启动 dcopserver时到底程序做了什么：

::

    strace -f -F -o ~/dcop-strace.txt dcopserver

这里 -f -F选项告诉strace同时跟踪fork和vfork出来的进程，-o选项把所有strace输出写到~/dcop-strace.txt里 面，dcopserver是要启动和调试的程序。

再次出现错误之后，我检查了错误输出文件dcop-strace.txt，文件里有很多 系统调用的记录。在程序运行出错前的有关记录如下：



::

    27207 mkdir("/tmp/.ICE-unix", 0777) = -1 EEXIST (File exists)
    27207 lstat64("/tmp/.ICE-unix", {st_mode=S_IFDIR|S_ISVTX|0755, st_size=4096, ...}) = 0
    27207 unlink("/tmp/.ICE-unix/dcop27207-1066844596") = -1 ENOENT (No such file or directory)
    27207 bind(3, {sin_family=AF_UNIX, path="/tmp/.ICE-unix/dcop27207-1066844596"}, 38) = -1 EACCES (Permission denied)
    27207 write(2, "_KDE_IceTrans", 13) = 13
    27207 write(2, "SocketCreateListener: failed to "..., 46) = 46
    27207 close(3) = 0 27207 write(2, "_KDE_IceTrans", 13) = 13
    27207 write(2, "SocketUNIXCreateListener: ...Soc"..., 59) = 59
    27207 umask(0) = 0 27207 write(2, "_KDE_IceTrans", 13) = 13
    27207 write(2, "MakeAllCOTSServerListeners: fail"..., 64) = 64
    27207 write(2, "Cannot establish any listening s"..., 39) = 39



其中第一行显示程序试图创建/tmp/.ICE-unix目录，权限为0777，这个操作因为目录已经存在而失败了。第二个系统调用（lstat64）检查 了目录状态，并显示这个目录的权限是0755，这里出现了第一个程序运行错误的线索：程序试图创建属性为0777的目录，但是已经存在了一个属性为 0755的目录。第三个系统调用（unlink）试图删除一个文件，但是这个文件并不存在。这并不奇怪，因为这个操作只是试图删掉可能存在的老文件。

但是，第四行确认了错误所在。他试图绑定到/tmp/.ICE-unix/dcop27207-1066844596，但是出现了拒绝访问错误。. ICE_unix目录的用户和组都是root，并且只有所有者具有写权限。一个非root用户无法在这个目录下面建立文件，如果把目录属性改成0777， 则前面的操作有可能可以执行，而这正是第一步错误出现时进行过的操作。

所以我运行了chmod 0777 /tmp/.ICE-unix之后KDE就可以正常启动了，问题解决了，用strace进行跟踪调试只需要花很短的几分钟时间跟踪程序运行，然后检查并分 析输出文件。

说明：运行chmod 0777只是一个测试，一般不要把一个目录设置成所有用户可读写，同时不设置粘滞位(sticky bit)。给目录设置粘滞位可以阻止一个用户随意删除可写目录下面其他人的文件。一般你会发现/tmp目录因为这个原因设置了粘滞位。KDE可以正常启动 之后，运行chmod +t /tmp/.ICE-unix给.ICE_unix设置粘滞位。

