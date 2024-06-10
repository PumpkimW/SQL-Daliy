--问题描述
对于employees表中，输出first_name排名(按first_name升序排序)为奇数的first_name
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
如，输入为：
INSERT INTO employees VALUES(10001,'1953-09-02','Georgi','Facello','M','1986-06-26');
INSERT INTO employees VALUES(10002,'1964-06-02','Bezalel','Simmel','F','1985-11-21');
INSERT INTO employees VALUES(10005,'1955-01-21','Kyoichi','Maliniak','M','1989-09-12');
INSERT INTO employees VALUES(10006,'1953-04-20','Anneke','Preusig','F','1989-06-02');


--SQL问题
请你在不打乱原序列顺序的情况下，输出：按first_name排升序后，取奇数行的first_name。
如对以上示例数据的first_name排序后的序列为：Anneke、Bezalel、Georgi、Kyoichi。
则原序列中的Georgi排名为1，Anneke排名为4，所以按原序列顺序输出Georgi、Anneke。

输出格式:
first
Georgi
Anneke


--解答SQL代码如下

select 
	t.first_name
from (
	select 
		e.* 
		,row_number() over(order by first_name ) as rn 
		,row_number() over(order by emp_no ) as rn1
	from employees e 
) t 
where mod(rn, 2) = 1
order by rn1
;
