--题目来源
--SQL220 汇总各个部门当前员工的title类型的分配数目
--https://www.nowcoder.com/share/jump/5181271201717254603919

--问题描述

有一个部门表departments简况如下:
有一个，部门员工关系表dept_emp简况如下:
有一个职称表titles简况如下:
drop table if exists  `departments` ; 
drop table if exists  `dept_emp` ; 
drop table if exists  titles ;
CREATE TABLE `departments` (
`dept_no` char(4) NOT NULL,
`dept_name` varchar(40) NOT NULL,
PRIMARY KEY (`dept_no`));
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE titles (
`emp_no` int(11) NOT NULL,
`title` varchar(50) NOT NULL,
`from_date` date NOT NULL,
`to_date` date DEFAULT NULL);
INSERT INTO departments VALUES('d001','Marketing');
INSERT INTO departments VALUES('d002','Finance');
INSERT INTO dept_emp VALUES(10001,'d001','1986-06-26','9999-01-01');
INSERT INTO dept_emp VALUES(10002,'d001','1996-08-03','9999-01-01');
INSERT INTO dept_emp VALUES(10003,'d002','1995-12-03','9999-01-01');
INSERT INTO titles VALUES(10001,'Senior Engineer','1986-06-26','9999-01-01');
INSERT INTO titles VALUES(10002,'Staff','1996-08-03','9999-01-01');
INSERT INTO titles VALUES(10003,'Senior Engineer','1995-12-03','9999-01-01');

--SQL问题
汇总各个部门当前员工的title类型的分配数目，
即结果给出部门编号dept_no、dept_name、其部门下所有的员工的title以及该类型title对应的数目count，
结果按照dept_no升序排序，dept_no一样的再按title升序排序

--解答SQL代码如下

select 
	de.dept_no, dp.dept_name,tl.title
	,count(1) as cnt
from dept_emp de
left join departments dp
on de.dept_no = dp.dept_no
left join titles tl
on de.emp_no = tl.emp_no
group by de.dept_no, dp.dept_name,tl.title
order by de.dept_no, tl.title
;
