
sed （stream editor）
#############################


.. contents::

将153和158行的#替换为空。
``````````````````````````

.. code-block:: bash

    sed -in '153,158s/#//' $Setfiles

使用前面匹配到的内容
`````````````````````````

匹配替换时，&会变成起那么匹配到的内容，所以在下面的例子中，我们前面匹配所有内容，然后替换为#&就是#加上所有内容。

.. code-block:: bash

    sed -in '160,164s/.*/#&/' $Setfiles

替换换行符为+
``````````

这里我们将所有行合并了，将换行符替换成了+号。

.. code-block:: bash

    sed ':a;N;s/\n/+/g;ta' 1.txt

匹配行前或后增加指定内容
````````````````````````

a是append， 在匹配行后面增加一行指定内容，下面是在file文件里在匹配到aa的行的后面增加内容qqq

.. code-block:: bash

    sed -i /aa/a\qqq file

i是insert， 在匹配行前面插入一行指定内容，下面是在file文件里在匹配到aa的行的前面增加内容qqq

.. code-block:: bash

    sed -i /aa/i\qqq file


删除文件 text中第一列
````````````````````````

.. code-block:: bash

    sed -e 's/[^ ]* //' text

