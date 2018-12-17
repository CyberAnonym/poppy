python字符串
##################

参考资料： http://www.runoob.com/python/python-strings.html



format
==========
定义变量传参

::

    print("网站名：{name}, 地址 {url}".format(name="Sophiroth", url="sophiroth.com"))


使用字典参数

::

    weather_dict4={}
    weather_dict4['high']='33'
    weather_dict4['low']='10'
    print('{high},{low})'.format(**weather_dict4))


split
============

以':' 为分隔，打印最后一个索引的数据

::

    a='52:54:00:d9:94:10'

    print(a.split(':')[-1])