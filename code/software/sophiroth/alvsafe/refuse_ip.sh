#!/bin/bash

	
v_IP=$1

v_receiver=alvin.wan@sophiroth.com
v_successEmailContent=" I am already added IP:$v_IP to iptables deny list."
v_successSubject="[YES] Added $v_IP to iptables deny list success"

v_failedEmailContent="I try to add $v_IP to iptables deny list, but I failed, please check by manual."
v_failedSubject="[NO] Add $v_IP to iptables deny list failed."



f_confirmIPExist(){
sudo iptables -L -n|grep $v_IP &>/dev/null
[ $? -eq 0 ] && exit 0
}

v_emailnotify(){
if [ $1 == "yes" ];then
	echo "$v_successEmailContent" |mail -s "$v_successSubject" $v_receiver
	else
	echo "$v_failedEmailContent" |mail -s "$v_failedSubject" $v_receiver
fi
}


f_refuseIP(){
sudo iptables -I INPUT -s $v_IP -j DROP
}

f_sendEmail(){
if [ $? -eq 0 ];then
	v_emailnotify yes
	else
	v_emailnotify no
fi
}
f_Main()
{
f_confirmIPExist
f_refuseIP
f_sendEmail
}
f_Main
#v_emailnotify yes
# echo $v_successEmailContent |mail -s $v_successsubject $v_receiver
#echo " I am already added IP:$v_IP to iptables deny list."  |mail -s yes alvin.wan@sophiroth.com

