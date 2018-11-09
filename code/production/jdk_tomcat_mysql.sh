#!/bin/bash


#定义提示格式

notes(){
    echo -e "\033[034m$1 \033[0m"
}

#定义提示格式

echo0(){ #定义绿色字体输出success 红色字体是31m.绿色字是32m# 黄色颜色是33m,
echo -e "$1 \033[032m [success] \033[0m"
}
echo1(){ #定义红色字体输出failed
echo -e "$1 \033[031m [Failed] \033[0m"
}
checkLastCommand(){ #定义确认命令是否执行成功的消息输出的函数
if [ $? -eq 0 ];then
    echo0 "$1"
    else
    echo1 "$2"
fi
}



#创建安装java的函数
function install_java()
{
    notes '现在开始解压jdk-8u191-linux-x64.tar.gz '
    tar xf jdk-8u191-linux-x64.tar.gz -C /usr/local/
    checkLastCommand '解压jdk成功' '解压jdk失败'
    notes '现在开始设置JAVA环境变量'
    echo 'export JAVA_HOME=/usr/local/jdk1.8.0_191' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$PATH' >> /etc/profile
    checkLastCommand 'JAVA环境变量已添加至/etc/profile' '环境变量添加失败'
    source /etc/profile
    notes '以下是当前系统JAVA版本信息'
    java -version
}

#创建安装tomcat的函数
function install_tomcat()
{
    notes '现在开始解压tomcat 到/usr/local/'
    tar xf apache-tomcat-8.5.34.tar.gz -C /usr/local/
    checkLastCommand '解压apache-tomcat-8.5.34.tar.gz到/usr/local/成功' '解压apache-tomcat-8.5.34.tar.gz失败'
}

#创建安装mysql的函数
function install_mysql()
{
    notes '现在开始解压mysql-server_5.7.24-1ubuntu16.04_amd64.deb-bundle.tar'
    tar xf mysql-server_5.7.24-1ubuntu16.04_amd64.deb-bundle.tar
    checkLastCommand '解压mysql-server_5.7.24-1ubuntu16.04_amd64.deb-bundle.tar成功' '安装失败'
    notes '现在开始安装mysql-common_5.7.24-1ubuntu16.04_amd64.deb'
    dpkg -i mysql-common_5.7.24-1ubuntu16.04_amd64.deb
    checkLastCommand '成功安装mysql-common_5.7.24-1ubuntu16.04_amd64.deb' '安装失败'
    notes '现在开始安装当前目录下的libmysql*'
    dpkg -i libmysql*
    checkLastCommand '成功安装libmysql*' '安装失败'
    #wget http://security.ubuntu.com/ubuntu/pool/universe/m/mecab/libmecab2_0.996-1.2ubuntu1_amd64.deb
    notes '现在开始安装libmecab2_0.996-1.2ubuntu1_amd64.deb'
    dpkg -i libmecab2_0.996-1.2ubuntu1_amd64.deb
    checkLastCommand 'libmecab2_0.996-1.2ubuntu1_amd64.deb 安装完成' '安装失败'
    #dpkg -i libm*
    #wget http://ftp.br.debian.org/debian/pool/main/liba/libaio/libaio1_0.3.110-3_amd64.deb
    notes '现在开始安装libaio1_0.3.110-3_amd64.deb'
    dpkg -i libaio1_0.3.110-3_amd64.deb
    checkLastCommand 'libaio1_0.3.110-3_amd64.deb 安装完成' '安装失败'
    notes '现在开始安装mysql-community-client_5.7.24-1ubuntu16.04_amd64.deb'
    dpkg -i mysql-community-client_5.7.24-1ubuntu16.04_amd64.deb
    checkLastCommand 'mysql-community-client_5.7.24-1ubuntu16.04_amd64.deb 安装完成' '安装失败'
    notes '现在开始安装mysql-client_5.7.24-1ubuntu16.04_amd64.deb'
    dpkg -i mysql-client_5.7.24-1ubuntu16.04_amd64.deb
    checkLastCommand 'mysql-client_5.7.24-1ubuntu16.04_amd64.deb 安装完成' '安装失败'
    ##准备root密码，设置密码为root，写入到预备的文件，实现非交互式安装mysql
    echo 'debconf mysql-community-server/root-pass password root' > /tmp/mysql-passwd
    echo 'debconf mysql-community-server/re-root-pass password root' >> /tmp/mysql-passwd

    #导入配置
    debconf-set-selections /tmp/mysql-passwd
    notes '现在开始安装mysql-community-server_5.7.24-1ubuntu16.04_amd64.deb'
    #开始安装
    dpkg -i mysql-community-server_5.7.24-1ubuntu16.04_amd64.deb

    checkLastCommand 'mysql-community-server_5.7.24-1ubuntu16.04_amd64.deb安装完成' '安装失败'
}

#创建设置mysql的函数
function setup_mysql()
{
    notes '正在设置数据库密码'

    mysql -uroot -proot -e 'grant all privileges on *.* to "root"@"localhost" identified by "root"'

    checkLastCommand '密码设置完成' '失败'

    notes '现在开始创建数据库'

    mysql -uroot -proot -e 'create database yufeng_cj;'

    checkLastCommand '数据库创建完成' '失败'

    notes '现在开始执行sql初始化库'
    mysql -uroot -proot yufeng_cj < yufeng_cj.sql
    checkLastCommand '数据库初始化完毕' '失败'
}

#创建主函数
main (){

    install_java
    install_tomcat
    install_mysql
    setup_mysql
    notes '所有操作已完成。'
    notes 'tomcat路径:  /usr/local/apache-tomcat-8.5.34/'
    notes '启动tomcat命令： /usr/local/apache-tomcat-8.5.34/bin/startup.sh'
    notes '关闭tomcat命令： /usr/local/apache-tomcat-8.5.34/bin/shutdown.sh'
    notes 'jdk路径:  /usr/local/jdk1.8.0_191/'
    notes 'java版本信息：'
    java -version
    notes '数据库用户名：root,数据库密码：root,主配置文件地址:/etc/mysql/mysql.conf.d/mysqld.cnf.'
}

#执行主函数
main


