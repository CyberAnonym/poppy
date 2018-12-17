#!/bin/bash



#定义新虚拟机的各种值

read -p 'Please enter virtual machine name: ()' name
#name=ipa.alv.pub
read -p 'Please enter you nic last number (00:00:00:00:00:??):' tmp_nic
#nic=00:00:00:00:00:02
nic=00:00:00:00:00:$tmp_nic
read -p "Please enter vnc port, default is 59$tmp_nic:" vncport
[ ! -n "$vncport" ] && vncport=59$tmp_nic
disk=${name}.raw
read -p 'Please enter ram size (unit is MB):default is 4096' ram
[ ! -n "$ram" ] && ram=4096
read -p 'Please enter your vcpu number:(default is 4)' vcpu
[ ! -n "$vcpu" ] && vcpu=4

#可元磁盘拷贝为新虚拟机要用的磁盘

cp /kvm/meta.alv.pub.raw  /kvm/$disk -p


# 创建虚拟机

virt-install --virt-type kvm \
--name $name \
--os-variant rhel7 \
--ram $ram \
-m $nic \
--vcpus $vcpu  \
--disk=/kvm/${disk} \
--network bridge=br0 \
--graphics vnc,listen=0.0.0.0,port=$vncport,keymap=en-us \
--import \
--noautoconsole