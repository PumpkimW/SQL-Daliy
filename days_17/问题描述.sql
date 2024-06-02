--题目来源
--SQL262 牛客每个人最近的登录日期(三)
--https://www.nowcoder.com/share/jump/5181271201717298863765

--问题描述
牛客每天有很多人登录，请你统计一下牛客新登录用户的次日成功的留存率，
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
(5,4,1,'2020-10-13'),
(6,1,2,'2020-10-13'),
(7,1,2,'2020-10-14');

第1行表示user_id为2的用户在2020-10-12使用了客户端id为1的设备第一次新登录了牛客网
。。。
第4行表示user_id为2的用户在2020-10-12使用了客户端id为2的设备登录了牛客网
。。。
最后1行表示user_id为1的用户在2020-10-14使用了客户端id为2的设备登录了牛客网

--SQL问题
请你写出一个sql语句查询新登录用户次日成功的留存率，即第1天登陆之后，第2天再次登陆的概率,保存小数点后面3位(3位之后的四舍五入)，上面的例子查询结果如下:
p
0.500
查询结果表明:
user_id为1的用户在2020-10-12第一次新登录了，在2020-10-13又登录了，算是成功的留存
user_id为2的用户在2020-10-12第一次新登录了，在2020-10-13又登录了，算是成功的留存
user_id为3的用户在2020-10-12第一次新登录了，在2020-10-13没登录了，算是失败的留存
user_id为4的用户在2020-10-13第一次新登录了，在2020-10-14没登录了，算是失败的留存
故次日成功的留存率为 2/4=0.5
(sqlite里查找某一天的后一天的用法是:date(yyyy-mm-dd, '+1 day')，四舍五入的函数为round，sqlite 1/2得到的不是0.5，得到的是0，只有1*1.0/2才会得到0.5
mysql里查找某一天的后一天的用法是:DATE_ADD(yyyy-mm-dd,INTERVAL 1 DAY)，四舍五入的函数为round)


--解答SQL代码如下

select 
	round(count(t2.user_id) / count(1) , 3) as p
from(
	select 
		user_id
		,min(date) as min_date
	from login
	group by user_id
) t1 
left join login t2 
on t1.user_id = t2.user_id
and t2.date = DATE_ADD(t1.min_date,INTERVAL 1 DAY)
;
