#!/bin/bash

#Set Zabbis Server IP
ZSIP=192.168.105.8   #This is Zabbix server IP, Please change 192.168.105.8 to your zabbix server IP

##Confirm Zabbix main directory exist
[ -d /usr/local/zabbix ]
if [ $? -eq 0 ];then
	echo "/usr/local/zabbix has already exist, Script  exit installation now."
	exit 1
	elif [ $? -eq 1 ];then
	echo	"Zabbix Agent installtion script start running..."
		sleep 1
	else
	echo "Something has wrong. Please check your setting"
	exit 2
fi



#Start Install Zabbis agent
id zabbix >> /dev/null || useradd -M zabbix
./configure --prefix=/usr/local/zabbix --enable-agent 

if [ $? -eq 0 ]
	then
	make && make install
	if 
		[ $? -eq 0 ];then
		cp misc/init.d/fedora/core/zabbix_agentd /etc/init.d/ && cp /usr/local/zabbix/sbin/zabbix_agentd /usr/local/sbin/
			if [ $? -eq 0 ];then
				sed -i "s/^Server=.*/Server=$ZSIP/"  /usr/local/zabbix/etc/zabbix_agentd.conf && sed -i "s/^Hostname=.*/Hostname=$(hostname)/"  /usr/local/zabbix/etc/zabbix_agentd.conf
				if [ $? -eq 0 ];then
					/etc/init.d/zabbix_agentd start && chkconfig zabbix_agentd on
					else
					echo "Change /usr/local/zabbix/etc/zabbix_agentd.conf processing has error,Please Check your setting"
					exit 2
				fi
				else 
				echo "cp zabbix_agentd somt file to /usr/local/sbin/ and /etc/init.d/ processing has error ,Please check the setting"
				exit 2
			fi
		else
		echo "make processing has error,Please check your setting"
		exit 2
	fi
	else
	echo "Zabbix agent configure succeed was not succeed, Please check your setting.Maybe someone package need installed befor you execute this script"
	exit 2
fi
