#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward

IPVSADM='/sbin/ipvsadm'
VIP=192.168.105.111
RS1=192.168.105.103
RS2=192.168.105.104

ifconfig eth0:1 $VIP broadcast $VIP netmask 255.255.255.255 up
route add -host $VIP dev eth0:1
$IPVSADM -C
#$IPVSADM -A -t $VIP:80 -s lc -p 600
#$IPVSADM -a -t $VIP:80 -r $RS1:80 -g -w 1
#$IPVSADM -a -t $VIP:80 -r $RS2:80 -g -w 1

$IPVSADM -A -t $VIP:80 -s rr
$IPVSADM -a -t $VIP:80 -r $RS1:80 -g
$IPVSADM -a -t $VIP:80 -r $RS2:80 -g
