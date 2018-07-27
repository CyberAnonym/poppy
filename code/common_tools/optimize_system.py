#coding:utf-8
import subprocess

subprocess.call('grep "set ts=4" /etc/vimrc||echo "set ts=4" >> /etc/vimrc',shell=True)
subprocess.call('grep "set expandtab" /etc/vimrc||echo "set expandtab" >> /etc/vimrc',shell=True)
subprocess.call("""grep "HISTTIMEFORMAT=" /etc/profile||echo 'export HISTTIMEFORMAT="[%F %T] "' >> /etc/profile""",shell=True)
