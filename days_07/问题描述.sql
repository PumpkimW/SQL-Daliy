
描述
现在有一个需求，让你统计正常用户发送给正常用户邮件失败的概率:
有一个邮件(email)表，id为主键， type是枚举类型，枚举成员为(completed，no_completed)，completed代表邮件发送是成功的，no_completed代表邮件是发送失败的。简况如下:


drop table if exists email;
drop table if exists user;
CREATE TABLE `email` (
`id` int(4) NOT NULL,
`send_id` int(4) NOT NULL,
`receive_id` int(4) NOT NULL,
`type` varchar(32) NOT NULL,
`date` date NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `user` (
`id` int(4) NOT NULL,
`is_blacklist` int(4) NOT NULL,
PRIMARY KEY (`id`));

INSERT INTO email VALUES
(1,2,3,'completed','2020-01-11'),
(2,1,3,'completed','2020-01-11'),
(3,1,4,'no_completed','2020-01-11'),
(4,3,1,'completed','2020-01-12'),
(5,3,4,'completed','2020-01-12'),
(6,4,1,'completed','2020-01-12');

INSERT INTO user VALUES
(1,0),
(2,1),
(3,0),
(4,0);


第1行表示id为1的是正常用户;
第2行表示id为2的不是正常用户，是黑名单用户，如果发送大量邮件或者出现各种情况就会容易发送邮件失败的用户
...
第4行表示id为4的是正常用户

现在让你写一个sql查询，每一个日期里面，正常用户发送给正常用户邮件失败的概率是多少，结果保留到小数点后面3位(3位之后的四舍五入)，
并且按照日期升序排序，上面例子查询结果如下:


date	p
2020-01-11 0.500
2020-01-12 0.000

结果表示:
2020-01-11失败的概率为0.500，因为email的第1条数据，发送的用户id为2是黑名单用户，所以不计入统计，正常用户发正常用户总共2次，但是失败了1次，所以概率是0.500;
2020-01-12没有失败的情况，所以概率为0.000.
(注意: sqlite 1/2得到的不是0.5，得到的是0，只有1*1.0/2才会得到0.5，sqlite四舍五入的函数为round)


--答案

select 
	date
	,round(1.0 * sum(case when e.type='no_completed' then 1 else 0 end) /count(1),3) as p
from email e
join (select * from user where is_blacklist=0) u 
on e.send_id = u.id 
join (select * from user where is_blacklist=0) u2
on e.receive_id = u2.id 
group by date
order by date
;