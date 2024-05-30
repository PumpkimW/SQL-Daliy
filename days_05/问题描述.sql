现在有代码提交(submission)表简况如下：
id	subject_id	create_time
1	2	2999-02-11
2	2	2999-02-21
3	1	2999-02-21
4	1	2999-02-22
5	3	2999-02-22
6	2	2999-02-22
7	2	2999-02-22

第一行表示：某个用户在2999-02-11号在题单2提交了一次代码
。。。。
最后一行表示：某个用户在2999-02-22号在题单2提交了一次代码

现在有题单(subject)表简况如下:
id	name
1	jzoffer
2	tiba
3	huaweijishu
4	top101
第一行表示:题单id为1的是剑指offer
。。。
最后一行表示:题单id为4的是面试笔刷TOP101

请你写出一个SQL，查找出当天(对，就是你现在写代码的这一天，实现原理就是后台有特殊程序会将'2999-02-22'这个东西变为今天的日期，并且将'2999-02-21'变为昨天的日期)的每个题单的刷题量，先按提交数量降序排序，如果提交数量一样的话，再按subject_id升序排序，以上例子查询如下：
name	cnt
tiba	2
jzoffer	1
huaweijishu	1
解释：
第一行表示题霸这个专题一天的提交量为2，排名最靠前
第二行，第三行表示剑指offer，华为机试这2个专题一天的提交量都为1，但是剑指offer的subject_id比较小，排在前面

注：由于后台有程序会将'2999-02-22'这个东西变为今天的日期，并且将'2999-02-21'变为昨天的日期，请写出通用的代码，不然可能你的代码只有今天可以通过哟~


drop table if exists submission;
CREATE TABLE submission (
id int(11) NOT NULL,
subject_id int(11) NOT NULL,
create_time date NOT NULL
);

CREATE TABLE subject (
id int(11) NOT NULL,
name varchar(32) NOT NULL
);

INSERT INTO submission VALUES
(1,2,'2999-02-11'),
(2,2,'2999-02-21'),
(3,1,'2999-02-21'),
(4,1,'2999-02-22'),
(5,3,'2999-02-22'),
(6,2,'2999-02-22'),
(7,2,'2999-02-22');

INSERT INTO subject VALUES
(1,'jzoffer'),
(2,'tiba'),
(3,'huaweijishi'),
(4,'top101');


--1、方法一
select 
    name,cnt
from(
    select
         sj.name
        ,sb.subject_id
        ,count(1) as cnt
    from (
        select 
            *
        from submission
        where create_time = curdate()
    ) sb 
    inner join  subject sj 
    on sb.subject_id = sj.id 
    group by sj.name,sb.subject_id
) t 
order by t.cnt desc,t.subject_id
;

--2、方法二

select
	 sj.name
	,count(1) as cnt
from (
	select 
		*
	from submission
	where create_time = curdate()
) sb 
join subject sj 
on sb.subject_id = sj.id 
group by sj.name,sb.subject_id
order by cnt desc,sb.subject_id
;


--3、方法三
select 
	sj.name
	,sb.cnt
from
(
    select 
		subject_id
		,count(id) as cnt 
	from  submission 
	where `create_time` BETWEEN curdate() AND DATE_ADD(curdate(),INTERVAL 1 DAY)  
	group by subject_id
) sb
join subject sj
on sb.subject_id = sj.id
order by T.cnt desc, sj.id
;
