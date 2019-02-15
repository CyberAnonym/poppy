#!/usr/bin/python
#coding:utf-8
import sys,subprocess,random,string,time


#定义新虚拟机的各种值

try:
    hostinfo={}
    hostinfo['name']=sys.argv[1]+'.alv.pub'
    hostinfo['nic']='00:00:00:00:00:'+str(sys.argv[2])
    hostinfo['vncport']='59'+str(sys.argv[2])
    hostinfo['disk']=sys.argv[1]+'.alv.pub'+'.raw'
    hostinfo['ram']=4096
    hostinfo['vcpus']=4
    hostinfo['vncpassword']=''.join(random.sample(string.ascii_letters + string.digits, 12))
except Exception as e:
    print(e)



def clean_data():
    if subprocess.call('virsh list --all|grep {name} &>/dev/null'.format(**hostinfo),shell=True) == 0:
        try:
            subprocess.call('virsh shutdown {name}'.format(**hostinfo),shell=True)
            time.sleep(6)
        except:
            print('already shutdown {name}'.format(**hostinfo))
        try:
            subprocess.call('virsh undefine {name}'.format(**hostinfo),shell=True)
            time.sleep(6)
        except:
            print('already undefine {name}'.format(**hostinfo))
        try:
            subprocess.call('rm -f /kvm/{disk}'.format(**hostinfo),shell=True)
        except:
            print('this is a new virtual machine')
    else:
        pass


# 创建虚拟机

def create_vm():
    # 将元磁盘拷贝为新虚拟机要用的磁盘
    subprocess.call('cp /kvm/meta.alv.pub.raw  /kvm/{disk}'.format(**hostinfo), shell=True)
    subprocess.call('virt-install --virt-type kvm \
--name {name} \
--os-variant rhel7 \
--ram {ram} \
-m {nic} \
--autostart \
--vcpus {vcpus}  \
--disk=/kvm/{disk} \
--graphics vnc,listen=0.0.0.0,port={vncport},keymap=en-us,password={vncpassword} \
--import \
--network bridge=br0 \
--noautoconsole'.format(**hostinfo),shell=True)


if __name__ == '__main__':
    clean_data()
    create_vm()
    print('Your vnc port is {vncport}, your vnc password is {vncpassword}'.format(**hostinfo))