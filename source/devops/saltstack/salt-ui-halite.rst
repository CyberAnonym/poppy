Salt-UI-halite
####################
这里我们将该服务部署在saltstack.alv.pub上。

salt-ui halite 的安装
--------------------------

- 先安装apache和git

.. code-block:: bash

    yum install httpd git -y


- 然后clone halite的github

.. code-block:: bash

    cd /var/www/
    clone https://github.com/saltstack/halite
    cd halite/halite
    ./genindex.py -C


- 然后添加salt用户,并设置密码，这里我设置密码为salt

.. code-block:: bash

    useradd -s /sbin/nologin salt
    echo sallt|passwd salt --stdin

配置salt-ui halite
------------------------

- 然后编写配置文件

.. code-block:: bash

    # mkdir -p /etc/salt/master.d/
    # vim /etc/salt/master.d/saltui.conf
    rest_cherrypy:
    host: 0.0.0.0
    port: 8080
    debug: true
    disable_ssl: True
    static: /var/www/halite/halite
    app: /var/www/halite/halite/index.html

    external_auth:
      pam:
        salt:
        - .*
        - '@runner'
        - '@wheel'


- 添加用户及增加配置文件后，重启salt-master。


.. code-block:: bash

    # systemctl restart salt-master

- 然后启动WEB也就是Salt-UI, 这里我们用nohup让其再后台执行，并将输入日志重定向到/tmp/salt-ui.log。


.. code-block:: bash

    # cd /var/www/halite/halite
    # nohup python server_bottle.py -d -C -l debug -s cherrypy &>/tmp/salt-ui.log &

访问
-------

- 然后就可以通过去浏览器访问了。

url: http://saltstack.alv.pub:8080/