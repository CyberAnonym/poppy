#!/usr/bin/env bash

curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/set_hostinfo_by_nic.py|python  #设置网络信息

bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/sshslowly.sh)"  #优化ssh

python -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/pullLocalYum.py)" #拉取本地镜像

python -c "$(curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/setup_zabbix_agent.py)" #安装zabbix客户端
