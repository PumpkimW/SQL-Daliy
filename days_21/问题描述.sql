--题目来源
SQL285 获得积分最多的人(三)
https://www.nowcoder.com/share/jump/5181271201717685287148
--问题描述
牛客每天有很多用户刷题，发帖，点赞，点踩等等，这些都会记录相应的积分。
有一个用户表(user)，简况如下：
还有一个积分表(grade_info)，简况如下:
drop table if exists user;
drop table if exists grade_info;

CREATE TABLE user (
id  int(4) NOT NULL,
name varchar(32) NOT NULL
);

CREATE TABLE grade_info (
user_id  int(4) NOT NULL,
grade_num int(4) NOT NULL,
type varchar(32) NOT NULL
);

INSERT INTO user VALUES
(1,'tm'),
(2,'wwy'),
(3,'zk'),
(4,'qq'),
(5,'lm');

INSERT INTO grade_info VALUES
(1,3,'add'),
(2,3,'add'),
(1,1,'reduce'),
(3,3,'add'),
(4,3,'add'),
(5,3,'add'),
(3,1,'reduce');

第1行表示，user_id为1的用户积分增加了3分。
第2行表示，user_id为2的用户积分增加了3分。
第3行表示，user_id为1的用户积分减少了1分。
.......
最后1行表示，user_id为3的用户积分减少了1分。


--SQL问题
请你写一个SQL查找积分最高的用户的id，名字，以及他的总积分是多少(可能有多个)，查询结果按照id升序排序，以上例子查询结果如下:

id	name	grade_num
2	wwy	3
4	qq	3
5	lm	3
解释:
user_id为1和3的先加了3分，但是后面又减了1分，他们2个是2分，
其他3个都是3分，所以输出其他三个的数据。

--解答SQL代码如下

select
	u.id
	,u.name
	,top1.grade_num
from(
	select 
		t.*
		,dense_rank() over(order by grade_num desc) as rn 
	from(
		select 
			g.user_id
			,sum(case when type='add' then grade_num else -1 * grade_num end) as grade_num
		from grade_info g 
		group by g.user_id
	) t 
) top1
left join user u 
on top1.user_id = u.id
where top1.rn = 1
;