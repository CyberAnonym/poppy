while
#######

while是只要符合条件就执行，执行完毕之后再判断是否符合条件，符合条件继续执行，一直循环重复，直到有退出指令。

.. code-block:: bash

    [alvin@poppy ~]$ vim while.sh
    [alvin@poppy ~]$ chmod +x while.sh
    [alvin@poppy ~]$ cat while.sh
    #!/bin/bash


    name='alvin'

    while [ $name == 'alvin' ]
    do
        echo name is $name
        sleep 1
    done
    [alvin@poppy ~]$ ./while.sh
    name is alvin
    name is alvin
    name is alvin
    name is alvin
    name is alvin
    ^C
