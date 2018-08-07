Install
###############


安装mariadb
======================
.. code-block:: bash

    yum install mariadb-server mariadb


setsebool -P nis_enabled 1
ausearch -c 'my-rsyn' --raw | audit2allow -M my-rsyn
semodule -i my-rsync.pp

ausearch -c 'my-httpd' --raw | audit2allow -M my-httpd
semodule -i my-httpd.pp

ausearch -c 'wsrep_sst_rsync' --raw | audit2allow -M my-wsrepsstrsync
semodule -i my-wsrepsstrsync.pp

ausearch -c 'which' --raw | audit2allow -M my-which
semodule -i my-which.pp

ausearch -c 'mysqladmin' --raw | audit2allow -M my-mysqladmin
semodule -i my-mysqladmin.pp

ausearch -c 'mysqld' --raw | audit2allow -M my-mysqld
semodule -i my-mysqld.pp

ausearch -c 'audispd' --raw | audit2allow -M my-audispd
semodule -i my-audispd.pp

ausearch -c 'mysql' --raw | audit2allow -M my-mysql
semodule -i my-mysql.pp
