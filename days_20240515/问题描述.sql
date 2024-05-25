牛客每天有很多人登录，请你统计一下牛客每个日期新用户的次日留存率。
有一个登录(login)记录表，简况如下


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


查询结果表明:
2020-10-12登录了3个(user_id为2，3，1)新用户，2020-10-13，只有2个(id为2,1)登录，故2020-10-12新用户次日留存率为2/3=0.667;
2020-10-13没有新用户登录，输出0.000;
2020-10-14登录了1个(user_id为4)新用户，2020-10-15，user_id为4的用户登录，故2020-10-14新用户次日留存率为1/1=1.000;
2020-10-15没有新用户登录，输出0.000;
(注意:sqlite里查找某一天的后一天的用法是:date(yyyy-mm-dd, '+1 day')，sqlite里1/2得到的不是0.5，得到的是0，只有1*1.0/2才会得到0.5)



select 
    s1.date
    ,case when count(s2.user_id) = 0 then 0.000
          else
            round(count(distinct case when new_flag = 1 then s2.user_id else null end) / count(distinct case when new_flag = 1 then s1.user_id else null end),3)
    end as p
from(
	select
		t1.user_id,t1.date
		,case when t2.user_id is null then 1 else 0 end as new_flag
	from login t1 
	left join login t2 
	on t1.user_id = t2.user_id
	and t1.date > t2.date
	group by t1.user_id,t1.date
) s1 
left join login s2
on s1.user_id = s2.user_id
and s1.date + INTERVAL 1 DAY = s2.date
group by s1.date
;


select t0.date,
ifnull(round(count(distinct t2.user_id)/(count(t1.user_id)),3),0)
from
(
    select date
    from login
    group by date
) t0
left join
(
    select user_id,min(date) as date
    from login
    group by user_id
)t1
on t0.date=t1.date
left join login as t2
on t1.user_id=t2.user_id and datediff(t2.date,t1.date)=1
group by t0.date
;


SELECT 
date,
IFNULL(
	ROUND(
	SUM(CASE WHEN 
			(user_id,date) IN (SELECT user_id,DATE_ADD(date,INTERVAL -1 DAY) FROM login)
			AND (user_id,date) IN (SELECT user_id,MIN(date) FROM login GROUP BY user_id)
			THEN 1 
		ELSE 0 END)
	/

	SUM(CASE WHEN 
			(user_id,date) IN (SELECT user_id,MIN(date) FROM login GROUP BY user_id)
			THEN 1 
		ELSE 0 END)
	,3)
,0) AS p

FROM login
GROUP BY date
ORDER BY date
;

