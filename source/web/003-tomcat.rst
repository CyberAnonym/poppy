tomcat
==========

JAVA环境变量
====================
二进制安装的JAVA设置环境变量
这里我们是把java安装在了/opt/jdk1.7.0_51目录下。

.. code-block:: bash

    vim /etc/profile
    export JAVA_HOME=/opt/jdk1.7.0_51
    export PATH=$JAVA_HOME/bin:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$PATH
