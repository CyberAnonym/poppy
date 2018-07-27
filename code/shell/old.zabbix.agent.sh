#!/bin/bash

IP=$(ifconfig|head -2|tail -1|awk  '{print $2}'|cut -d ":" -f2)

mkdir -p /documents
yum install cifs-utils -y
mount.cifs //192.168.105.38/Documents /documents/ -o user=alvin.Wan.cn@hotmail.com,password=Wankaihao
cd /documents/Linux/Service\ Installation/zabbix/zabbix-agent/
yum install zabbix-* -y

sed -i "s/Server=.*/Server=zabbix.alv.pub/" /etc/zabbix/zabbix_agentd.conf

sed -i "s/ServerActive=.*/ServerActive=zabbix.alv.pub/" /etc/zabbix/zabbix_agentd.conf

sed -i "s/Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/# UnsafeUserParameter.*/UnsafeUserParameters=1/" /etc/zabbix/zabbix_agentd.conf

/etc/init.d/zabbix-agent restart
yum install lm_sensors net-snmp net-snmp-utils -y

sed -i 's/access.*/access  notConfigGroup \"\"      any       noauth    exact  all none none/' /etc/snmp/snmpd.conf

sed -i 's/#view all/view all/' /etc/snmp/snmpd.conf

/etc/init.d/snmpd restart
