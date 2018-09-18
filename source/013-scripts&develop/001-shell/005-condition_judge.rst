条件判断
###########

字符串判断：
========================

[ ]  -注意，中括号内部参数的两侧距离中括号都要有空格

[ string1 == string2 ]  表示判断两个字符串是否相同

    ::

        [root@leopard test]# [ uplook == uplook ]
        [root@leopard test]# echo $?
        0
        [root@leopard test]# [ uplook == uplooking ]
        [root@leopard test]# echo $?
        1

[ string1 != string2 ]  表示判断两个字符串是否不相同

    ::

        [root@leopard test]# [ uplook == uplooking ]
        [root@leopard test]# echo $?
        1
        [root@leopard test]# [ uplook != uplooking ]
        [root@leopard test]# echo $?
        0


[ string ]	判断字符串是否不为空

    ::

        [root@leopard test]# [ uplook ]
        [root@leopard test]# echo $?
        0
        [root@leopard test]# [ ]
        [root@leopard test]# echo $?
        1



[ -z string ] 判断字符串长度是否为零

    ::

        [root@leopard test]# [ -z  ]
        [root@leopard test]# echo $?
        0
        [root@leopard test]# [ -z uplook ]
        [root@leopard test]# echo $?
        1

[ -n string ] 判断字符串长度是否不为零

    ::

        vim /test/test.sh
        STR4=
             [ -n "$STR4" ]						--注意引用空的变量加上双引号
               echo $?
               echo $STR4



-a  [ expr1 -a expr2 ]			--两个条件都要成立
-o  [ expr1 -o expr2 ]			--两个条件成立一个就行


!  [ ! expr ]					--取反


*************************************************************************************************************

整数判断,两值比较:
===============================



			[ arg1 OP arg2 ]              --OP is one of -eq, -ne, -lt, -le, -gt, or -ge.

				-eq  	equal     			==        	# 等于
				-ne 		not equal    		 !=        	# 不等于
				-lt  		less than   		<         	# 小于
				-le  		less and equal 		<=        	# 小于或等于
				-gt  		greater than     	>         	# 大于
				-ge  	greater and equal   	>=        	# 大于或等于


*************************************************************************************************************

文件的判断：
==================

		-a 	file 如果文件存在，那么为真
		-b 	file 文件存在，并且是块设备文件
		-c 	file 文件存在，并且是字符设备文件
		-d 	file 文件存在，并且是目录文件
		-e 	file 文件存在，为真
		-f 	file 文件存在，为普通文件
		-g 	file 文件存在，并且设置了SGID权限
		-h 	file 文件存在，并且是符号链接文件
		-k 	file 文件存在，并且设置了粘贴位
		-p 	file 文件存在，并且是管道文件
		-r 	file 文件存在，如果可读，为真
		-s 	file 文件存在，如果文件大小大于零，为真
		-t 	fd  # fd 是否是个和终端相连的打开的文件描述符（fd 默认为 1）
		-u 	file 文件存在，并且设置SUID
		-w 	file 文件存在，并且可写
		-x 	file 文件存在，并且可执行
		-O 	file 文件存在，并且这个文件是被用户有效id所拥有的
		-G 	file 文件存在，并且这个文件是被用户的有效Gid所拥有的
		-L 	file 文件存在，并且是符号链接文件
		-S 	file 文件存在，是socket文件
		-N 	file 文件存在，从上一次被读之后，被修改过

************************************************************************************************************************

[[ ]]		--双方括号(double brackets) 支持正则的条件判断，也称模式匹配


        [[ patten1 &&p atten2 ]]

    ::

        if [[ xyz =~ x[a|y]z ]]
        then
            echo "It is same"
        else
            echo "not same"
        fi
        或
        $STR=xyz
        if [[ "$STR" =~ x[a|y]z ]]

        then
            echo "It is same"
        else
            echo "not same"
        fi
