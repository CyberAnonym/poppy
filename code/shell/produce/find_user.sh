
#for DAY in {1..30};do ls catalina.out.`date -d "$DAY day ago" +%Y-%m-%d`.log ;done
for file in $(for DAY in {1..30};do ls catalina.out.`date -d "$DAY day ago" +%Y-%m-%d`.log ;done);do grep "userid\":\"" $file |awk -F "userid\":\"" '{print $2}'|awk -F '"' '{print $1}'|sort -nr|uniq >> /tmp/user.log;done
#grep "userid\":\"" |awk -F "userid\":\"" '{print $2}'|awk -F '"' '{print $1}'|sort -nr|uniq
170318152924839522107080