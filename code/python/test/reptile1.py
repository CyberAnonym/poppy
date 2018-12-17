#coding:utf-8

import urllib2,re
import time
from lxml import etree
print(123)

url='https://alv.pub/'

response = urllib2.urlopen(url)

#read response and decode
content = response.read().decode('utf-8')

print(content)
a='GENERAL.CONNECTION:                     Bridge br0'
print(a)