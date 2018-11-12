#coding:utf-8
import subprocess

subprocess.call('yum install *open*vm*tool* vim lrzsz wget tree -y',shell=True) #安装常用工具。lrzsz是用于代替ftp在linux和windows之间传东西工具，sz file.txt去将linux下文件传到windows，rz命令去上传window的文件到linux
subprocess.call('grep "set ts=4" /etc/vimrc||echo "set ts=4" >> /etc/vimrc',shell=True)
subprocess.call('grep "set expandtab" /etc/vimrc||echo "set expandtab" >> /etc/vimrc',shell=True)
subprocess.call("""grep "HISTTIMEFORMAT=" /etc/profile||echo 'export HISTTIMEFORMAT="[%F %T] "' >> /etc/profile""",shell=True)
subprocess.call('yum install bash-completion* -y',shell=True)
subprocess.call('setterm -blank 0',shell=True) #关闭屏保

