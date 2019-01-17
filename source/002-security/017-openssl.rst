openssl
##############

我们在平时的 Linux 运维管理的时候，经常会进行各种数据备份任务。将数据导出然后打包。通常在安全性要求比较高的环境下，我们可以借助 OpenSSL 工具对打包后的数据进行加密，这样能进一步的保障数据的安全性。




用openssl加密一个文件
=========================

-aes256是加密方式  -in 表示指定原文件  -out 表示加密之后生成的文件 enc  表示对文件进行对称加密或解密，

.. code-block:: bash

    [root@common ~]# openssl enc -e -aes256 -in 1.sh -out 1.sh.bak
    enter aes-256-cbc encryption password:
    Verifying - enter aes-256-cbc encryption password:


解密一个openssl加密的文件
=================================


-d 表示对文件进行解密操作。

.. code-block:: bash

    [root@common ~]# openssl enc -d -aes256 -in 1.sh.bak -out new_1.sh
    enter aes-256-cbc decryption password:



生成一个可用于系统密码的密码密文
======================================

.. code-block:: bash

    openssl passwd -1



OpenSSL 使用密钥方式加密或解密文件
============================================


1. 首先需要使用 openssl 生成一个 2048 位的密钥 rsa.key 文件 (rsa.key 密钥文件中包含了私钥和公钥)


::

    # openssl genrsa -out rsa.key 2048


2. 然后从 rsa.key 密钥文件中提取出公钥 pub.key

::

    # openssl rsa -in rsa.key -pubout -out pub.key

3. 使用 pub.key 公钥加密一个文件 (data.zip 为原始文件，back.zip 为加密之后的文件)

::

    # openssl rsautl -encrypt -inkey pub.key -pubin -in data.zip -out back.zip

4. 使用 rsa.key 私钥解密一个文件 (back.zip 为加密的文件，data.zip 为解密之后的文件)

::

    # openssl rsautl -decrypt -inkey rsa.key -in back.zip -out data.zip
