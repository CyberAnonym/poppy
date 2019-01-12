给grub设置用户名和密码
######################################

1)、执行生成加密密码的命令"grub2-mkpasswd-pbkdf2",两次输入相同密码，PBKDF2 hash of your password is 之后的部分就是加密后的密码




给grub菜单加密，就是为了不让不法分子利用单用户模式修改root密码，请看操作记录



 在/etc/grub.d/00_header 文件末尾，添加以下内容

::

    cat <<EOF
    set superusers='admin'
    password admin qwe123
    E0F


重新编译生成grub.cfg文件

::

    grub2-mkconfig  -o  /boot/grub2/grub.cfg


重启做验证