#coding:utf-8
import re

aa=re.split(r'\s','alvin','REPOSITORY                              TAG                 IMAGE ID            CREATED             SIZE').split('alvin')
print(re.sub(r'\s','',aa))