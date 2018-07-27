#!/bin/bash
:<<!
-----------------------------------------------------------------
|Script Name    	:       ssh_safe.sh			|
|Script Description	:	Detect ssh failed login &reject	|
|Update Time            :       2016-11-18 10:41 	        |
|Author                 :       Alvin Wan                       |
|Email                  :       alvin.wan.cn@hotmail.com        |
----------------------------------------------------------------
!
#Initialize detected setting
v_TemplatesDIR="/home/alvin/templates"
v_TemplateReceiver="alvin.wan@sophiroth.com"
mkdir -p $v_TemplatesDIR

#Define common variables
v_HistoryLog="$v_TemplatesDIR/history.log"
v_LatestLog="$v_TemplatesDIR/latest.log"
v_ReturnEmailReceiver="$v_TemplateReceiver"
v_ReturnEmailSubject="$v_TemplateReceiver"
v_ReturnEmailCC="$v_TemplateReceiver"
v_ReturnEmailAttachment="$v_TemplatesDIR/latest.log"
v_ReturnEmailText="$v_TemplatesDIR/latest.log"
v_LogEmailReceiver="$v_TemplateReceiver"
v_LogEmailSubject="Templates"
v_LogEmailCC="$v_TemplateReceiver"
v_LogEmailAttachment="$v_TemplatesDIR/latest.log"

#Define local variables

#Empty the latest logs.
>$v_LatestLog

#Defines function to transfers latest logs to history logs.
f_UpdateHistoryLog()
{
cat $v_LatestLog >> $v_HistoryLog
}

#Defines function to transfers logs of executed commands.
f_tl() #f_tl full name:transfers log.
{
 echo -e "$(date +%Y-%m-%d" "%H:%M:%S) \t $1" >> $v_LatestLog
}

#Define email notifications
f_SendLogEmail()
{
mail -a $v_LogEmailAttachment -s "$(date +%Y%m$d$H) $(hostname) $v_LogEmailSubject" -c $v_LogEmailCC $v_LogEmailReceiver < $v_LatestLog
}

#Defines function to send Ruturn email to RuturnEmailReciver
f_SendRuturnEmail()
{
echo -e $v_ReturnEmailText |mail -a $v_ReturnEmailAttachment -s "$v_ReturnEmailSubject" -c $v_ReturnEmailCC $v_ReturnEmailReceiver
}

#Defines function to detect /var/log/secure failed login records.

v_TodayFailedRecod=`grep "`date +%b' '%d`" secure|grep -i failed`


#Defines Main function
f_Main()
{
case $1 in
	1)
	echo ok
;;
	*)
	;;
esac
}
f_Main 1
