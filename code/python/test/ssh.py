#coding:utf-8

import paramiko
# # # 远程登陆操作系统
# def ssh(sys_ip, username, password,port,cmds):
#     try:
#         # 创建ssh客户端
#         client = paramiko.SSHClient()
#         # 第一次ssh远程时会提示输入yes或者no
#         client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         # 密码方式远程连接
#         client.connect(sys_ip, port, username=username, password=password, timeout=20)
#         # 互信方式远程连接
#         # key_file = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")
#         # ssh.connect(sys_ip, 22, username=username, pkey=key_file, timeout=20)
#         # 执行命令
#         stdin, stdout, stderr = client.exec_command(cmds)
#         # 获取命令执行结果,返回的数据是一个list
#         result = stdout.readlines()
#         return result
#     except Exception as e:
#         print (e)
#         pass
#     finally:
#         client.close()
# #
#

    # print (ssh(sys_ip, username, password,port,'ls /tmp'))



def ssh(host, username, password,port,cmds):
    try:
        # 创建ssh客户端
        client = paramiko.SSHClient()
        # 第一次ssh远程时会提示输入yes或者no
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        # 密码方式远程连接
        client.connect(host, port, username=username, password=password, timeout=20)
        # 互信方式远程连接
        # key_file = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")
        # ssh.connect(sys_ip, 22, username=username, pkey=key_file, timeout=20)
        # 执行命令
        stdin, stdout, stderr = client.exec_command(cmds)
        print(dir(client.exec_command(cmds)))
        # 获取命令执行结果,返回的数据是一个list
        result = stdout.readlines()
        return result
    except Exception as e:
        print (e)
        pass
    finally:
        client.close()


def check_host(request):
        host = request['host']
        username = request['username']
        password = request['password']
        port = request['port']
        # def start_check(cmd):
        #     return ssh(host,username,password,port,cmd)
        # result=start_check('hostname')
        result=ssh('192.168.127.252', 'root', 'sophiroth', '22', 'echo hello')
        return ({'success': False, 'code': 0, 'message': result})


request={"username": "root", "host": "192.168.127.252", "password": "sophiroth", "port": "22"}
check_host(request)


# if __name__ == "__main__":
#     # sys_ip = "192.168.127.252"
#     # username = "root"
#     # password = "sophiroth"
#     # cmds = "hostname"
#     # port= '22'
#     # result= (ssh(sys_ip, username, password,port,'hostname'))
#     # print(result)
#         result=ssh('192.168.127.252', 'root', 'sophiroth', '22', 'hostname')
#         print(result)
