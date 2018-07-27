#!/bin/bash

#Script Description.
function _Script_info
{
echo -e "\t\033[31m Welcom to to use  the PXE install system custom script.\033[0m"
echo -e "\t\033[31m Anything problem,You can contact Alvin.\033[0m"
echo -e "\t\033[33m Email: alv@alv.pub \033[0m	"

}

##Your new server information.
function _Server_info

{
read -p "Please type your new server hostname:" _HOSTNAME
echo $_HOSTNAME
read -p "Please type your new Server IP address:" _IPADDR
read -p "Join alv.pub Nis Server？[y/n]:" _NIS
read -p "Join alv.pub Nagios Monitor？[y/n]" _NAGIOS
}
#make your new server ks.cfg
function _Make_ks
{
cp /fileshare/shell/pxe.template.cfg /var/www/html/custom.cfg
echo $_IPADDR
sed -i "s/NEWIP/$_IPADDR/" /var/www/html/custom.cfg
sed -i "s/NNAME/$_HOSTNAME/" /var/www/html/custom.cfg
if [ $_NIS == y ];then
	sed -i 's/NIS_INSTALLATION/wget http:\/\/192.168.105.4\/nisclient_installation.sh \&\& sh nisclient_installation.sh/' /var/www/html/custom.cfg
	else
	sed -i 's/NIS_INSTALLATION/echo ok/' /var/www/html/custom.cfg
fi


if [ $_NAGIOS == y ];then
	sed -i 's/NAGIOS_INSTALLATION/wget http:\/\/192.168.105.4\/nagios_agent_install.sh \&\& sh nagios_agent_install.sh/' /var/www/html/custom.cfg
	else
	sed -i 's/NAGIOS_INSTALLATION/echo ok/' /var/www/html/custom.cfg
fi
}
function _MAIN
{
_Script_info 
_Server_info
 _Make_ks

}

_MAIN
