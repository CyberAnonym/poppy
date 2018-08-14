sphinx
############

安装sphinx
==================

.. code-block:: bash

    $ sudo pip install rst
    $ sudo pip instal sphinx
    $ sudo pip install sphinx_rtd_theme

创建一个sphinx项目
============================
下面的命令会自动生成一个默认的Sphinx模板

.. code-block:: bash

    mkdir yourdir
    cd yourdir
    sphinx-quickstart

执行期间，它会一步步的询问对模板的设置，除了一些必须填写的选项，大部分填写默认值就行了，你会遇到这样一条叫autodoc的，需要选择yes

.. code-block:: bash

    - yourdir/ # 刚才新建的目录
        - source/ # 存放Sphinx工程源码
        - build/ # 存放生成的文档
        Makefile

现在执行如下指令，就会生成一份空文档，存放在/build/html里，点击index.html就可以打开一个空的网页，虽然没有内容，但是整体的结构还是在的

.. code-block:: bash

    sphinx-build -b html source build
    make html

sphinx编写语法
=====================

.. note:: 做主目录数用的toctree和其下面的参数

     ..toctree
          :glob:      #开启正则可以*匹配
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




.. note:: 自动生成文档注释

   sphinx支持从python源代码中提取文档注释信息，然后生成文档，我们将这称之为autodoc。

   为了使用autodoc，首先需要在配置文件的extensions选项中添加'sphinx.ext.autodoc'。然后我们就可以使用autodoc的指令了。这里我们生成subprocess的注释。

   ..automodule:: subprocess
        :members:


.. autofunction:: subprocess.call


This is a paragraph that contsains `a link`_

.. _a link: http://example.com/


