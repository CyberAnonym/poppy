requests
#############

python获取http返回状态码
================================


>>> import requests
>>> response = requests.get("http://www.baidu.com")
>>> print response.status_code
200