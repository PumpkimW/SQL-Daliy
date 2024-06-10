--题目来源
--SQL263 牛客每个人最近的登录日期(四)
--https://www.nowcoder.com/share/jump/5181271201717770815042

--问题描述
牛客每天有很多人登录，请你统计一下牛客每个日期登录新用户个数，
有一个登录(login)记录表，简况如下:
drop table if exists login;
CREATE TABLE `login` (
`id` int(4) NOT NULL,
`user_id` int(4) NOT NULL,
`client_id` int(4) NOT NULL,
`date` date NOT NULL,
PRIMARY KEY (`id`));

INSERT INTO login VALUES
(1,2,1,'2020-10-12'),
(2,3,2,'2020-10-12'),
(3,1,2,'2020-10-12'),
(4,2,2,'2020-10-13'),
(5,1,2,'2020-10-13'),
(6,3,1,'2020-10-14'),
(7,4,1,'2020-10-14'),
(8,4,1,'2020-10-15');

第1行表示user_id为2的用户在2020-10-12使用了客户端id为1的设备登录了牛客网，因为是第1次登录，所以是新用户
。。。
第4行表示user_id为2的用户在2020-10-13使用了客户端id为2的设备登录了牛客网，因为是第2次登录，所以是老用户
。。
最后1行表示user_id为4的用户在2020-10-15使用了客户端id为1的设备登录了牛客网，因为是第2次登录，所以是老用户
--SQL问题
请你写出一个sql语句查询每个日期登录新用户个数，并且查询结果按照日期升序排序，上面的例子查询结果如下:
date	new
2020-10-12	3
2020-10-13	0
2020-10-14	1
2020-10-15	0

--查询结果表明:
2020-10-12，有3个新用户(user_id为2，3，1)登录
2020-10-13，没有新用户登录
2020-10-14，有1个新用户(user_id为4)登录
2020-10-15，没有新用户登录

--解答SQL代码如下
--方法一

select 
	t.date
	,sum(case when t.new_flag=1 then 1 else 0 end) as new
from (
	select
		log.*
		,count(user_id) over(partition by user_id order by date) as new_flag
	from login log 
) t 
group by t.date
order by date
;


--方法二

select 
	t1.date
	,sum(case when t2.user_id is not null then 1 else 0 end) as new
from(
	select 
		log.user_id
		,log.date
	from login log 
	group by log.user_id, log.date
) t1
left join (
	select 
		log.user_id
		,min(date) as min_log_date
	from login log 
	group by log.user_id
) t2 
on t1.user_id = t2.user_id
and t1.date = t2.min_log_date
group by t1.date
order by t1.date
;


--方法三【不推荐】
select 
    t1.date
    ,sum(case when t2.user_id is not null then 1 else 0 end) as new
from login t1
left join (
    select 
        log.user_id
        ,min(date) as min_log_date
    from login log 
    group by log.user_id
) t2 
on t1.user_id = t2.user_id
and t1.date = t2.min_log_date
group by t1.date
order by t1.date
;



