--题目来源
--SQL270 考试分数(五)
--https://www.nowcoder.com/share/jump/5181271201716995134810

--问题描述
牛客每次考试完，都会有一个成绩表(grade)，如下:

drop table if exists grade;
CREATE TABLE  grade(
`id` int(4) NOT NULL,
`job` varchar(32) NOT NULL,
`score` int(10) NOT NULL,
PRIMARY KEY (`id`));

INSERT INTO grade VALUES
(1,'C++',11001),
(2,'C++',10000),
(3,'C++',9000),
(4,'Java',12000),
(5,'Java',13000),
(6,'B',12000),
(7,'B',11000),
(8,'B',9999)
;

第1行表示用户id为1的用户选择了C++岗位并且考了11001分

。。。

第8行表示用户id为8的用户选择了B语言岗位并且考了9999分


--SQL问题
请你写一个sql语句查询各个岗位分数的中位数位置上的所有grade信息，并且按id升序排序，结果如下:
id	job	score	t_rank
2	C++	10000	2
4	Java	12000	2
5	Java	13000	1
7	B	11000	2

【解释】：

第1行表示C++岗位的中位数位置上的为用户id为2，分数为10000，在C++岗位里面排名是第2

第2，3行表示Java岗位的中位数位置上的为用户id为4,5，分数为12000,13000，在Java岗位里面排名是第2,1

第4行表示B语言岗位的中位数位置上的为用户id为7，分数为11000，在前端岗位里面排名是第2

(注意: sqlite 1/2得到的不是0.5，得到的是0，只有1*1.0/2才会得到0.5，sqlite四舍五入的函数为round，
sqlite不支持floor函数，支持cast(x as integer) 函数，不支持if函数，支持case when ...then ...else ..end函数，sqlite不支持自定义变量)


--解答SQL代码如下
--方法一

select
	 t.id
	,t.job
	,t.score
	,t.rn as t_rank
from(
	select 
		g.* 
		,count(1) over(partition by job) as cnt
		,row_number() over(partition by job order by score desc) as rn
	from grade g
) t 
where (
	case when cnt % 2 = 1
				and rn - (1.0 * cnt / 2) = 0.5
			then 1
		 when cnt % 2 = 0
				and rn - (1.0 * cnt / 2) between 0 and 1
			then  1
		else 0 
	end
) = 1
order by t.id
;

--方法二妙解）
用一条规则统一奇数个数时和偶数个数时的中位数位置。无论奇偶，中位数的位置距离（个数+1）/2 小于1，不信你随便写个试试。

select 
	id,job
	,score
	,s_rank
from (
	select 
	  *
	  ,(row_number()over(partition by job order by score desc))as s_rank
	  ,(count(score)over(partition by job))as num
	from grade
)t1
where abs(t1.s_rank-(t1.num+1)/2)<1
order by id
;


--方法三
这道题解法确实有不严谨的地方，同一job存在多个score相同时,这里的row_number()正逆序号可能会出现问题，再加上id排序即可解决，感谢评论指出问题

with t_rank as(
	select *,
	   count(score) over(partition by job) as total,
	   row_number() over(partition by job order by score,id) as a, #升序序号
	   row_number() over(partition by job order by score desc,id desc) as b #逆序序号
	from grade
)
select 
	id,job,score,b
from t_rank
where a>=total/2 and b>=total/2
order by id
;





















