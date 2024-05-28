--问题描述
牛客每次举办企业笔试的时候，企业一般都会有不同的语言岗位，比如C++工程师，JAVA工程师，Python工程师，每个用户笔试完有不同的分数，
现在有一个分数(grade)表简化如下:

不同的语言岗位(language)表简化如下:
drop table if exists grade;
drop table if exists language;
CREATE TABLE `grade` (
`id` int(4) NOT NULL,
`language_id` int(4) NOT NULL,
`score` int(4) NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `language` (
`id` int(4) NOT NULL,
`name` varchar(32) NOT NULL,
PRIMARY KEY (`id`));

INSERT INTO grade VALUES
(1,1,12000),
(2,1,13000),
(3,2,11000),
(4,2,10000),
(5,3,11000),
(6,1,11000),
(7,2,11000);

INSERT INTO language VALUES
(1,'C++'),
(2,'JAVA'),
(3,'Python');

第1行表示用户id为1的选择了language_id为1岗位的最后考试完的分数为12000，
....
第7行表示用户id为7的选择了language_id为2岗位的最后考试完的分数为11000，

--问题
请你找出每个岗位分数排名前2名的用户，得到的结果先按照language的name升序排序，再按照积分降序排序，最后按照grade的id升序排序，得到结果如下

--解答
select 
    t1.id 
    ,t2.name
    ,t1.score
from (
    select 
        g.* 
        ,dense_rank() over(partition by language_id order by score desc) as rn
    from grade g 
) t1 
left join language t2 
on t1.language_id = t2.id 
where t1.rn <= 2
order by t2.name, t1.score desc
;