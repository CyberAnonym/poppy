swapon
#########


开启一个磁盘的swap
========================
这里我们有一块磁盘/dev/sdb2已经通过mkswap /dev/sdb2做成了swap格式的了，我们开启它。

.. code-block:: bash

    # swapon /dev/sdb2
    # free -m ##确认一下
