journalctl
##############


参数解释
================

- -f 试试打印

- u 指定服务名 （example: -u pptpd)


Example
==============

- 实时打印pptp服务的日志

.. code-block:: bash

    journalctl -f -u pptpd

