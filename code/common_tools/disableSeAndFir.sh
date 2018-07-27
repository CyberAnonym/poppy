#!/bin/bash

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

disableSelinux(){ #定义关闭selinux的函数
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
checkLastCommand "selinux configuration file /etc/selinux/config has been configure to disabled"  "failed to change selinux configuration /etc/selinux/config"
setenforce 0
checkLastCommand "selinux linux has been disabled for this time." "failed to disable selinux"
}

disableFirewalld(){ #定义关闭firewalld防火墙的函数
systemctl stop firewalld
checkLastCommand "firewalld has been stoped" "failed to stop firewalld"
systemctl disable firewalld
checkLastCommand "firewald has been disabled" "failed to disable firewalld"
}

main(){ #定义主函数
disableSelinux
disableFirewalld
}

main
