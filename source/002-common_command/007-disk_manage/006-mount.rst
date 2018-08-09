mount
===============

挂载本地磁盘
################
将/dev/sdb1 挂载到/opt

.. code-block:: bash

    # mount /dev/sdb1 /opt


挂载nfs文件系统
##################

将dc.alv.pub:/data 挂载到本地的/data/

.. code-block:: bash

    # mount dc.alv.pub:/data/ /data

挂载cifs文件系统
#######################
samba和windows的文件共享都是cifs文件系统

我们将//samba.alv.pub/share 挂载到本地的/share, 用户名是alvin，密码是mypassword

.. code-block:: bash

    #mount -t cifs -o user=alvin,password=mypassword //samba.alv.pub/share /share

