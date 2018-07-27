#!/bin/bash

#This function is use for install apache 2.4.6
function APACHE() {
yum install gcc-c++ -y
tar xf apr-1.5.2.tar.gz
cd apr-1.5.2
sudo mkdir /usr/local/apr
sudo ./configure --prefix=/usr/local/apr
sudo make
sudo make install
sudo mkdir /usr/local/apr-util
cd ..
tar xf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
sudo ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config
sudo make
sudo make install
cd ..
tar xf pcre-8.37.tar.gz
cd pcre-8.37
sudo mkdir /usr/local/pcre
sudo ./configure --prefix=/usr/local/pcre --with-apr=/usr/local/apr/bin/apr-1-config
sudo make
sudo make install
cd ..
tar xf httpd-2.4.6.tar.gz
cd httpd-2.4.6
#sudo yum install pcre pcre-devel -y
sudo ./configure --prefix=/usr/local/apache --with-pcre=/usr/local/pcre --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util
sudo make
sudo make install


}
function MYSQL() {
tar xf boost_1_59_0.tar.gz
sudo mv boost_1_59_0 /usr/local/boost
tar xf mysql-5.7.11.tar.gz
cd mysql-5.7.11


sudo yum install gcc gcc-c++ gcc-g77 autoconf automake zlib* fiex* libxml* ncurses-devel libmcrypt* libtool-ltdl-devel* make cmake -y


cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_BOOST=/usr/local/boost


sudo make 
sudo make install
sudo mkdir -p /usr/local/mysql/data
sudo chown -R mysql:mysql /usr/local/mysql/
cat >/etc/my.cnf<<EOF
[mysqlda]
datadir=/usr/local/mysql/data
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF
sudo /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --datadir=/usr/local/mysql/data/ --basedir=/usr/local/mysql/ --explicit_defaults_for_timestamp
sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sudo /etc/init.d/mysqld start
echo “export PATH=/usr/local/mysql/bin:$PATH” >> /etc/profile

sudo /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --datadir=/usr/local/mysql/data/ --basedir=/usr/local/mysql/ --explicit_defaults_for_timestamp
sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sudo /etc/init.d/mysqld start
echo "export PATH=/usr/local/mysql/bin:$PATH" >> /etc/profile
source /etc/profile


}
MYSQL
