owncloud
####################

.. contents::


Official Documents
`````````````````````````
Install client url： https://owncloud.org/download/#install-clients

Installation Environment
```````````````````````````````

system release version: centos7.5

Install owncloud
``````````````````````

.. code-block:: bash

    yum install httpd owncloud owncloud-httpd -y

Configure owncloud
`````````````````````

.. code-block:: bash

    grep "Require all granted" /etc/httpd/conf.d/owncloud.conf || sed  -i /"Directory \/usr\/share\/owncloud"/a\ "\    Require all granted" /etc/httpd/conf.d/owncloud.conf


Start service
````````````````

.. code-block:: bash

    systemctl enable httpd
    systemctl start httpd

visit service
``````````````````


http://url/owncloud

data directory
```````````````````

/var/lib/owncloud/data/

