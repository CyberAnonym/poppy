#!/bin/bash
/usr/bin/yum install make gcc openssl xinetd wget openssl-devel -y
/usr/sbin/useradd nagios
wget http://192.168.105.4/nagios/nagios-plugins-2.1.1.tar.gz
/bin/tar xf nagios-plugins-2.1.1.tar.gz -C /usr/local/src
cd /usr/local/src/nagios-plugins-2.1.1/
./configure && make && make install
chown nagios.nagios /usr/local/nagios/
chown -R nagios.nagios /usr/local/nagios/libexec/
wget http://192.168.105.4/nagios/nrpe-2.12.tar.gz
tar xf nrpe-2.12.tar.gz -C /usr/local/src/
cd /usr/local/src/nrpe-2.12/ && ./configure && make all && make install-plugin && make install-daemon && make install-daemon-config && make install-xinetd
echo "nrpe 5666/tcp " >> /etc/services
/etc/init.d/xinetd start
chkconfig xinetd on
chkconfig nrpe on
sed -i 's/127.0.0.1/127.0.0.1 192.168.105.2/' /etc/xinetd.d/nrpe
wget http://192.168.105.4/nagios/plugins/check_iostat_rhel6
wget http://192.168.105.4/nagios/plugins/check_physical_mem
mv check_iostat_rhel6 /usr/local/nagios/libexec/
mv check_physical_mem /usr/local/nagios/libexec/
chmod 755 /usr/local/nagios/libexec/check_physical_mem
chmod 755 /usr/local/nagios/libexec/check_iostat_rhel6
echo "command[check_root]=/usr/local/nagios/libexec/check_disk -w 40% -c 50% -p /" >> /usr/local/nagios/etc/nrpe.cfg
sed -i '$a\command[check_physical_mem]=/usr/local/nagios/libexec/check_physical_mem -w 23 -c 30'  /usr/local/nagios/etc/nrpe.cfg
sed -i '$a\command[check_io_sda]=/usr/local/nagios/libexec/check_iostat_rhel6 -d sda -w 50000,50000,50000,50000, -c 60000,60000,60000,60000'  /usr/local/nagios/etc/nrpe.cfg
chkconfig nrpe on
service xinetd restart
echo ok
