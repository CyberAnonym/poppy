#!/usr/bin/python
#coding:utf-8

import  subprocess,re
image_src_list=subprocess.check_output('docker images',shell=True).rstrip().split('\n')
image_list=[]
for i in image_src_list:
    i=re.split(r'\s+',i)
    if i[0] == 'REPOSITORY':
        continue
    image_list.append({'REPOSITORY':i[0],'TAG':i[1],'IMAGE ID':i[2]})

for i in image_list:
    if re.search('k8s',i['REPOSITORY']):
        subprocess.call('docker tag %s registry.alv.pub:30001/%s:%s'%(i['IMAGE ID'],i['REPOSITORY'].split('/')[-1],i['TAG']),shell=True)
        subprocess.call('docker push registry.alv.pub:30001/%s:%s'%(i['REPOSITORY'].split('/')[-1],i['TAG']),shell=True)



#print(image_list)

