#!/bin/bash
VIP=192.168.105.211
ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
route add -host $VIP dev lo:0
 
echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
sysctl -p
