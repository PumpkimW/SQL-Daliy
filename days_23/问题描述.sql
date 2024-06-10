--题目来源
SQL284 获得积分最多的人(二)
https://www.nowcoder.com/share/jump/5181271201718020160126

--问题描述
有一个用户表(user)，简况如下：
还有一个积分表(grade_info)，简况如下:
drop table if exists user;
drop table if exists grade_info;

CREATE TABLE user (
id  int(4) NOT NULL,
name varchar(32) NOT NULL
);

CREATE TABLE grade_info (
user_id  int(4) NOT NULL,
grade_num int(4) NOT NULL,
type varchar(32) NOT NULL
);

INSERT INTO user VALUES
(1,'tm'),
(2,'wwy'),
(3,'zk'),
(4,'qq'),
(5,'lm');

INSERT INTO grade_info VALUES
(1,3,'add'),
(2,3,'add'),
(1,1,'add'),
(3,3,'add'),
(4,3,'add'),
(5,3,'add'),
(3,1,'add'); 


第1行表示，user_id为1的用户积分增加了3分。
第2行表示，user_id为2的用户积分增加了3分。
第3行表示，user_id为1的用户积分又增加了1分。
.......
最后1行表示，user_id为3的用户积分增加了1分。


--SQL问题
请你写一个SQL查找积分增加最高的用户的id(可能有多个)，名字，以及他的总积分是多少，查询结果按照id升序排序，以上例子查询结果如下:
id	name	grade_num
1	tm	4
3	zk	4

解释:
user_id为1和3的2个人，积分都为4，都要输出


--解答SQL代码如下
--方法一
select 
    t1.user_id
    ,u.name
    ,t1.sum_num
from(
    select  
        tmp.*
        ,dense_rank() over(order by sum_num desc) as rn 
    from(
        select 
            g.user_id
            ,sum(grade_num) as sum_num
        from grade_info g 
        group by g.user_id
    ) tmp
) t1
left join user u 
on t1.user_id = u.id
where t1.rn = 1
order by t1.user_id
;


--方法二
with gs as (
    select 
        g.user_id
        ,sum(grade_num) as grade_sum
    from grade_info g 
    group by g.user_id
) 
select 
    gs.user_id
    ,u.name
    ,gs.grade_sum
from gs 
join (select max(grade_sum) as max_grade from gs) mg 
on gs.grade_sum = mg.max_grade
left join user u 
on gs.user_id = u.id
order by gs.user_id
;