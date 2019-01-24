常用安全加固方式
#########################


设置超时时间
===================


.. code-block:: bash

    echo 'TMOUT=180' >> /etc/profile



限定用户的登录失败次数
===========================================

限定用户的登录失败次数，如果次数达到设置的阈值，则锁定用户


编辑PAM的配置文件
------------------------

vim /etc/pam.d/login

    #%PAM-1.0
    auth      required  pam_tally2.so   deny=3  lock_time=300 even_deny_root root_unlock_time=10
    auth [user_unknown=ignore success=ok ignoreignore=ignore default=bad] pam_securetty.so
    auth       include      system-auth

    account    required     pam_nologin.so
    account    include      system-auth
    password   include      system-auth
    # pam_selinux.so close should be the first session rule
    session    required     pam_selinux.so close
    session    optional     pam_keyinit.so force revoke
    session    required     pam_loginuid.so
    session    include      system-auth
    session    optional     pam_console.so
    # pam_selinux.so open should only be followed by sessions to be executed in the user context
    session    required     pam_selinux.so open

各参数解释

::

    even_deny_root    也限制root用户；

    deny           设置普通用户和root用户连续错误登陆的最大次数，超过最大次数，则锁定该用户

    unlock_time        设定普通用户锁定后，多少时间后解锁，单位是秒；

    root_unlock_time      设定root用户锁定后，多少时间后解锁，单位是秒；

    此处使用的是 pam_tally2 模块，如果不支持 pam_tally2 可以使用 pam_tally 模块。另外，不同的pam版本，设置可能有所不同，具体使用方法，可以参照相关模块的使用规则。


在#%PAM-1.0的下面，即第二行，添加内容，一定要写在前面，如果写在后面，虽然用户被锁定，但是只要用户输入正确的密码，还是可以登录的！



这个只是限制了用户从tty登录，而没有限制远程登录，如果想限制远程登录，需要改SSHD文件


.. code-block:: bash

    $ vim /etc/pam.d/sshd
    #%PAM-1.0
    auth          required        pam_tally2.so        deny=3  unlock_time=300 even_deny_root root_unlock_time=10

    auth       include      system-auth
    account    required     pam_nologin.so
    account    include      system-auth
    password   include      system-auth
    session    optional     pam_keyinit.so force revoke
    session    include      system-auth
    session    required     pam_loginuid.so


查看用户失败次数

.. code-block:: bash

    $ pam_tally2 --user alvin
    Login           Failures Latest failure     From
    alvin               1    01/23/19 15:04:02  tty2


解锁指定用户

.. code-block:: bash

    $ pam_tally2 -r -u  alvin
    Login           Failures Latest failure     From
    alvin               1    01/23/19 15:05:35  tty1


centos7 设置复杂用户密码策略
=====================================

设置最小密码长度：（不少于8个字符）

authconfig --passminlen=8 --update

测试查看是否更新成功：

grep "^minlen" /etc/security/pwquality.conf

设置同一类的允许连续字符的最大数目：

authconfig --passmaxclassrepeat=4 --update

测试查看是否更新成功：

grep "^maxclassrepeat" /etc/security/pwquality.conf

新密码中至少需要一个小写字符：

authconfig --enablereqlower --update

测试查看是否更新成功：

grep "^lcredit" /etc/security/pwquality.conf

新密码中至少需要一个大写字符：

authconfig --enablerequpper --update

测试查看是否更新成功：

grep "^ucredit" /etc/security/pwquality.conf

新密码中至少需要一个数字：

authconfig --enablereqdigit --update

测试查看是否更新成功：

grep "^dcredit" /etc/security/pwquality.conf

新密码包括至少一个特殊字符：

authconfig --enablereqother --update

测试查看是否更新成功：

grep "^ocredit" /etc/security/pwquality.conf

为新密码设置hash/crypt算法（默认为sha512）：

查看当前算法：authconfig --test | grep hashing

若不是建议更新：authconfig --passalgo=sha512 --update