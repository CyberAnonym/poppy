case
#####

case的语法

.. code-block:: bash

    [alvin@poppy ~]$ cat case.sh
    #!/bin/bash

    #name='alvin'
    name='ophira'

    case $name in

        'alvin')
            echo 'alvin'
        ;;
        'ophira')
            echo 'ophira'
        ;;
        *)
        echo nothing
    esac

    [alvin@poppy ~]$ ./case.sh
    ophira

