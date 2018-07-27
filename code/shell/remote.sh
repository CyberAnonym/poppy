#!/bin/bash

##Check expect
function _CHECK_EXPECT
{

rpm -q expect >> /dev/null || yum install expect
}
##Check define
_CHECK_EXPECT
_PASSWORD=wankaihao


#ssh root@192.168.105.3 "find /serverdata/alvin -name rmpcie -exec chown root {} \; && find /serverdata/alvin -name rmpcie -exec chmod 4755 {} \;"
#ssh root@192.168.105.3 "ls /root"

expect <<eof ssh root@192.168.105.3 "find /serverdata/alvin -name rmpcie -exec chown root {} \; && find /serverdata/alvin -name rmpcie -exec chmod 4755 {} \;"
spawn ssh root@192.168.105.3 "ls /root"
expect {
"yes/no"
{ send "yes\n";exp_continue }
"assword"
{send "${_PASSWORD}\n"} 
}
expect eof
eof

