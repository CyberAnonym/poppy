subprocess
#######################


调用shell命令，并返回状态
================================


::

    subprocess.call('ls aa',shell=True)


调用shell命令，并返回标准输出的内容
==================================

::

    subprocess.check_output('ls aa',shell=True)

