#!/usr/bin/python
#coding:utf-8
import os,re
detect_abnormal='netstat -anplut|grep -ivE "connections|Address|1005|alvin|801|mysqld|sshd|1281|docker-proxy|32000|AliYunDUn|pptp|ntpd|slapd|named|100.100|wachat|140.207"'
disbale_ip_output_command='iptables -A OUTPUT -p tcp  -d  %s -j REJECT'

new_conn=os.popen('%s'%detect_abnormal).read().split('\n')[:-1]

for i in new_conn:
    v=re.findall(r'\s(\d+.\d+.\d+.\d+):',i)[-1]
    os.system(disbale_ip_output_command%v)
a="tcp        0      0 127.0.0.1:10051         127.2.0.1:39908         TIME_WAIT   - "
print(re.findall(r'\s(\d+.\d+.\d+.\d+):',a)[-1])

#a='123 192.168:ddss 33 adc'
#print(re.findall(r'\w+\.\w+:\w+',a))