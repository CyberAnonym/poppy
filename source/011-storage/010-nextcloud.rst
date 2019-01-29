nextcloud
###########

使用docker搭建nextcloud
===============================

相关文档：  https://hub.docker.com/r/library/nextcloud/


.. code-block:: bash

    $ sudo docker run -d -v /nextcloud:/var/www/html -p 801:80 --restart=always -v /etc/localtime:/etc/localtime --name nextcloud  nextcloud





使用nextcloud
====================

url: http://$hostname:801


服务器本地传文件到数据目录后
====================================



有时候，直接通过Web页面上传文件并不那么方便，于是有的朋友就直接把文件上传到服务器里，然后拷贝到data目录下，打开ownCloud，却还是之前的文件。

这是因为虽然上传了文件，但是ownCloud/Nextcloud的数据库里并没有这个文件的信息。文件信息都被存储在数据库的oc_filecache表中。

使用OCC命令更新文件索引
-------------------------------

occ有三个用于管理Nextcloud中文件的命令：

files files:cleanup #清楚文件缓存 files:scan #重新扫描文件系统 files:transfer-ownership #将所有文件和文件夹都移动到另一个文件夹
我们需要使用

files:scan

这里我们先进入到docker容器里去

.. code-block:: bash

    docker exec -it nextcloud bash


然后让www-data用户变的可用,该操作是在容器里做的

.. code-block:: bash

    sed -i '/www-data/s/\/usr\/sbin\/nologin/\/bin\/bash/' /etc/passwd


然后 su 到www-data用户， 这里注意我们需要在/var/www/html/ 这个目录下，因为occ是在这个目录下。

.. code-block:: bash

    su www-data

然后执行扫描命令。

.. code-block:: bash

    php occ files:scan --all
