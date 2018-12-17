alv.pub环境介绍
#########################

自动化配置系统信息
========================



每台服务器创建完成之后执行一下下面这个脚本，并可根据网卡mac地址来设置网络信息和主机名。

脚本网络地址： https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/set_hostinfo_by_nic.py

执行方式：

::

    curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/set_hostinfo_by_nic.py|python

脚本内容：

.. literalinclude:: ../../code/alv.pub/set_hostinfo_by_nic.py
      :language: python
      :linenos:

