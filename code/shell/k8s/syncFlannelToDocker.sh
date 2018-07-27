#!/bin/bash
source /run/flannel/subnet.env
sudo sed -i "s|^ExecStart=/usr/bin/dockerd -H .*|ExecStart=/usr/bin/dockerd -H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}|g" /lib/systemd/system/docker.service
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
