--题目来源
--SQL277 牛客的课程订单分析(七)
--https://www.nowcoder.com/share/jump/5181271201717071396722

--问题描述
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
同一个用户下单2个以及2个以上状态为购买成功的C++课程或Java课程或Python课程的来源信息，
第一列是显示的是客户端名字，如果是拼团订单则显示GroupBuy，
第二列显示这个客户端(或者是拼团订单)有多少订单，
最后结果按照第一列(source)升序排序，以上例子查询结果如下:
source	cnt
GroupBuy	2
IOS	1
PC	1
解析:
id为4，6的订单满足以上条件，且因为4是通过IOS下单的非拼团订单，则记: IOS 1
，6是通过PC下单的非拼团订单，则记: PC 1;
id为5，7的订单满足以上条件，且因为5与7都是拼团订单，则记: GroupBuy 2;
最后按照source升序排序。

--解答SQL代码如下
select 
    (case when c.id is null 
            then 'GroupBuy'
        else c.name
    end) as source
    ,count(1) as cnt
from (
    select
        client_id
        ,count(1) over(partition by user_id) as cnt 
    from order_info o 
    where date >= '2025-10-15'
    and status = 'completed'
    and product_name in ('C++','Java','Python')
) ord
left join client c 
on ord.client_id = c.id
where ord.cnt >= 2
group by (
case when c.id is null 
        then 'GroupBuy'
    else c.name
end)
order by source
;
