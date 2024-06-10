--题目来源
--SQL248 平均工资
--https://www.nowcoder.com/share/jump/5181271201717596923300

--问题描述
查找排除在职(to_date = '9999-01-01' )员工的最大、最小salary之后，其他的在职员工的平均工资avg_salary。
CREATE TABLE `salaries` ( `emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
如：
INSERT INTO salaries VALUES(10001,85097,'2001-06-22','2002-06-22');
INSERT INTO salaries VALUES(10001,88958,'2002-06-22','9999-01-01');
INSERT INTO salaries VALUES(10002,72527,'2001-08-02','9999-01-01');
INSERT INTO salaries VALUES(10003,43699,'2000-12-01','2001-12-01');
INSERT INTO salaries VALUES(10003,43311,'2001-12-01','9999-01-01');
INSERT INTO salaries VALUES(10004,70698,'2000-11-27','2001-11-27');
INSERT INTO salaries VALUES(10004,74057,'2001-11-27','9999-01-01');


--SQL问题
查找排除在职(to_date = '9999-01-01' )员工的最大、最小salary之后，其他的在职员工的平均工资avg_salary。

avg_salary
73292

--解答SQL代码如下

select 
	avg(salary) as avg_salary
from salaries  s1
left join (
	select 
		max(salary) as max_salary
	from salaries s 
	where s.to_date = '9999-01-01'
) s2
on s1.salary = s2.max_salary
left join (
	select 
		min(salary) as min_salary
	from salaries s 
	where s.to_date = '9999-01-01'
) s3
on s1.salary = s3.min_salary
where s1.to_date = '9999-01-01'
and s2.max_salary is null
and s3.min_salary is null
;
