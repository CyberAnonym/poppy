#!/bin/bash
#test1
v_logPath=/tmp/gold_value.log
v_gold_now=`curl -i --get --include 'http://jisugold.market.alicloudapi.com/gold/shgold' -H 'Authorization:APPCODE 5ca26b23675f4b7f81b365d115184cdf'|awk -F "沪金99\",\"price\":\"" '{print $2}'|awk -F "\"" '{print $1}'|tail -1`

echo `date +%Y-%m-%d" "%H:%M:%S`" $v_gold_now" >> $v_logPath
v_receiver=alvin.wan@shenmintech.com
echo "Now gold value is $v_gold_now"|mail -s "Gold value now $v_gold_now" $v_receiver
