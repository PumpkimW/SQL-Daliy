描述
有一个员工表dept_emp简况如下:
有一个薪水表salaries简况如下:

drop table if exists  `dept_emp` ; 
drop table if exists  `salaries` ; 
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL,
`dept_no` char(4) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
INSERT INTO dept_emp VALUES(10001,'d001','1986-06-26','9999-01-01');
INSERT INTO dept_emp VALUES(10002,'d001','1996-08-03','9999-01-01');
INSERT INTO dept_emp VALUES(10003,'d002','1996-08-03','9999-01-01');

INSERT INTO salaries VALUES(10001,88958,'2002-06-22','9999-01-01');
INSERT INTO salaries VALUES(10002,72527,'2001-08-02','9999-01-01');
INSERT INTO salaries VALUES(10003,92527,'2001-08-02','9999-01-01');


获取每个部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary，按照部门编号dept_no升序排列，以上例子输出如下:
dept_no emp_no maxSalary
d001 10001 88958
d002 10003 92527


select 
    dept_no
    ,emp_no
    ,salary as maxSalary
from(
    select
        dp.dept_no
        ,sal.emp_no
        ,sal.salary
        ,row_number() over(partition  by dp.dept_no order by sal.salary desc) as rn
    from (select * from dept_emp where to_date = '9999-01-01') dp
    join (
        select *
        from salaries 
        where to_date = '9999-01-01'
    )sal
    on dp.emp_no = sal.emp_no
) tmp 
where rn = 1
order by dept_no
;