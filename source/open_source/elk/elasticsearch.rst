elasticsearch
##################

这里我们将elasticsearch服务搭建在了elk.alv.pub这台服务器上。




查看es的各个index状态
````````````````````````

.. code-block:: bash

    curl -X GET http://elk.alv.pub:9200/_cat/indices?v=|less


删除指定索引
````````````````

.. code-block:: bash

    curl -XDELETE  'http://elk.alv.pub:9200/logstash-2018.06.25'
    curl -XDELETE  "http://elk.alv.pub:9200/*2017.03*
