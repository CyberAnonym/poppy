shutil
##########


chutil.copy(source, destination)

shutil.copy() 函数实现文件复制功能，将 source 文件复制到 destination 文件夹中，两个参数都是字符串格式。如果 destination 是一个文件名称，那么它会被用来当作复制后的文件名称，即等于 复制 + 重命名。举例如下：

::

    >> import shutil
    >> import os
    >> os.chdir('C:\')
    >> shutil.copy('C:\spam.txt', 'C:\delicious')
    'C:\delicious\spam.txt'
    >> shutil.copy('eggs.txt', 'C:\delicious\eggs2.txt')
    'C:\delicious\eggs2.txt'

如代码所示，该函数的返回值是复制成功后的字符串格式的文件路径


shutil.copytree(source, destination)

shutil.copytree()函数复制整个文件夹，将 source 文件夹中的所有内容复制到 destination 中，包括 source 里面的文件、子文件夹都会被复制过去。两个参数都是字符串格式。

注意，如果 destination 文件夹已经存在，该操作并返回一个 FileExistsError 错误，提示文件已存在。即表示，如果执行了该函数，程序会自动创建一个新文件夹（destination参数）并将 source 文件夹中的内容复制过去
举例如下：

::

    >> import shutil
    >> import os
    >> os.chdir('C:\')
    >> shutil.copytree('C:\bacon', 'C:\bacon_backup')
    'C:\bacon_backup'