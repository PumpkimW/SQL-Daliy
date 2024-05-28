--描述
牛客每天有很多人登录，请你统计一下牛客每个用户最近登录是哪一天，用的是什么设备.
有一个登录(login)记录表，简况如下:

第1行表示user_id为2的用户在2020-10-12使用了客户端id为1的设备登录了牛客网
。。。
第4行表示user_id为3的用户在2020-10-13使用了客户端id为2的设备登录了牛客网

还有一个用户(user)表，简况如下:

还有一个客户端(client)表，简况如下:
drop table if exists login;
drop table if exists user;
drop table if exists client;
CREATE TABLE `login` (
`id` int(4) NOT NULL,
`user_id` int(4) NOT NULL,
`client_id` int(4) NOT NULL,
`date` date NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `user` (
`id` int(4) NOT NULL,
`name` varchar(32) NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `client` (
`id` int(4) NOT NULL,
`name` varchar(32) NOT NULL,
PRIMARY KEY (`id`));

INSERT INTO login VALUES
(1,2,1,'2020-10-12'),
(2,3,2,'2020-10-12'),
(3,2,2,'2020-10-13'),
(4,3,2,'2020-10-13');

INSERT INTO user VALUES
(1,'tm'),
(2,'fh'),
(3,'wangchao');

INSERT INTO client VALUES
(1,'pc'),
(2,'ios'),
(3,'anroid'),
(4,'h5');

--问题描述
请你写出一个sql语句查询每个用户最近一天登录的日子，用户的名字，以及用户用的设备的名字，并且查询结果按照user的name升序排序，上面的例子查询结果如下:
查询结果表明:
fh最近的登录日期在2020-10-13，而且是使用ios登录的
wangchao最近的登录日期也是2020-10-13，而且是使用ios登录的
u_n	c_n	date
fh	ios	2020-10-13
wangchao	ios	2020-10-13

--解答SQL代码如下
select 
    u.name as un 
    ,c.name as c_n 
    ,log.date
from (
    select 
        tmp.*
    from (
        select 
            l.*
            ,row_number() over(partition by user_id order by  date desc) as rn 
        from login l
    )tmp 
    where rn = 1 
) log 
left join user u 
on log.user_id = u.id
left join client c 
on log.client_id = c.id 
order by u.name asc
;
