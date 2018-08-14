select
##########


- 查询指定班级的每个学员指定数据情况，用到了多表查询，format格式化数据为指定小数位吗，concat字符串拼接。

::

    SELECT

        t1.realname 姓名,
        FORMAT(
            (
                cur_weight_num - init_weight_num
            ) * 2,
            2
        ) 累计减重, diet_days 饮食记录,
        day_coin 每日预算,
        CONCAT(cast(
            format(
                (
                    (
                        init_weight_num - cur_weight_num
                    ) / init_weight_num
                ) * 100,
                1
            ) AS CHAR
        ),'%') 减重百分比,t1.bmi 最新BMI,t1.mobile 手机号 ,t2.weight_day 日期,t2.BMI 当前日期MBI
    FROM
        t_user t1,t_user_weight t2
    WHERE
        t1.clazz_id = 121 and t1.id =t2.user_id  and t1.cur_weight_num=t2.weight_num
    ORDER BY
        t1.id DESC



- 查询指定班级每个人的记录细节

::

    SELECT t2.realname 姓名,t1.weight_day 日期,FORMAT(t1.weight_num,1) '体重(kg)',t1.total_fat_num '总体脂肪量(%)',t1.muscle_num 肌肉量,t1.bmi MBI,t1.physical_age 生理年龄,water_num '水分(%)',t1.inner_fat_num 内脂 FROM t_user_weight t1,t_user t2 where t2.clazz_id = 121 and t2.id = t1.user_id order by t2.realname,t1.weight_day desc