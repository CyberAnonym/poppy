#!/usr/bin/python
#coding:utf-8
import socket,os,re
def getCommandUniqueLine(command):
    return os.popen(command).read().split('\n')[0]
ipaddstr=os.popen('ip a s|grep global').read().split('\n')[:-1]
osInfo=getCommandUniqueLine('cat /etc/redhat-release')
kernel=getCommandUniqueLine('uname -r')
vCPU=getCommandUniqueLine('cat /proc/cpuinfo |grep process|wc -l')
memTotalstr=getCommandUniqueLine('cat /proc/meminfo |grep -i memtotal')
memAvailable=getCommandUniqueLine('cat /proc/meminfo |grep -i MemAvailable')
user=getCommandUniqueLine('whoami')
homedir=getCommandUniqueLine('echo $HOME')
cpuIdle=getCommandUniqueLine("vmstat 1 2|tail -1|awk '{print $15}'")
userNumber=getCommandUniqueLine("w|head -1")
lastLoginIP=getCommandUniqueLine("last|head -2|tail -1|awk '{print $3}'")
hostname=socket.gethostname()


def value(content):
#    return ('\033[1;4;031m %s\033[0m'%content)  #\033[代表开始定义字体格式，1代表高亮显示，4代表使用下划线 ，031m代表红色字体，\033[0m代表使用终端设置，即取消颜色设置
    return ('\033[1;031m %s\033[0m'%content)  #\033[代表开始定义字体格式，1代表高亮显示，4代表使用下划线 ，031m代表红色字体，\033[0m代表使用终端设置，即取消颜色设置

def title(content):
    return ('\033[033m %s\033[0m'%content)  #定义黄色字体
def sophiroth_print(t,v):
    print('| '+title(t.ljust(20))+value(v.ljust(50))+'|')
def print_nic():
    for i in ipaddstr:
        ip=re.findall(r'inet\s(\w.*)/',i)[0]
        nicName=str('NIC '+i.split(' ')[-1]+':')
        sophiroth_print(nicName,ip)

def print_osInfo():
    sophiroth_print('Release Version:',osInfo)

def print_hostname():
    sophiroth_print('Hostname:',hostname)
def print_LinuxKernel():
    sophiroth_print('Kernel Version:',kernel)
def print_CPUState():
    sophiroth_print('vCPU:',vCPU)
    #sophiroth_print('CPU Idle:',cpuIdle)
def print_memState():
    totalMem=str(int(int(re.findall(r'\d.*\d',memTotalstr)[0])/1024))+' MB'
    availableMem=str(int(int(re.findall(r'\d.*\d',memAvailable)[0])/1024))+' MB'
    availableMemPercent='('+str(float(float('%.4f'%(float(float(re.findall(r'\d.*\d', memAvailable)[0]))/float(float(re.findall(r'\d.*\d', memTotalstr)[0]))))*100))+'%)'
    sophiroth_print("Total Memory:",totalMem)
    sophiroth_print("Availible Memory:",availableMem+' '+availableMemPercent)
def print_userInfo():
    sophiroth_print('User Name:',user)
    sophiroth_print('Home Directory:',homedir)
    sophiroth_print('Login User Number:',re.findall(r'\s(\d\d?\d?)\suser',userNumber)[0])
def print_lastIP():
    sophiroth_print('Last Login IP:',lastLoginIP)
def main():
    print('╭'+'\033[5;1;032mWelcome to Alvin\'s Compute Center\033[0m'.center(87,'-')+'╮')
    print_hostname()
    print_nic()
    print_osInfo()
    print_LinuxKernel()
    print_CPUState()
    print_memState()
    print_userInfo()
    print_lastIP()
    print('╰'+'\033[4;1;035mSophiroth Cluster\033[0m'.center(87,'-')+'╯')

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print('Sophiroth warning: welcome information collection get error. Error message as follows:')
        print(e)
