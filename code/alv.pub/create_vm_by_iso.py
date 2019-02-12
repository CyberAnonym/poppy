#!/usr/bin/python
#coding:utf-8
import sys,subprocess,random,string,time


#定义新虚拟机的各种值


name='ubuntu18u4'
nic=93
isofile='/nextcloud/data/alvin/files/isos/ubuntu/ubuntu-18.04.1-desktop-amd64.iso'

try:
    hostinfo={}
    hostinfo['name']=name+'.alv.pub'
    #hostinfo['name']=sys.argv[1]+'.alv.pub'
    hostinfo['nic']='00:00:00:00:00:'+str(nic)
    #hostinfo['nic']='00:00:00:00:00:'+str(sys.argv[2])
    hostinfo['vncport']='59'+str(nic)
    #hostinfo['vncport']='59'+str(sys.argv[2])
    hostinfo['disk']=name+'.alv.pub'+'.raw'
    #hostinfo['disk']=sys.argv[1]+'.alv.pub'+'.raw'
    hostinfo['ram']=4096
    hostinfo['vcpus']=4
    hostinfo['disksize']='40G'
    hostinfo['isofile']=isofile
    hostinfo['vncpassword']=''.join(random.sample(string.ascii_letters + string.digits, 12))
except Exception as e:
    print(e)



def create_vm():
    # 将元磁盘拷贝为新虚拟机要用的磁盘
    subprocess.call('qemu-img create -f raw /kvm/{disk} {disksize}'.format(**hostinfo), shell=True)
    subprocess.call('virt-install --virt-type kvm \
--name {name} \
--os-variant rhel7 \
--ram {ram} \
--cdrom={isofile} \
-m {nic} \
--autostart \
--vcpus {vcpus}  \
--disk=/kvm/{disk} \
--graphics vnc,listen=0.0.0.0,port={vncport},keymap=en-us,password={vncpassword} \
--network bridge=br0 \
--noautoconsole'.format(**hostinfo),shell=True)

if __name__ == '__main__':
    create_vm()
    print('Your vnc port is {vncport}, your vnc password is {vncpassword}'.format(**hostinfo))