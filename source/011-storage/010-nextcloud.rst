nextcloud
###########

使用docker搭建nextcloud
===============================

相关文档：  https://hub.docker.com/r/library/nextcloud/


.. code-block:: bash

    $ sudo docker run -d -v nextcloud:/var/www/html -p 801:80  nextcloud




使用nextcloud
====================

url: http://$hostname:801