passwd
###########


设置或修改系统用户密码
==============================

.. code-block:: bash

    [root@poppy ~]# passwd poppy
    Changing password for user poppy.
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.



用户自己修改
=====================
输入旧密码验证，然后输入新密码，设置新密码

.. code-block:: bash
    :linenos:
    :emphasize-lines: 1,4,5

    [poppy@poppy ~]$ passwd
    Changing password for user poppy.
    Changing password for poppy.
    (current) UNIX password:
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.

非交互式修改密码
=========================
将poppy用户的密码设置为alvin

.. code-block:: bash

    [root@poppy ~]# echo alvin|passwd --stdin poppy
    Changing password for user poppy.
    passwd: all authentication tokens updated successfully.