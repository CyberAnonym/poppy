Nginx自签ssl证书创建及配置
#####################################


使用OpenSSL创建证书
=========================

#. 建立服务器私钥（过程需要输入密码，请记住这个密码）生成RSA密钥，这我们生成2048 Bits的，更安全，现在1024的都已经被视为不安全的了，在一些机构那里都过不了审。

    .. code-block:: bash
        :emphasize-lines: 1
        :linenos:

        [alvin@poppy ~]$ openssl genrsa -des3 -out server.key 2048
        Generating RSA private key, 2048 bit long modulus
        ............++++++
        ....++++++
        e is 65537 (0x10001)
        Enter pass phrase for server.key:
        Verifying - Enter pass phrase for server.key:
        [alvin@poppy ~]$ ll server.key
        -rw-r--r--. 1 alvin sophiroth 963 Aug 24 09:08 server.key

#. 生成一个证书请求（CSR）


.. code-block:: bash
    :linenos:
    :emphasize-lines:  1,2,10-16

    [alvin@poppy ~]$ openssl req -new -key server.key -out server.csr
    Enter pass phrase for server.key:           ##之前输入的密码
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:CN           ##国家
    State or Province Name (full name) []:Shanghai      ##区域或省份
    Locality Name (eg, city) [Default City]:Shanghai        ##地区局部名字
    Organization Name (eg, company) [Default Company Ltd]:Sophiroth     ## 机构名称：填写公司名
    Organizational Unit Name (eg, section) []:IT        ## 组织单位名称:部门名称
    Common Name (eg, your name or your server s hostname) []:poppy.alv.pub  ##网站域名，非常重要，填写你要用于访问的域名
    Email Address []:alvin.wan.cn@hotmail.com           ##邮箱地址

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:            ##输入一个密码，可直接回车
    An optional company name []:        ##一个可选的公司名称，可直接回车

#. 输入完这些内容，就会在当前目录生成server.csr文件,在加载SSL支持的Nginx并使用上述私钥时除去必须的口令：

    .. code-block:: bash

        [alvin@poppy ~]$ cp server.key server.key.org
        [alvin@poppy ~]$ openssl rsa -in server.key.org -out server.key
        Enter pass phrase for server.key.org:
        writing RSA key

#. 使用上面的密钥和CSR对证书进行签名



    - 以下命令生成v3版证书
        这里我们要用v3版证书，因为v1版v2版不够安全，在有些地方都过不了审。

    .. code-block:: bash

        $ openssl x509 -req  -days 365 -sha256 -extfile /etc/pki/tls/openssl.cnf -extensions v3_req   -in server.csr -signkey server.key -out server.crt

    #  v3版证书另需配置文件openssl.cnf， `OpenSSL生成v3证书方法及配置文件 <./008-openssl_v3.html>`__ 在下一章

    .. note::

        重要说明： -extfile /etc/pki/tls/openssl.cnf -extensions v3_req  参数是生成 X509 V3 版本的证书的必要条件。 /etc/pki/tls/openssl.cnf  是系统自带的OpenSSL配置文件，该配置文件默认开启 X509 V3 格式。下同。


    - 以下命令生成v1版证书
        如果还是要用v1版的证书，可以使用下面的命令，生成X.509v1证书。

    .. code-block:: bash

        $ openssl x509 -req  -days 365 -sha256   -in server.csr -signkey server.key -out server.crt

nginx使用证书
======================

#. 先安装nginx

    .. code-block:: bash

        $ sudo yum install nginx -y

#. 将证书放到相应的目录

    .. code-block:: bash

        [alvin@poppy ~]$ sudo mkdir -p /etc/nginx/ssl
        [alvin@poppy ~]$ sudo cp server.key /etc/nginx/ssl/
        [alvin@poppy ~]$ sudo cp server.crt /etc/nginx/ssl/

#. Nginx下ssl配置方

    首先，确保安装了OpenSSL库，并且安装Nginx时使用了–with-http_ssl_module参数。

    配置server

    .. code-block:: bash

        $ sudo vim /etc/nginx/nginx.conf
        server {

            listen 443 ssl;
            server_name poppy.alv.pub;

            index index.html;
            ssl on;
            ssl_certificate      ssl/server.crt;
            ssl_certificate_key  ssl/server.key;
            ssl_session_cache    shared:SSL:10m;
            ssl_session_timeout 5m;
            ssl_protocols    TLSv1 TLSv1.1 TLSv1.2;

            location / {
                root /opt/www/;
            }
        }

#. 这里我们使用了/opt/www目录作为我们的网站目录，接下来我们创建一下这个目录资源

    .. code-block:: bash

        [alvin@poppy ~]$ sudo mkdir -p /opt/www
        [alvin@poppy ~]$ sudo bash -c 'echo "this is poppy" > /opt/www/index.html'


#. 启动服务

    - 先测试下配置是否正确

    .. code-block:: bash

        [alvin@poppy ~]$ sudo nginx -t
        nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
        nginx: configuration file /etc/nginx/nginx.conf test is successful

    - 启动服务

    .. code-block:: bash

        [alvin@poppy ~]$ sudo systemctl start nginx
        [alvin@poppy ~]$ sudo systemctl enable nginx
        Created symlink from /etc/systemd/system/multi-user.target.wants/nginx.service to /usr/lib/systemd/system/nginx.service.

    - 查看端口

    .. code-block:: bash

        [alvin@poppy ~]$ sudo lsof -i:443
        COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
        nginx   3119  root    8u  IPv4  36978      0t0  TCP *:https (LISTEN)
        nginx   3120 nginx    8u  IPv4  36978      0t0  TCP *:https (LISTEN)
        nginx   3121 nginx    8u  IPv4  36978      0t0  TCP *:https (LISTEN)
        nginx   3122 nginx    8u  IPv4  36978      0t0  TCP *:https (LISTEN)
        nginx   3123 nginx    8u  IPv4  36978      0t0  TCP *:https (LISTEN)

#. 重定向（可选）

    .. code-block:: bash

        $ sudo vim /etc/nginx/nginx.conf
        server {
            listen 80;
            server_name your.domain.name;
            rewrite ^(.*) https://$server_name$1 permanent;
        }


客户端访问https的资源
=====================

- 直接curl访问，会提示证书问题，无法访问

.. code-block:: bash


    [alvin@saltstack ~]$ curl https://poppy.alv.pub
    curl: (60) Peer's certificate issuer has been marked as not trusted by the user.
    More details here: http://curl.haxx.se/docs/sslcerts.html

    curl performs SSL certificate verification by default, using a "bundle"
     of Certificate Authority (CA) public keys (CA certs). If the default
     bundle file isn't adequate, you can specify an alternate file
     using the --cacert option.
    If this HTTPS server uses a certificate signed by a CA represented in
     the bundle, the certificate verification probably failed due to a
     problem with the certificate (it might be expired, or the name might
     not match the domain name in the URL).
    If you'd like to turn off curl's verification of the certificate, use
     the -k (or --insecure) option

- curl加-k参数，访问使用不受信任的证书的网站

.. code-block:: bash

    [alvin@saltstack ~]$ curl -k https://poppy.alv.pub
    this is poppy



- 使用证书访问

.. code-block:: bash

    [alvin@poppy ~]$ scp server.crt saltstack:/tmp/   #将证书传递给客户端
    [alvin@saltstack ~]$ curl --cacert /tmp/server.crt  https://poppy.alv.pub  ##客户端使用证书访问
    this is poppy


- 添加证书到受信任后直接访问

.. code-block:: bash

    [alvin@saltstack ~]$ sudo bash -c 'cat /tmp/server.crt  >> /etc/ssl/certs/ca-bundle.crt '
    [alvin@saltstack ~]$ curl   https://poppy.alv.pub
    this is poppy

