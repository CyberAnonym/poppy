#!/usr/bin/python
#coding:utf-8
import subprocess,os

if os.path.exists('/usr/bin/python3'):
    print('python3 is exist already.')
    exit(1)

subprocess.call('yum install gcc zlib zlib-devel libffi-devel openssl-devel -y',shell=True)
os.chdir('/tmp')
if os.path.exists('/tmp/python3.9.13.tar.xz'):
    pass
else:
    subprocess.call('curl -fsSL https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tar.xz > python3.9.13.tar.xz',shell=True)

subprocess.call('tar xf python3.9.13.tar.xz -C /usr/local/src/',shell=True)
os.chdir('/usr/local/src/Python-3.9.13/')
subprocess.call('./configure --prefix=/usr/local/python3',shell=True)
subprocess.call('make',shell=True)
subprocess.call('make install',shell=True)
subprocess.call("sed -i '210,212s/#//' /usr/local/src/Python-3.9.13/Modules/Setup",shell=True)
subprocess.call("sed -i '205s/#//' /usr/local/src/Python-3.9.13/Modules/Setup",shell=True)

subprocess.call('make',shell=True)
subprocess.call('make install',shell=True)
subprocess.call('ln -s /usr/local/python3/bin/python3 /usr/bin/',shell=True)
subprocess.call('python3 --version',shell=True)
