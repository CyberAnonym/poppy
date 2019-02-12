#!/bin/bash

ca_key_password=sophiroth
server_key_password=sophiroth

ca_Country_Name=CN
ca_State_Name=广东
ca_Locality_Name=深圳
ca_Organization_Name=华为云安全
ca_Organizational_Unit_Name=华为云安全
ca_Common_Name=云堡垒
ca_Email_Address=''

server_Country_Name=CN
server_State_Name=广东
server_Locality_Name=深圳
server_Organization_Name=华为云安全
server_Organizational_Unit_Name=华为云安全
server_Common_Name=云堡垒
server_Email_Address=''


#Install expect

yum install expect -y &>/dev/null
mkdir demoCA
cd demoCA
mkdir srl certs newcerts
touch index.txt serial
echo 1000 > serial
cd ..
\cp /etc/pki/tls/openssl.cnf  .
mkdir ca

expect <<eof
spawn openssl genrsa -aes256 -out ca/ca.key 2048
expect "Enter pass phrase"
send "${ca_key_password}\n"
expect "Verifying"
send  "${ca_key_password}\n"
expect eof
eof

expect <<eof
spawn openssl req -utf8 -new -key ca/ca.key -out ca/ca.csr -config ./openssl.cnf
expect "Enter"
send "${ca_key_password}\n"
expect "Country Name"
send "$ca_Country_Name\n"
expect "State or Province Name"
send "$ca_State_Name\n"
expect "Locality Name"
send "$ca_Locality_Name\n"
expect "Organization Name"
send "$ca_Organization_Name\n"
expect "Organizational Unit Name"
send "$ca_Organizational_Unit_Name\n"
expect "Common Name"
send "$ca_Common_Name\n"
expect "Email Address"
send "$ca_Email_Address\n"
expect "A challenge password"
send "\n"
expect "An optional company name"
send "\n"
expect eof
eof

expect <<eof
spawn openssl x509 -req -days 3650 -sha1 -extensions v3_ca -signkey ca/ca.key -in ca/ca.csr -out ca/ca.crt
expect "Enter pass phrase"
send "$ca_key_password\n"
expect eof
eof


#生成根证书

mkdir server

expect <<eof
spawn openssl genrsa -aes256 -out server/server.key 2048
expect "Enter pass phrase"
send "${server_key_password}\n"
expect "Verifying"
send  "${server_key_password}\n"
expect eof
eof

##取消密码
cd server
\cp server.key server.key.org

expect <<eof
spawn openssl rsa -in server.key.org -out server.key
expect "Enter pass phrase for"
send "${server_key_password}\n"
expect eof
eof

cd ..

expect <<eof
spawn openssl req -utf8 -new -key server/server.key -out server/server.csr -config ./openssl.cnf
expect "Country Name"
send "$server_Country_Name\n"
expect "State or Province Name"
send "$server_State_Name\n"
expect "Locality Name"
send "$server_Locality_Name\n"
expect "Organization Name"
send "$server_Organization_Name\n"
expect "Organizational Unit Name"
send "$server_Organizational_Unit_Name\n"
expect "Common Name"
send "$server_Common_Name\n"
expect "Email Address"
send "$server_Email_Address\n"
expect "A challenge password"
send "\n"
expect "An optional company name"
send "\n"
expect eof
eof

\cp -rap  demoCA/* /etc/pki/CA/

expect <<eof
spawn openssl ca -in server/server.csr -out server/server.crt -cert ca/ca.crt -keyfile ca/ca.key -config ./openssl.cnf
expect "Enter pass phrase for"
send "$ca_key_password\n"
expect "Sign the certificate"
send "y\n"
expect "1 out of 1 certificate requests certified"
send "y\n"
expect eof
eof

ls -l server
ls -l ca


#         ssl_certificate " /root/server/server.crt";
#        ssl_certificate_key " /root/server/server.key";
