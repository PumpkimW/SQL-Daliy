--题目来源
--SQL212 获取当前薪水第二多的员工的emp_no以及其对应的薪水salary
--https://www.nowcoder.com/share/jump/5181271201717423359491

--问题描述
有一个员工表employees简况如下:
有一个薪水表salaries简况如下:
drop table if exists  `employees` ; 
drop table if exists  `salaries` ; 
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
INSERT INTO employees VALUES(10001,'1953-09-02','Georgi','Facello','M','1986-06-26');
INSERT INTO employees VALUES(10002,'1964-06-02','Bezalel','Simmel','F','1985-11-21');
INSERT INTO employees VALUES(10003,'1959-12-03','Parto','Bamford','M','1986-08-28');
INSERT INTO employees VALUES(10004,'1954-05-01','Chirstian','Koblick','M','1986-12-01');
INSERT INTO salaries VALUES(10001,88958,'2002-06-22','9999-01-01');
INSERT INTO salaries VALUES(10002,72527,'2001-08-02','9999-01-01');
INSERT INTO salaries VALUES(10003,43311,'2001-12-01','9999-01-01');
INSERT INTO salaries VALUES(10004,74057,'2001-11-27','9999-01-01');


--SQL问题
请你查找薪水排名第二多的员工编号emp_no、薪水salary、last_name以及first_name，不能使用order by完成，以上例子输出为:
emp_no salary last_name	first_name
10004	74057	Koblick	Chirstian


--解答SQL代码如下

	select 
		 top2.emp_no
		,top2.salary
		,e.last_name
		,e.first_name
	from(
		select 
			s1.emp_no
			,s1.salary
		from salaries s1 
		join(
			select 
				max(s2.salary) as max_salary
			from salaries s2
			left join (
				select 
					max(salary) as max_salary
				from salaries
			) s3
			on s2.salary = s3.max_salary
			where s3.max_salary is null
		) s4 
		on s1.salary = s4.max_salary
	) top2
	left join employees e
	on top2.emp_no = e.emp_no
	;
