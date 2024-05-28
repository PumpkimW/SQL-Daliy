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
INSERT INTO employees VALUES(10001,'1953-09-02','Georgi','Facello','M','2001-06-22');
INSERT INTO employees VALUES(10002,'1964-06-02','Bezalel','Simmel','F','1999-08-03');
INSERT INTO salaries VALUES(10001,85097,'2001-06-22','2002-06-22');
INSERT INTO salaries VALUES(10001,88958,'2002-06-22','9999-01-01');
INSERT INTO salaries VALUES(10002,72527,'1999-08-03','2000-08-02');
INSERT INTO salaries VALUES(10002,72527,'2000-08-02','2001-08-02');


--SQL问题
请你查找在职员工自入职以来的薪水涨幅情况，给出在职员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序，以上例子输出为
（注: to_date为薪资调整某个结束日期，或者为离职日期，to_date='9999-01-01'时，表示依然在职，无后续调整记录）

--解答SQL代码如下

select 
	scurrent.emp_no
	,(scurrent.salary-sstart.salary) as growth
from (
	select 
		s.emp_no
		,s.salary 
	from employees e 
	left join salaries s 
	on e.emp_no = s.emp_no 
	where s.to_date = '9999-01-01'
) as scurrent
join (
	select 
		s.emp_no
		,s.salary 
	from employees e 
	left join salaries s 
	on e.emp_no = s.emp_no 
	where s.from_date = e.hire_date
) as sstart
on scurrent.emp_no = sstart.emp_no
order by growth
;
	
	