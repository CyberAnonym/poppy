#coding:utf-8
import sys,subprocess


#定义新虚拟机的各种值



hostinfo={}
hostinfo['name']=sys.argv[1]+'.alv.pub'
hostinfo['nic']='00:00:00:00:00:'+sys.argv[2]
hostinfo['vncport']=59+sys.argv[2]
hostinfo['disk']=sys.argv[1]+'.alv.pub'+'.raw'
hostinfo['ram']=4096
hostinfo['vpuss']=4







# 创建虚拟机

def create_vm():
    # 将元磁盘拷贝为新虚拟机要用的磁盘
    subprocess.call('cp /kvm/meta.alv.pub.raw  /kvm/{disk}'.format(**hostinfo), shell=True)
    subprocess.call('virt-install --virt-type kvm \
--name {name} \
--os-variant rhel7 \
--ram {ram} \
-m {nic} \
--vcpus {vcpus}  \
--disk=/kvm/{disk} \
--graphics vnc,listen=0.0.0.0,port={vncport},keymap=en-us \
--import \
--noautoconsole'.format(**hostinfo),shell=True)


if __name__ == '__main__':
    create_vm()
#--network bridge=br0 \