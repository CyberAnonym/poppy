#!/bin/bash

log_dir=/data/9480tomcat/apache-tomcat-7.0.55/logs/

DIRS=`ls ${log_dir}/catalina.out.*`

for i in $DIRS
do
    date=`echo $i|awk -F "catalina.out." '{print $2}'|awk -F "." '{print $1}'`
    peoples=`cat $i|awk -F 'userid":"' '{print $2}' |awk -F '"' '{print $1}'|sort |uniq |grep -v 170224105728104024397215|grep -v ^$|wc -l`
    echo $date $peoples
done