#coding:utf-8
import subprocess

hostname_domain='.alv.pub'

hostname={}
hostname['2']='ipa' #ipa 服务。包括ldap，dns服务。
hostname['3']='internal' #物理机 所有虚拟机都是安装在这里
hostname['4']='zabbix' #zabbix监控
hostname['9']='meta'  #其他虚拟机要创建的得时候，拷贝meta的盘。然后修改系统配置导入为新的虚拟机
hostname['10']='mysql' #mysql前端
hostname['11']='mysql1'
hostname['12']='mysql2'
hostname['13']='mysql3'
hostname['20']='redis' #redis前端
hostname['21']='redis1'
hostname['22']='redis2'
hostname['23']='redis3'
hostname['30']='mongodb' #mongodb 前端
hostname['31']='mongodb1'
hostname['32']='mongodb2'
hostname['33']='mongodb3'



#获取mac地址
get_nic=subprocess.check_output("ip a s|grep ether|awk '{print $2}'",shell=True).split('\n')[0]
#获取mac地址最后一位
tail_1=get_nic.split(':')[-1]
#如果最后一段数的开头是0，去掉0
if tail_1[0] == '0':tail_1=tail_1[1]
#获取mac地址倒数第二位
tail_2=get_nic.split(':')[-2]
if tail_2 == '01':tail_1='1'+tail_1


#设置ip等网络信息
sysinfo={}
sysinfo['ip']='192.168.3.%s'%tail_1
sysinfo['gw']='192.168.3.1'
sysinfo['dns']='192.168.3.1'
sysinfo['dns_search']='alv.pub'
#sysinfo['nic']=subprocess.check_output("ip a s|grep state|grep -v lo|awk -F: '{print $2}'|sed 's/ //'",shell=True).split('\n')[0]
sysinfo['nic']=subprocess.check_output("nmcli device show |grep -i CONNECTION|head -1|sed -r 's/(GENERAL.CONNECTION:[ ]+)([a-Z].*)/\2/'",shell=True).split('\n')[0]
sysinfo['hostname']=hostname[tail_1]+hostname_domain


#设置ip地址

def set_ip_info():
        if subprocess.call('nmcli connection modify {nic} ipv4.method manual ipv4.addresses {ip} ipv4.gateway {gw} ipv4.dns {dns} ipv4.dns-search {dns_search} autoconnect yes && nmcli con up {nic}'.format(**sysinfo),shell=True) == 0:
            print('IP address has heen setup ok')
        else:
            print('IP address setup failed.')


def set_hostnaem():
    if subprocess.call('hostnamectl set-hostname %s'%sysinfo['hostname'],shell=True) == 0:
        print('Hostname setup ok')
    else:
        print('Hostname setup failed.')



def main():
    set_ip_info()
    set_hostnaem()

if __name__ == '__main__':
    main()