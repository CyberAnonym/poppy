lynis
##########


安装lynis
###############

.. code-block:: bash

    yum --enablerepo=epel -y install lynis


扫描系统安全隐患
######################


.. code-block:: bash

    lynis audit system


.. code-block:: bash

    lynis --check-all