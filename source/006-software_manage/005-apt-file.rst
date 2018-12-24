apt-file
##############

在centos下我们想要知道某命令只由哪个包安装的，比如ifconfig是由哪个包提供的，要执行 yun provides ifconfig，那么在ubuntu下呢？  我们就需要使用apt-file



查看ifconfig是由哪个包安装的
======================================

::

    apt-file search bin/ifconfig


apt-file search -x(--regexp) 后可接正则表达式，如：

::

    $ apt-file search -x 'bin/rz$'
    lrzsz: /usr/bin/rz