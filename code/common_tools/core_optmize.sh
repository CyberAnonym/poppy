#!/bin/bash

curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/conf.d/sysctl.conf > /etc/sysctl.conf
sysctl -p