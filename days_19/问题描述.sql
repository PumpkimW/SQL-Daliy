--题目来源
--SQL273 牛客的课程订单分析(三)
--https://www.nowcoder.com/share/jump/5181271201717505887003

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
(7,557336,'C++','completed',1,'2025-10-25');

第1行表示user_id为557336的用户在2025-10-10的时候使用了client_id为1的客户端下了C++课程的订单，但是状态为没有购买成功。

第2行表示user_id为230173543的用户在2025-10-12的时候使用了client_id为2的客户端下了Python课程的订单，状态为购买成功。

。。。

最后1行表示user_id为557336的用户在2025-10-25的时候使用了client_id为1的客户端下了C++课程的订单，状态为购买成功。

--SQL问题
请你写出一个sql语句查询在2025-10-15以后，
同一个用户下单2个以及2个以上状态为购买成功的C++课程或Java课程或Python课程的订单信息，
并且按照order_info的id升序排序，以上例子查询结果如下:


--解答SQL代码如下
select 
    t.id
    ,t.user_id
    ,t.product_name
    ,t.status
    ,t.client_id
    ,t.date
from(
    select 
        o.*
        ,count(1) over(partition by user_id) as cnt  
    from order_info o 
    where 1=1
    and date >= '2025-10-15'
    and status = 'completed'
    and product_name in ('Java','C++','Python')
) t 
where 1=1
and t.cnt >= 2
order by t.id asc
;
