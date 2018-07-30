saltstack agent
########################

这里我们的salt master的IP地址是192.168.127.59.

.. code-block:: bash

    yum install epel-release -y
    yum install salt-minion -y
    salt_master_ip=192.168.127.59
    echo "master: $salt_master_ip" > /etc/salt/minion
    systemctl start salt-minion
    systemctl enable salt-minion

