#!/usr/bin/python
#coding:utf-8
import subprocess

#创建用于挂载镜像的目录
print('Start create directory /mnt/iso')
subprocess.call('mkdir -p /mnt/iso',shell=True)
#设置将进行自动挂载到/mnt/iso目录
print('setup automatic mount')
subprocess.call('grep /mnt/iso /etc/fstab || echo "/dev/sr0 /mnt/iso   iso9660 defaults,loop 0 0" >> /etc/fstab',shell=True)
#让/etc/fstab里的挂载设置生效
print('make mount work')
subprocess.call('mount -a',shell=True)
#从网上下载base.repo配置文件到本地
print('create base.repo')
subprocess.call('curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/yum.repos.d/base.repo > /etc/yum.repos.d/base.repo',shell=True)
#查看yum仓库的信息
print('execute yum repolist')
subprocess.call('yum repolist',shell=True)