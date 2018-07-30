wget
####

 wget是一个下载文件的工具，它用在命令行下。对于Linux用户是必不可少的工具，尤其对于网络管理员，经常要下载一些软件或从远程服务器恢复备份到本地服务器。如果我们使用虚拟主机，处理这样的事务我们只能先从远程服务器下载到我们电脑磁盘，然后再用ftp工具上传到服务器。这样既浪费时间又浪费精力，那不没办法的事。而到了Linux VPS，它则可以直接下载到服务器而不用经过上传这一步。wget工具体积小但功能完善，它支持断点下载功能，同时支持FTP和HTTP下载方式，支持代理服务器和设置起来方便简单。下面我们以实例的形式说明怎么使用wget。



使用wget下载单个文件
=====================

以下的例子是从网络下载一个文件并保存在当前目录

.. code-block:: bash

    wget http://cn.wordpress.org/wordpress-3.1-zh_CN.zip


wget下载文件到指定路径后重命名
===========================================

.. code-block:: bash

    wget -O /opt/wordpress.zip http://cn.wordpress.org/wordpress-3.1-zh_CN.zip

wget下载文件到指定目录
=========================

.. code-block:: bash

    wget -P /opt/ http://cn.wordpress.org/wordpress-3.1-zh_CN.zip