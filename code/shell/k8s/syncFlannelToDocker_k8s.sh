#!/bin/bash
source /run/flannel/subnet.env
sudo sed -i "s|usr/bin/dockerd-current|usr/bin/dockerd-current --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}|g" /lib/systemd/system/docker.service
rc=0
ip link show docker0 >/dev/null 2>&1 || rc="$?"
if [[ "$rc" -eq "0" ]]; then
ip link set dev docker0 down
ip link delete docker0
fi
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker
ifconfig
