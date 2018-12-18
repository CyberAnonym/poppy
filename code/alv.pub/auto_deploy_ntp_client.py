#:coding:utf-8
#本脚本用于自动安装配置ntp客户端
import subprocess

#本脚本网络地址：https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/auto_deploy_ntp_client.py
#shell下一键使用： curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/alv.pub/auto_deploy_ntp_client.py|python

appdict={}
appdict['ntp_server']='ipa.alv.pub'
appdict['src_file']='https://raw.githubusercontent.com/AlvinWanCN/poppy/master/conf.d/common/etc/chrony.conf'
appdict['dest_file']='/etc/chrony.conf'
appdict['app_name']='chrony'
appdict['svc_name']='chronyd'

##Install chrony
def install_chrony():
    if subprocess.call('yum install {app_name} -y'.format(**appdict),shell=True) == 0 :
        print('{app_name} is already installed'.format(**appdict))
    else:
        print('{app_name} can not installed, exit installation'.format(**appdict))
        exit(1)

#setup configuration file
def set_cfg_file():
    if subprocess.call('curl -s {src_file} > {dest_file} && sed -i "s/ipa.alv.pub/{ntp_server}/" {dest_file}'.format(**appdict),shell=True) == 0:
        print('configuration file write done')
    else:
        print('configuration file write failed, exit process')
        exit(1)

#startup app
def startup_app():
    if subprocess.call('systemctl restart {svc_name}'.format(**appdict),shell=True) == 0:
        print('{app_name} started successfully'.format(**appdict))
    else:
        print('{app_name} started failed'.format(**appdict))
        exit(1)

#define main function
def main():
    install_chrony()
    set_cfg_file()
    startup_app()

if __name__ == '__main__':
    main()
    del appdict