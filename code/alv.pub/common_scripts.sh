#!/usr/bin/env bash

curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/set_hostinfo_by_nic.py|python  #设置网络信息

bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/sshslowly.sh)"

python -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/pullLocalYum.py)"

curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/setup_zabbix_agent.py|python #安装zabbix客户端
