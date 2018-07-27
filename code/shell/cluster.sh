_SSH(){
read -p "Please input your password:" _PASSWORD
read -p "Please input your network segment:" _SEGMENT
if ls /etc/init.d/sshd  &>/dev/null;then
    /etc/init.d/sshd restart >> /dev/null
    else
    yum install openssh-* -y >> /dev/null
    /etc/init.d/sshd start &>/dev/null
fi
    yum install expect -y &>/dev/null
#/usr/bin/expect <<eof
#spawn ssh-keygen
#expect "Enter file in which to save the key (/root/.ssh/id_rsa):"
#send "\n"
#expect {
#"Overwrite (y/n)?"
#{send "y\n";exp_continue}
# "Enter passphrase (empty for no passphrase):"
#{send "\n"}
#}
#expect "Enter same passphrase again:"
#send "\n"
#expect eof
#eof
yum install nmap -y &>/dev/null
IP=`nmap -sP ${_SEGMENT}/24 | grep for | cut -d " " -f 5`
for i in $IP
do
/usr/bin/expect <<eof
spawn scp /root/.ssh/id.rsa $i:/root/.ssh/
expect {
"yes/no"
{ send "yes\n";exp_continue }
"assword"
{send "${_PASSWORD}\n"} 
}
expect eof
eof
done
}
_SSH
