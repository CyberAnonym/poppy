userdel
############

用户删除
=======================

用户删除的命令是userdel， 加-r ，会将 用户的home目录，和邮件等内容也全部删除，不加-r，则会保存那些数据

- 默认用户的家目录不删除

.. code-block:: bash

    [root@poppy ~]# userdel user1

- 删除用户的同时删除用户的家目录以及mail相关信息

.. code-block:: bash

    [root@poppy ~]# userdel -r user3

