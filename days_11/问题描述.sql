--题目来源
SQL275 牛客的课程订单分析(五)
https://www.nowcoder.com/share/jump/5181271201717597278805
--问题描述
有很多同学在牛客购买课程来学习，购买会产生订单存到数据库里。

有一个订单信息表(order_info)，简况如下:
drop table if exists order_info;
CREATE TABLE order_info (
id int(4) NOT NULL,
user_id int(11) NOT NULL,
product_name varchar(256) NOT NULL,
status varchar(32) NOT NULL,
client_id int(4) NOT NULL,
date date NOT NULL,
PRIMARY KEY (id));

INSERT INTO order_info VALUES
(1,557336,'C++','no_completed',1,'2025-10-10'),
(2,230173543,'Python','completed',2,'2025-10-12'),
(3,57,'JS','completed',3,'2025-10-23'),
(4,57,'C++','completed',3,'2025-10-23'),
(5,557336,'Java','completed',1,'2025-10-23'),
(6,57,'Java','completed',1,'2025-10-24'),
(7,557336,'C++','completed',1,'2025-10-25'),
(8,557336,'Python','completed',1,'2025-10-26');


第1行表示user_id为557336的用户在2025-10-10的时候使用了client_id为1的客户端下了C++课程的订单，但是状态为没有购买成功。

第2行表示user_id为230173543的用户在2025-10-12的时候使用了client_id为2的客户端下了Python课程的订单，状态为购买成功。

......

最后1行表示user_id为557336的用户在2025-10-26的时候使用了client_id为1的客户端下了Python课程的订单，状态为购买成功。



--SQL问题
请你写出一个sql语句查询在2025-10-15以后，如果有一个用户下单2个以及2个以上状态为购买成功的C++课程或Java课程或Python课程，
那么输出这个用户的user_id，以及满足前面条件的第一次购买成功的C++课程或Java课程或Python课程的日期first_buy_date，
以及满足前面条件的第二次购买成功的C++课程或Java课程或Python课程的日期second_buy_date，
以及购买成功的C++课程或Java课程或Python课程的次数cnt，并且输出结果按照user_id升序排序，以上例子查询结果如下:
user_id	first_buy_date	second_buy_date	cnt
57好	2025-10-23	2025-10-24	2
557336	2025-10-23	2025-10-25	3

--解析:
id为4，6的订单满足以上条件，输出57，id为4的订单为第一次购买成功，输出first_buy_date为2025-10-23，id为6的订单为第二次购买，
输出second_buy_date为2025-10-24，总共成功购买了2次;

id为5，7，8的订单满足以上条件，输出557336，id为5的订单为第一次购买成功，输出first_buy_date为2025-10-23，id为7的订单为第二次购买，
输出second_buy_date为2025-10-25，总共成功购买了3次;


--解答SQL代码如下

select 
	t.user_id
	,max(case when t.rn = 1 then date else null end) as first_buy_date
	,max(case when t.rn = 2 then date else null end) as second_buy_date
	,count(1) as cnt
from (
	select 
		o.* 
		,row_number() over(partition by user_id order by date) as rn
	from order_info o
	where 1 = 1
		and date >= '2025-10-15'
		and status = 'completed'
		and product_name in ('C++','Java','Python')
) t 
group by t.user_id
having count(1) >= 2
order by t.user_id
;