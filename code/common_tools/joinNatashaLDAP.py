#!/usr/bin/python
#coding:utf-8
import os,re
def op0(content): #op是out put简写定义绿色字体输出success 红色字体是31m.绿色字是32m# 黄色颜色是33m,
    print(content+'\033[032m [success] \033[0m')
def op1(content):
    print(content + '\033[031m [failed] \033[0m')
def processCommand(command,successLog,failedLog): #定义确认命令是否执行成功的消息输出的函数
    if command in (0,None): #open打开的文件调用write成功写入时，返回None
        op0(successLog)
    else:
        op1(failedLog)
def installLDAPSoft(): #安装ldap客户端需要的软件
    processCommand(os.system('yum install nss-pam-ldapd setuptool -y'),"nss-pam-ldapd setuptool已安装完成。","nss-pam-ldapd setuptool安装失败")
def joinLDAP(): #加入ldap
    processCommand(os.system('authconfig --enableldap  --enableldapauth --ldapserver=ldap://ldap.alv.pub --disableldaptls  --enablemkhomedir --ldapbasedn="dc=alv,dc=pub" --update'),"已成功加入到ldap.alv.pub LDAP系统。","错误，没有成功加入到LDAP")
def installAutofs(): #安装autofs
    processCommand(os.system('yum -y install autofs nfs-utils'),"autofs has been installed","Failed install autofs")
def configureAuthfs(): #配置autofs
    openAutoMasterR = open('/etc/auto.master', 'r')
    openAutoSophiroth = open('/etc/auto.sophiroth', 'w')
    if re.findall(r'sophiroth',openAutoMasterR.read()): #检查/etc/auto.master里是否已添加了sophiroth。
        openAutoMasterR.close()
    else: #如果没有添加，那么现在就添加
        openAutoMasterW = open('/etc/auto.master', 'a')
        openAutoMasterW.write('/sophiroth auto.sophiroth rw,nosuid --timeout=60')
        openAutoMasterW.close()
    processCommand(openAutoSophiroth.write('* dc.alv.pub:/ldapUserData/&'),"Autofs has been configured","Failed configure autofs") #配置sophiroth autofs
    openAutoSophiroth.close()
def startAutofs(): #启动autofs
    processCommand(os.system('systemctl start autofs'),"Autofs has been started","Failed start autofs")
    processCommand(os.system('systemctl enable autofs'),"Autofs has been enabled","Failed enable autofs")
    os.system('systemctl start autofs')
def main():
    try:
        installLDAPSoft()
        joinLDAP()
        installAutofs()
        configureAuthfs()
        startAutofs()
    except Exception as e:
        print('Detected error,Please check your setting.')
        print(e)
if __name__ == "__main__":
    main()