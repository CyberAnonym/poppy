#coding:utf-8
import re
a='52:54:00:d9:94:10'

print(a.split(':')[-1])

tail_1='a'
if 0:print(222)

a='GENERAL.CONNECTION:                     Bridge br0'
print(a)
print(type(re.sub(r'(GENERAL.CONNECTION:\s+)','',a)))