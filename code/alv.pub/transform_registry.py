#!/usr/bin/python
#coding:utf-8

import  subprocess

image_src_list=subprocess.check_output('docker images',shell=True).split('\n')

image_list=[]
image_list.append()