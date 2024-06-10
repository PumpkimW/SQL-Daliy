--题目来源
SQL276 牛客的课程订单分析(六)
https://www.nowcoder.com/share/jump/5181271201717686190076

--问题描述
有很多同学在牛客购买课程来学习，购买会产生订单存到数据库里。

有一个订单信息表(order_info)，简况如下:

有一个客户端表(client)，简况如下:

drop table if exists order_info;
drop table if exists client;
CREATE TABLE order_info (
id int(4) NOT NULL,
user_id int(11) NOT NULL,
product_name varchar(256) NOT NULL,
status varchar(32) NOT NULL,
client_id int(4) NOT NULL,
date date NOT NULL,
is_group_buy varchar(32) NOT NULL,
PRIMARY KEY (id));

CREATE TABLE client(
id int(4) NOT NULL,
name varchar(32) NOT NULL,
PRIMARY KEY (id)
);

INSERT INTO order_info VALUES
(1,557336,'C++','no_completed',1,'2025-10-10','No'),
(2,230173543,'Python','completed',2,'2025-10-12','No'),
(3,57,'JS','completed',0,'2025-10-23','Yes'),
(4,57,'C++','completed',3,'2025-10-23','No'),
(5,557336,'Java','completed',0,'2025-10-23','Yes'),
(6,57,'Java','completed',1,'2025-10-24','No'),
(7,557336,'C++','completed',0,'2025-10-25','Yes');

INSERT INTO client VALUES
(1,'PC'),
(2,'Android'),
(3,'IOS'),
(4,'H5');


第1行表示user_id为557336的用户在2025-10-10的时候使用了client_id为1的客户端下了C++课程的非拼团(is_group_buy为No)订单，但是状态为没有购买成功。

第2行表示user_id为230173543的用户在2025-10-12的时候使用了client_id为2的客户端下了Python课程的非拼团(is_group_buy为No)订单，状态为购买成功。

。。。

最后1行表示user_id为557336的用户在2025-10-25的时候使用了下了C++课程的拼团(is_group_buy为Yes)订单，拼团不统计客户端，所以client_id所以为0，状态为购买成功。



--SQL问题
请你写出一个sql语句查询在2025-10-15以后，
同一个用户下单2个以及2个以上状态为购买成功的C++课程或Java课程或Python课程的订单id，是否拼团以及客户端名字信息，
最后一列如果是非拼团订单，则显示对应客户端名字，如果是拼团订单，则显示NULL，
并且按照order_info的id升序排序，以上例子查询结果如下:
输出：
4|No|IOS
5|Yes|None
6|No|PC
7|Yes|None

--解答SQL代码如下


select 
	 ord.id 
	,ord.is_group_buy
	,case when c.id is not null 
			then c.name 
		else null 
	end as client_name
from (
	select 
		o.id 
		,o.is_group_buy
		,o.client_id
		,count(1) over(partition by user_id) as cnt 
	from order_info o 
	where 1=1
		and o.date >= '2025-10-15'
		and o.status = 'completed'
		and product_name in ('C++','Python','Java')
) ord
left join client as c
on ord.client_id = c.id
where ord.cnt >= 2
order by ord.id
;
