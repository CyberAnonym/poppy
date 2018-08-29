curl
####

curl参数详解
===============

    -A    --user-agent <string> 设置用户代理发送给服务器
    -b    --cookie <name=string/file> cookie字符串或文件读取位置
    -c    --cookie-jar <file> 操作结束后把cookie写入到这个文件中
    -C    --continue-at <offset> 断点续转
    -d      发送 POST 请求
    -D    --dump-header <file> 把header信息写入到该文件中
    -e    --referer 来源网址
    -f    --fail 连接失败时不显示http错误
    -o    --output 把输出写到该文件中
    -O    --remote-name 把输出写到该文件中，保留远程文件的文件名
    -r    --range <range> 检索来自HTTP/1.1或FTP服务器字节范围
    -s    --silent 静音模式。不输出任何东西
    -S    --show-error When used with -s it makes curl show an error message if it fails.
    -T    --upload-file <file> 上传文件
    -u    --user <user[:password]> 设置服务器的用户和密码
    -w    --write-out [format] 什么输出完成后
    -x    --proxy <host[:port]> 在给定的端口上使用HTTP代理
    -L       跟随链接重定向
    -H      自定义 header
    -i      输出时包括protocol头信息
    -v      查看ssl证书信息

    -#    --progress-bar 进度条显示当前的传送状态

curl 发送post请求，传参示例
====================================

::

    curl -l -H Content-type:application/json -X POST --data '{"appVersion":"5.0.1","loginName":"17898852496","operatorUserId":"string","pageNo":"-1","password":"f379eaf3c831b04de153469d1bec345e","phoneType":"iPhone 7__iOS10.3.1","platformCode":"pangProApp","rowsPerPage":10,"sessionid":"8xxxx"}' http://cbp.shxxxh.com:556/shenmin-authority/authority/loginWithPassword


curl下载东西。
==============================

::

    curl -sSL http://www.golangtc.com/static/go/1.6.2/go1.6.2.linux-amd64.tar.gz -o o1.6.2.linux-amd64.tar.gz


查看目标服务器使用的web服务名称和版本
============================================================
::

    curl -I alv.pub


使用用户名和密码
==============================
::

    curl -u alvin:wankaihao k8s.shenmin.com



通过curl访问网站查看自己的公网IP
============================================================

::

    curl http://ipinfo.io/ip






执行网络脚本
==============================
::

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/scripts/master/common_tools/sshslowly.sh)"
    或者
    curl -s https://raw.githubusercontent.com/AlvinWanCN/scripts/master/common_tools/sshslowly.sh|bash
