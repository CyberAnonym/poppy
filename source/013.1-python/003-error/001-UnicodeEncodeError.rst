UnicodeEncodeError
#######################

python 编码问题 UnicodeEncodeError: 'ascii' codec can't encode characters in position 37-40
==============================================================================================================


对于一个url连接例如”https://www.sojson.com/open/api/weather/json.shtml?city=上海市”这样一个链接，如果直接

用urlopen读取会报错：

::

    UnicodeEncodeError: 'ascii' codec can't encode characters in position 37-40: ordinal not in range(128)


解决：

解决办法就是使用urllib.parse.quote()解析中文部分。

::

    weather_url='https://www.sojson.com/open/api/weather/json.shtml?city=%s'%(urllib.parse.quote('上海'))


也可以使用safe参数指定不解析的字符

::

    city='上海'
    weather_url=urllib.parse.quote('https://www.sojson.com/open/api/weather/json.shtml?city=%s'%city,safe='/:?=.')

指定’/:?=.’这些符号不转换


python3版本可以用上述办法，但python2版本则不行，python2版本可以用urllib2来处理url， 使用以下命令解决那个中文问题。

::

    import sys
    reload(sys)
    sys.setdefaultencoding('utf-8')
