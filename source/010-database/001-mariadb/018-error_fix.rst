mysql排错
##############


集群下服务器全部down掉的情况下，按如下操作
================================================


找到vim /var/lib/mysql/grastate.dat 里面safe_to_bootstrap=1的那台服务器，先启动那台服务器上的mysql服务，service mysql start --wsrep-new-cluster 然后启动其他服务器上的。service mysql start。

第一个启动的服务器，启动的时候要加--wsrep-new-cluster

相关报错处理

- 问题1 启动时无法启动，报如下错

failed to open gcomm backend connection: 131: invalid UUID:

解决方案：

mv /var/lib/mysql/gvwstate.dat /var/lib/mysql/gvwstate.dat.bak

- 问题2 启动时无法启动，报如下错

[ERROR] WSREP: gcs/src/gcs_group.cpp:group_post_state_exchange():321: Reversing history: 2130 -> 2129, this member has applied 1 more events than the primary component.Data loss is possible. Aborting.

解决方案：

/etc/init.d/mysql start --wsrep-new-cluster

报错信息里说有Address already in use之类的报错。
如果报错里有Address already in use之类的报错，注意是不是4567端口还在监听状态，那个进程也是mysql的进程，需要先关闭这个进程，kill掉。