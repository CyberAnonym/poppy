#!/bin/bash

export DOMAIN=alv.pub
##This function is a Description of this script
function _Script_description
{
echo -e "\t\t\033[31m Welcome to use alv.pub NIS Client Installation Script\033[0m"
echo -e "\t\t\033[32m If you have anything problem in the script running,You can contact the script writer Alvin\033[0m"
echo -e "\t\t\033[32m Email:alv@alv.pub\033[0m"
}

##This function is use for yum check.
function _Yum_check
{
echo "The script is checking your yum configuration..."
YUM_AMOUNT=$(yum repolist|tail -1|awk '{print $2}'|sed 's/,//')
echo -e "Your total number of yum packages is\033[32m $YUM_AMOUNT\033[0m"
if [ $YUM_AMOUNT -gt 3000 ]
	then
	echo "The yum resource maybe is ok,Now the script will continue runing with nis agent installation"
	else
	echo "The total number of packages less than 3000,The yum resource maybe not ok,Please make your yum configured correctly,then run this script again."
	exit 2
fi
}
#This function use for software installation
function _Software_installation
{
yum -y install yp-tools >> /dev/null
yum -y install ypbind >> /dev/null
yum -y install autofs >> /dev/null
yum -y install nfs-utils >> /dev/null
chkconfig ypbind on
chkconfig autofs on
}

#This Function use for nis configure.

function _Nis_configure
{
nisdomainname alv.pub
echo "/bin/nisdomainname alv.pub" >> /etc/rc.local
cat /etc/sysconfig/network|grep NISDOMAIN >> /dev/null && sed -i 's/NISDOMAIN.*/NISDOMAIN=alv.pub/' /etc/sysconfig/network || echo "NISDOMAIN=alv.pub" >> /etc/sysconfig/network
cat /etc/yp.conf|grep nis.alv.pub >> /dev/null || echo "domain alv.pub server nis.alv.pub" >> /etc/yp.conf
sed -i 's/^hosts.*/hosts: files nis dns/' /etc/nsswitch.conf
sed -i 's/^passwd.*/passwd: files nis/' /etc/nsswitch.conf
sed -i 's/^shadow.*/shadow: files nis/' /etc/nsswitch.conf
sed -i 's/^group.*/group: files nis/' /etc/nsswitch.conf
sed -i 's/^automount.*/automount: files nis/' /etc/nsswitch.conf
/etc/init.d/rpcbind restart
/etc/init.d/ypbind restart
}
#This function use for autofs configuration
function _Autofs_configure
{
#mkdir -p /export/home
#echo "/export/home auto.home rw,nosuid --timeout=60" >> /etc/auto.master
#echo "* nis.alv.pub:/serverdata/&" >> /etc/auto.home
/etc/init.d/autofs restart
#cat /etc/group|grep alv >> /dev/null ||groupadd -g 105 alv
}
#This function is program main
function MAIN
{
if [ _Script_description ];then
	sleep 1
	start Yum detection...
	_Yum_check
	if [ $? -eq 0 ];then
	echo -e "\t\t\033[32m The detection of yum has been completed,Now start software installation\033[0m"
		_Software_installation
		if [ $? -eq 0 ];then
			echo -e "\t\t\033[32m Softwork installation has been completed\033[0m"
			echo -e "\t\t\033[32m Now start NIS configure\033[0m"
			_Nis_configure
			if [ $? -eq 0 ]
				then
				echo -e "\t\t\033[32m NIS has been configure completed.\033[0m"
				_Autofs_configure
				if [ $? -eq 0 ]
					then
					echo -e "\t\t\033[32m This Script has been running over,Please check your nis user,Enjoy this.\033[0m"
				else
					echo -e "\t\t\033[32m autofs configure has error,Please check.\033[0m"	
					exit 2
				fi
			else
				echo -e "\t\t\033[32m NIS configure has error,Please check.\033[0m"
				exit 2
			fi
	
		else
			echo -e "\t\t\033[32m In the software installtion has error,process has quit,Please check.\033[0m"
			exit 2
		fi 
	else
		echo -e "\t\t\033[32m The detection of yum has error,Please check it.\033[0m"
		exit 2
	fi
else
	echo "The script description running has error,Please check."
	exit 2
fi

}

MAIN
