#!/usr/bin/python
import os

zabbixServerName='zabbix.alv.pub'
os.system('curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/tech-center/master/software/yum.repos.d/zabbix3.4.repo > /etc/yum.repos.d/zabbix3.4.repo')
os.system('yum install zabbix-agent -y')
os.system('sed -i "s/^Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf')
os.system('sed -i "s/^Server=.*/Server=%s/" /etc/zabbix/zabbix_agentd.conf'%zabbixServerName)
os.system('sed -i "s/^ServerActive=.*/ServerActive=%s/" /etc/zabbix/zabbix_agentd.conf'%zabbixServerName)
os.system('systemctl start zabbix-agent')
os.system('systemctl enable zabbix-agent')