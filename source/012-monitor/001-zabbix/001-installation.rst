安装
#####

官网地址： https://www.zabbix.com/download


Install and configure Zabbix server
==========================================

a. Install Repository with MySQL database

    .. code-block:: bash

        # rpm -i https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

#. Install Zabbix server, frontend, agent


    .. code-block:: bash

        # yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent

#. Create initial database

    .. code-block:: bash

        # mysql -uroot -p
        password
        mysql> create database zabbix character set utf8 collate utf8_bin;
        mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
        mysql> quit;

    Import initial schema and data. You will be prompted to enter your newly created password.

    .. code-block:: bash

        # zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix

#. Configure the database for Zabbix server

    Edit file /etc/zabbix/zabbix_server.conf

    .. code-block:: bash

        DBPassword=password
#. Configure PHP for Zabbix frontend

    Edit file /etc/httpd/conf.d/zabbix.conf, uncomment and set the right timezone for you.

    .. code-block:: bash

        # php_value date.timezone Asia/Shanghai

#. Start Zabbix server and agent processes

    Start Zabbix server and agent processes and make it start at system boot:

    .. code-block:: bash

        # systemctl restart zabbix-server zabbix-agent httpd
        # systemctl enable zabbix-server zabbix-agent httpd

Now your Zabbix server is up and running!

Configure Zabbix frontend
==============================

Connect to your newly installed Zabbix frontend: http://server_ip_or_name/zabbix
Follow steps described in Zabbix documentation: Installing frontend



