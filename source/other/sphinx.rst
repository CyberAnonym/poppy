sphinx
############

sphinx编写语法
=====================

.. note:: 做主目录数用的toctree和其下面的参数

     ..toctree
          :maxdepth: 2 #最大展开2层
          :numbered:  #生成编号
          :caption: Contents: （Centents是我们写在这里的内容，我们写什么，目录上面的标题就是什么）

.. note:: code-block 代码块下面的参数

     ..code-block:: bash
          :linenos: #展示行号
          :emphasize-lines: 2 #指定第2行高亮


.. note:: 代码包含，引用脚本文件里的代码

    ..literalinclude:: ../../../code/install_python3.6.5.py  #脚本的路径
          :language: python  #脚本使用的语言
          :linenos: #展示行号
          :lines: 1,3,5-10,20- #指定显示那些行，这里指定第1行，第3行，第5指10行，和20行之后的内容显示，其他内容不显示




