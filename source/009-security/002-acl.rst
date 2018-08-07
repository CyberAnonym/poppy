acl
############

acl - Access Control Lists


查看ACL
=============

.. code-block:: bash

    getfacl file  ##查看file的ACL设置 。 对查看文件和目录的ACL，都用getfacl

针对用户给文件或目录设置ACL
==================================

.. code-block:: bash

    setfacl -m u:user1:rwx file  ##对file 设置ACL，让user1对他拥有rwx权限，也就是全部的权限。

- 将user1对 file的权限改成只读

.. code-block:: bash

    setfacl -m u:user1:r file
    getfacl file

针对组给文件设置ACL
===========================

.. code-block:: bash

    setfacl -m g:it:rwx dir1   ## 对dir1 目录设置ACL，让it 组拥有对这个目录的所有权限。

删除acl
--------------------
-x 是删除。

删除上面这条acl

.. code-block:: bash

    getfacl dir1
    setfacl -x g:it dir1
