#!/usr/bin/env bash

echo0(){ #定义绿色字体输出success 红色字体是31m.绿色字是32m# 黄色颜色是33m,
echo -e "$1 \033[032m [success] \033[0m"
}
echo1(){ #定义红色字体输出failed
echo -e "$1 \033[031m [Failed] \033[0m"
}
checkLastCommand(){ #定义确认命令是否执行成功的消息输出的函数
if [ $? -eq 0 ];then
    echo0 "$1"
    else
    echo1 "$2"
fi
}

configureSSHD(){
sed -i 's/GSSAPIAuthentication.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config
checkLastCommand "'GSSAPIAuthentication' no has been configure in /etc/ssh/sshd_config" "Failed configure"
sed -i 's/.UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
checkLastCommand "'UseDNS no' has been configure in /etc/ssh/sshd_config" "Failed configure"
service sshd reload
checkLastCommand "sshd service has been reload" "Failed reload sshd"
}
main(){
configureSSHD
}
main
