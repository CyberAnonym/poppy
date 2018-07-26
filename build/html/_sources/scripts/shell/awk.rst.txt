
awk
########


.. contents::

删除文件 text中第一列
```````````````````````

.. code-block:: bash

    awk '{$1="";print $0}' text


打印text中的第二列

.. code-block:: bash

    awk '{print $2}' text