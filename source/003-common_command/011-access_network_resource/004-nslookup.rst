nslookup
############
dns解析命令。




查看alv.pub的A记录解析
#################################

.. code-block:: bash

    [alvin@poppy ~]$ nslookup alv.pub
    Server:		192.168.127.3
    Address:	192.168.127.3#53

    Name:	alv.pub
    Address: 47.75.70.80


查看alv.pub的TXT记录解析
=============================


.. code-block:: bash

    [alvin@diana ~]$ nslookup -q=txt alv.pub
    Server:		100.100.2.138
    Address:	100.100.2.138#53

    Non-authoritative answer:
    alv.pub	text = "201802280000004w87wry7rvoyzajtz6t9db636pmrmnerhelfaiy0ibuteba2yk"

    Authoritative answers can be found from:


查看poppy.alv.pub的cname解析
===================================

.. code-block:: bash

    [alvin@diana ~]$ nslookup -q=cname poppy.alv.pub
    Server:		100.100.2.138
    Address:	100.100.2.138#53

    Non-authoritative answer:
    poppy.alv.pub	canonical name = poppywan.readthedocs.io.

    Authoritative answers can be found from:

    [alvin@diana ~]$
