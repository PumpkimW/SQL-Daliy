--题目来源
--SQL282 最差是第几名(二)
--https://www.nowcoder.com/share/jump/5181271201717174486879


--问题描述
TM小哥和FH小妹在牛客大学若干年后成立了牛客SQL班，班的每个人的综合成绩用A,B,C,D,E表示，90分以上都是A，80~90分都是B，70~80分为C，60~70为D，E为60分以下
假设每个名次最多1个人，比如有2个A，那么必定有1个A是第1名，有1个A是第2名(综合成绩同分也会按照某一门的成绩分先后)。
每次SQL考试完之后，老师会将班级成绩表展示给同学看。
现在有班级成绩表(class_grade)如下:

drop table if exists class_grade;
CREATE TABLE class_grade (
grade varchar(32) NOT NULL,
number int(4) NOT NULL
);

INSERT INTO class_grade VALUES
('A',2),
('C',4),
('B',4),
('D',2);

第1行表示成绩为A的学生有2个
.......
最后1行表示成绩为D的学生有2个

--SQL问题
请你写SQL帮忙查询一下，如果只有1个中位数，输出1个，如果有2个中位数，按grade升序输出，以上例子查询结果如下:
grade
B
C

解析:
总体学生成绩排序如下:A, A, B, B, B, B, C, C, C, C, D, D，总共12个数，取中间的2个，取6，7为:B,C

--解答SQL代码如下
--方法一
with class_grade_rn as (
select 
    cg.*
    ,case when grade = 'A' then 1
          when grade = 'B' then 2
          when grade = 'C' then 3
          when grade = 'D' then 4
        else 5
    end as rn
from class_grade cg
)
,rigtht as (
    select 
        t1.grade
        ,t1.number
        ,t1.rn
        ,sum(t2.number) as cnt
        ,'1' as idx
    from class_grade_rn t1 
    left join class_grade_rn t2
    on t1.rn >= t2.rn
    group by t1.grade,t1.number,t1.rn
)  
select 
    tmp.grade
from(
    select 
        r1.grade
        ,r1.rn
        ,r1.cnt as rg
        ,case when r2.rn is null then 1 else r2.cnt+1 end as st
        ,max(r1.cnt) over(partition by r1.idx) as tot
    from rigtht r1 
    left join rigtht r2 
    on r1.rn = r2.rn + 1
) tmp 
where 1=1
and (
	case when tot % 2= 0 and round(1.0 * tot / 2,0) >= st and round(1.0 * tot / 2,0) <= rg then 1
		 when tot % 2= 0 and round(1.0 * tot / 2,0)+1 >= st and round(1.0 * tot / 2,0)+1 <= rg then 1
		 when tot % 2= 1 and round(1.0 * tot / 2,0) >= st and round(1.0 * tot / 2,0) <= rg then 1
		else 0 
	end ) = 1
order by tmp.grade
;

--方法二
select 
grade 
from (
	select 
		grade,
		(select sum(number)from class_grade) as total,
		sum(number) over(order by grade) a,
		sum(number) over(order by grade desc) b
	from class_grade
) t1
where a >= total/2 and b >=total/2
order by grade
;













