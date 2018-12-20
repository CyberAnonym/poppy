各种证书
#######################################################################

本文讲述那些证书相关的玩意儿(SSL,X.509,PEM,DER,CRT,CER,KEY,CSR,P12等)

之前没接触过证书加密的话,对证书相关的这些概念真是感觉挺棘手的,因为一下子来了一大堆新名词,看起来像是另一个领域的东西,而不是我们所熟悉的编程领域的那些东西,起码我个人感觉如此,且很长时间都没怎么搞懂.写这篇文章的目的就是为了理理清这些概念,搞清楚它们的含义及关联,还有一些基本操作.

SSL
======

SSL - Secure Sockets Layer,现在应该叫"TLS",但由于习惯问题,我们还是叫"SSL"比较多.http协议默认情况下是不加密内容的,这样就很可能在内容传播的时候被别人监听到,对于安全性要求较高的场合,必须要加密,https就是带加密的http协议,而https的加密是基于SSL的,它执行的是一个比较下层的加密,也就是说,在加密前,你的服务器程序在干嘛,加密后也一样在干嘛,不用动,这个加密对用户和开发者来说都是透明的.More:[维基百科]

OpenSSL - 简单地说,OpenSSL是SSL的一个实现,SSL只是一种规范.理论上来说,SSL这种规范是安全的,目前的技术水平很难破解,但SSL的实现就可能有些漏洞,如著名的"心脏出血".OpenSSL还提供了一大堆强大的工具软件,强大到90%我们都用不到.

证书标准
============

X.509 - 这是一种证书标准,主要定义了证书中应该包含哪些内容.其详情可以参考RFC5280,SSL使用的就是这种证书标准.

编码格式
==============

同样的X.509证书,可能有不同的编码格式,目前有以下两种编码格式.

PEM
--------

Privacy Enhanced Mail,打开看文本格式,以"-----BEGIN..."开头, "-----END..."结尾,内容是BASE64编码.

查看PEM格式证书的信息:

.. code-block:: bash

    openssl x509 -in certificate.pem -text -noout

Apache和*NIX服务器偏向于使用这种编码格式.

DER
-------
- Distinguished Encoding Rules,打开看是二进制格式,不可读.

查看DER格式证书的信息:

.. code-block:: bash

    openssl x509 -in certificate.der -inform der -text -noout

Java和Windows服务器偏向于使用这种编码格式.

相关的文件扩展名
======================
这是比较误导人的地方,虽然我们已经知道有PEM和DER这两种编码格式,但文件扩展名并不一定就叫"PEM"或者"DER",常见的扩展名除了PEM和DER还有以下这些,它们除了编码格式可能不同之外,内容也有差别,但大多数都能相互转换编码格式.


KEY
------
- 通常用来存放一个公钥或者私钥,并非X.509证书,编码同样的,可能是PEM,也可能是DER.

- 创建一个key

#. 建立服务器私钥（过程需要输入密码，请记住这个密码）生成RSA密钥

这里我们创建的key名为server.key,这里的名称我们所以，poppy.alv.pub.key也可以。

    .. code-block:: bash
        :emphasize-lines: 1
        :linenos:

        [alvin@poppy ~]$ openssl genrsa -des3 -out server.key 1024
        Generating RSA private key, 1024 bit long modulus
        ............++++++
        ....++++++
        e is 65537 (0x10001)
        Enter pass phrase for server.key:
        Verifying - Enter pass phrase for server.key:
        [alvin@poppy ~]$ ll server.key
        -rw-r--r--. 1 alvin sophiroth 963 Aug 24 09:08 server.key

- 查看KEY的办法:

.. code-block:: bash

    [alvin@poppy ~]$ openssl rsa -in server.key -text -noout
    Private-Key: (1024 bit)
    modulus:
        00:d2:ac:15:6a:79:e8:a1:7b:9e:2c:07:a8:19:11:
        d0:16:ce:0b:1c:20:b1:76:7c:41:56:27:c9:b0:bd:
        de:2f:39:ea:d2:6e:84:2c:0a:fc:fb:96:d7:38:68:
        d3:a6:74:87:24:51:64:94:5f:1a:2d:15:11:d5:c4:
        c8:6f:16:d3:23:bf:da:b0:ea:d0:bf:37:49:f3:03:
        00:98:bf:d6:e3:51:a1:43:b2:34:3e:a8:12:fa:0f:
        4f:f1:fb:e1:b9:5b:e2:f6:13:c1:69:7e:f7:dd:50:
        65:73:1c:17:44:0a:1a:83:0a:1b:b5:9d:2a:8a:b8:
        af:bc:22:09:69:9c:f0:27:ed
    publicExponent: 65537 (0x10001)
    privateExponent:
        00:9e:a1:bd:2e:83:c5:4b:73:0d:d3:11:a0:dd:df:
        af:d4:bc:29:59:70:b4:b0:07:38:1b:6b:b2:4f:47:
        68:ba:1e:de:56:bd:a9:00:90:f5:95:6c:2b:7a:ea:
        54:14:8e:c2:03:f2:d5:cd:73:1e:fe:bb:52:c6:a8:
        7a:54:4b:d7:87:41:73:e1:c8:81:09:1b:71:2b:a4:
        29:8d:77:a8:b6:7c:2d:3c:d2:8b:ce:b2:b3:cb:45:
        c6:cd:16:08:52:f3:a1:45:e1:89:3e:a5:3f:14:18:
        02:37:30:d2:e7:e6:c0:73:2d:f8:b9:58:00:51:ca:
        4f:26:fb:bc:28:b3:a4:47:01
    prime1:
        00:f5:86:f1:3f:6f:7f:a6:5b:03:3d:54:8c:b3:ba:
        5b:8a:35:66:29:65:37:2c:5d:42:e8:84:b7:04:94:
        66:2c:df:56:59:73:66:f1:7a:72:39:fa:6f:9e:22:
        24:f1:84:83:67:ab:7a:04:59:04:04:5b:1c:d6:8d:
        d4:0d:98:2d:11
    prime2:
        00:db:a8:8a:21:84:e3:b3:68:b4:b0:35:b2:b0:61:
        ee:13:24:45:49:d9:20:d9:23:04:ef:f5:c6:62:88:
        a5:50:91:12:a6:93:50:e4:dc:98:24:4f:16:66:9a:
        2a:fa:3f:2b:08:3d:c5:5b:38:da:d5:9c:0f:4f:f2:
        d5:e8:96:3d:1d
    exponent1:
        00:8d:a0:e5:90:9e:14:98:35:6f:cc:f4:f4:a4:c8:
        1e:fd:be:87:cb:e1:22:ce:68:8d:ab:ea:c2:57:d5:
        f2:8a:77:da:2b:87:32:1e:a1:6f:3a:9a:87:c0:44:
        19:e3:67:79:15:58:08:ee:71:1a:ac:18:92:ae:00:
        ea:0d:5d:76:c1
    exponent2:
        65:36:b5:df:58:12:6b:ba:d5:77:54:66:ef:eb:4f:
        fe:35:fa:4f:5a:e3:4d:ea:5a:fe:0e:eb:c8:bf:5a:
        1d:53:9b:9a:71:cb:16:89:a6:f9:24:10:18:5a:f5:
        6e:b5:e8:a8:35:7e:58:d8:4b:cd:9d:c9:58:77:76:
        a5:63:84:e9
    coefficient:
        00:f4:10:40:cf:7a:5c:45:91:f1:62:c7:cb:63:c4:
        fa:32:84:e1:7b:4e:5f:f8:cd:ac:8a:6d:27:6d:2e:
        f6:92:1c:3d:ce:56:13:b6:90:ad:1d:a0:82:e9:e2:
        f0:d7:b5:15:4a:ef:a6:ab:ed:40:d0:af:ce:0c:65:
        52:c3:1a:ad:26


如果是DER格式的话,同理应该这样了:

.. code-block:: bash

    openssl rsa -in mykey.key -text -noout -inform der



CSR
------
- Certificate Signing Request,即证书签名请求,这个并不是证书,而是向权威证书颁发机构获得签名证书的申请,其核心内容是一个公钥(当然还附带了一些别的信息),在生成这个申请的时候,同时也会生成一个私钥,私钥要自己保管好.做过iOS APP的朋友都应该知道是怎么向苹果申请开发者证书的吧.

- 创建一个CSR（证书请求）

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


查看的办法:

.. code-block:: bash

    [alvin@poppy ~]$ cat server.csr
    -----BEGIN CERTIFICATE REQUEST-----
    MIIB1jCCAT8CAQAwgZUxCzAJBgNVBAYTAkNOMREwDwYDVQQIDAhTaGFuZ2hhaTER
    MA8GA1UEBwwIU2hhbmdoYWkxEjAQBgNVBAoMCVNvcGhpcm90aDELMAkGA1UECwwC
    SVQxFjAUBgNVBAMMDXBvcHB5LmFsdi5wdWIxJzAlBgkqhkiG9w0BCQEWGGFsdmlu
    Lndhbi5jbkBob3RtYWlsLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA
    0qwVannooXueLAeoGRHQFs4LHCCxdnxBVifJsL3eLznq0m6ELAr8+5bXOGjTpnSH
    JFFklF8aLRUR1cTIbxbTI7/asOrQvzdJ8wMAmL/W41GhQ7I0PqgS+g9P8fvhuVvi
    9hPBaX733VBlcxwXRAoagwobtZ0qirivvCIJaZzwJ+0CAwEAAaAAMA0GCSqGSIb3
    DQEBCwUAA4GBAJqvvaDnriEETbBGWAbwVMiTBkKQ289GVwtxkd06Yx/cC7hskA1D
    6DyKoP7eIvKtLeywtHPxaUmMCDWsopy83Y6NBJV2aoMZUkNamAv9f8b4VYq5hHEs
    Z8+9E4ooG9J9Z6ylBz2WM/Lt6V/yPmRjGjW2COOUcUZd96lfKntFlFUL
    -----END CERTIFICATE REQUEST-----
    [alvin@poppy ~]$
    [alvin@poppy ~]$ openssl req -noout -text -in server.csr    #(如果是DER格式的话照旧加上-inform der,这里不写了)
    Certificate Request:
        Data:
            Version: 0 (0x0)
            Subject: C=CN, ST=Shanghai, L=Shanghai, O=Sophiroth, OU=IT, CN=poppy.alv.pub/emailAddress=alvin.wan.cn@hotmail.com
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (1024 bit)
                    Modulus:
                        00:d2:ac:15:6a:79:e8:a1:7b:9e:2c:07:a8:19:11:
                        d0:16:ce:0b:1c:20:b1:76:7c:41:56:27:c9:b0:bd:
                        de:2f:39:ea:d2:6e:84:2c:0a:fc:fb:96:d7:38:68:
                        d3:a6:74:87:24:51:64:94:5f:1a:2d:15:11:d5:c4:
                        c8:6f:16:d3:23:bf:da:b0:ea:d0:bf:37:49:f3:03:
                        00:98:bf:d6:e3:51:a1:43:b2:34:3e:a8:12:fa:0f:
                        4f:f1:fb:e1:b9:5b:e2:f6:13:c1:69:7e:f7:dd:50:
                        65:73:1c:17:44:0a:1a:83:0a:1b:b5:9d:2a:8a:b8:
                        af:bc:22:09:69:9c:f0:27:ed
                    Exponent: 65537 (0x10001)
            Attributes:
                a0:00
        Signature Algorithm: sha256WithRSAEncryption
             9a:af:bd:a0:e7:ae:21:04:4d:b0:46:58:06:f0:54:c8:93:06:
             42:90:db:cf:46:57:0b:71:91:dd:3a:63:1f:dc:0b:b8:6c:90:
             0d:43:e8:3c:8a:a0:fe:de:22:f2:ad:2d:ec:b0:b4:73:f1:69:
             49:8c:08:35:ac:a2:9c:bc:dd:8e:8d:04:95:76:6a:83:19:52:
             43:5a:98:0b:fd:7f:c6:f8:55:8a:b9:84:71:2c:67:cf:bd:13:
             8a:28:1b:d2:7d:67:ac:a5:07:3d:96:33:f2:ed:e9:5f:f2:3e:
             64:63:1a:35:b6:08:e3:94:71:46:5d:f7:a9:5f:2a:7b:45:94:
             55:0b

CRT
--------
- CRT应该是certificate的三个字母,其实还是证书的意思,常见于*NIX系统,有可能是PEM编码,也有可能是DER编码,大多数应该是PEM编码,相信你已经知道怎么辨别.

使用上面的密钥和CSR对证书进行签名

- 以下命令生成v1版证书
    这里我们用v1版本的就好了。

.. code-block:: bash

    $ openssl x509 -req  -days 365 -sha256   -in server.csr -signkey server.key -out server.crt

当我们访问一个自签名证书的网站时，需要添加信任对方的证书，添加的就是这个server.crt文件，下面的操作中，poppy.alv.pub 已经将证书配置到了自己的nginx服务里，使用443端口提供服务了。

参考下面的操作：


.. code-block:: bash

    [alvin@poppy ~]$ scp server.crt saltstack:/tmp/   #将证书传递给客户端
    [alvin@saltstack ~]$ sudo bash -c 'cat /tmp/server.crt  >> /etc/ssl/certs/ca-bundle.crt '
    [alvin@saltstack ~]$ curl   https://poppy.alv.pub
    this is poppy

CER
------
- 还是certificate,还是证书,常见于Windows系统,同样的,可能是PEM编码,也可能是DER编码,大多数应该是DER编码.



PFX/P12
----------
- predecessor of PKCS#12,对*nix服务器来说,一般CRT和KEY是分开存放在不同文件中的,但Windows的IIS则将它们存在一个PFX文件中,(因此这个文件包含了证书及私钥)这样会不会不安全？应该不会,PFX通常会有一个"提取密码",你想把里面的东西读取出来的话,它就要求你提供提取密码,PFX使用的时DER编码,如何把PFX转换为PEM编码？

.. code-block:: bash

    openssl pkcs12 -in for-iis.pfx -out for-iis.pem -nodes

这个时候会提示你输入提取代码. for-iis.pem就是可读的文本.

生成pfx的命令类似这样:

.. code-block:: bash

    openssl pkcs12 -export -in certificate.crt -inkey privateKey.key -out certificate.pfx -certfile CACert.crt

其中CACert.crt是CA(权威证书颁发机构)的根证书,有的话也通过-certfile参数一起带进去.这么看来,PFX其实是个证书密钥库.

JKS
-----
- 即Java Key Storage,这是Java的专利,跟OpenSSL关系不大,利用Java的一个叫"keytool"的工具,可以将PFX转为JKS,当然了,keytool也能直接生成JKS,不过在此就不多表了.

证书编码的转换
=====================

PEM转为DER

.. code-block:: bash

    openssl x509 -in cert.crt -outform der -out cert.der

DER转为PEM

.. code-block:: bash

    openssl x509 -in cert.crt -inform der -outform pem -out cert.pem

(提示:要转换KEY文件也类似,只不过把x509换成rsa,要转CSR的话,把x509换成req...)

获得证书
=================

向权威证书颁发机构申请证书

用这命令生成一个csr:

.. code-block:: bash

    openssl req -newkey rsa:2048 -new -nodes -keyout my.key -out my.csr

把csr交给权威证书颁发机构,权威证书颁发机构对此进行签名,完成.保留好csr,当权威证书颁发机构颁发的证书过期的时候,你还可以用同样的csr来申请新的证书,key保持不变.

或者生成自签名的证书
==========================
.. code-block:: bash

    openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem

在生成证书的过程中会要你填一堆的东西,其实真正要填的只有Common Name,通常填写你服务器的域名,如"yourcompany.com",或者你服务器的IP地址,其它都可以留空的.

生产环境中还是不要使用自签的证书,否则浏览器会不认,或者如果你是企业应用的话能够强制让用户的浏览器接受你的自签证书也行.向权威机构要证书通常是要钱的,但现在也有免费的,仅仅需要一个简单的域名验证即可.有兴趣的话查查"沃通数字证书".