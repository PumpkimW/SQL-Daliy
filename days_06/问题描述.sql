描述
在牛客实习广场有很多公司开放职位给同学们投递，同学投递完就会把简历信息存到数据库里。
现在有简历信息表(resume_info)，部分信息简况如下:


第1行表示，在2025年1月2号，C++岗位收到了53封简历
......
最后1行表示，在2027年2月6号，C++岗位收到了231封简历

请你写出SQL语句查询在2025年投递简历的每个岗位，每一个月内收到简历的数目，和对应的2026年的同一个月同岗位，收到简历的数目，最后的结果先按first_year_mon月份降序，再按job降序排序显示，以上例子查询结果如下:
job	first_year_mon	first_year_cnt	second_year_mon
second_year_cnt
Python	2025-02	93	2026-02 846

解析:
第1行表示Python岗位在2025年2月收到了93份简历，在对应的2026年2月收到了846份简历
......
最后1行表示C++岗位在2025年1月收到了107份简历，在对应的2026年1月收到了470份简历


--解答
select 
    t1.*
    ,t2.second_year_mon
    ,t2.second_year_cnt
from(
    select
        r.job
        ,DATE_FORMAT(date,'%Y-%m') as first_year_mon
        ,sum(num) as first_year_cnt
    from resume_info r
    where date between '2025-01-01' and '2025-12-31'
    group by r.job,DATE_FORMAT(date,'%Y-%m')
) t1 
left join (
    select
        r.job
        ,DATE_FORMAT(date,'%Y-%m') as second_year_mon
        ,sum(num) as second_year_cnt
    from resume_info r
    where date between '2026-01-01' and '2026-12-31'
    group by r.job,DATE_FORMAT(date,'%Y-%m')
) t2
on t1.job = t2.job 
and right(t1.first_year_mon,2) = right(t2.second_year_mon,2) 
order by t1.first_year_mon desc,t1.job desc
;


select 
	t1.*
	,t2.second_year_mon
	,t2.second_year_cnt
from(
	select
		r.job
		,DATE_FORMAT(date,'%Y-%m') as first_year_mon
		,sum(num) as first_year_cnt
	from resume_info r
	where date between str_to_date('2025-01-01','%Y-%m-%d') and str_to_date('2025-12-31','%Y-%m-%d')
	group by r.job,DATE_FORMAT(date,'%Y-%m')
) t1 
left join (
	select
		r.job
		,DATE_FORMAT(date,'%Y-%m') as second_year_mon
		,sum(num) as second_year_cnt
	from resume_info r
	where date between str_to_date('2026-01-01','%Y-%m-%d') and str_to_date('2026-12-31','%Y-%-%d')
	group by r.job,DATE_FORMAT(date,'%Y-%m')
) t2
on t1.job = t2.job 
and right(t1.first_year_mon,2) = right(t2.second_year_mon,2) 
order by t1.first_year_mon desc,t1.job desc
;


select A.job,
A.mon as first_year_mon,
A.cnt as first_year_cnt,
B.mon as second_year_mon,
B.cnt as second_year_cnt
from (
	select 
		job,left(date,7) mon,sum(num) as cnt
	from resume_info
	where year(date)="2025"
	group by job,mon
)A,
(
	select 
		job,left(date,7) mon,sum(num) as cnt
	from resume_info
	where year(date)="2026"
	group by job,mon
)B
where A.job=B.job 
and right(A.mon,2) = right(B.mon,2)
order by A.mon desc,A.job desc
;

select 
    t1.*
    ,t2.second_year_mon
    ,t2.second_year_cnt
from(
    select
        r.job
        ,left(date,7) as first_year_mon
        ,sum(num) as first_year_cnt
    from resume_info r
    where date between str_to_date('2025-01-01','%Y-%m-%d') and str_to_date('2025-12-31','%Y-%m-%d')
    group by r.job,left(date,7)
) t1 
left join (
    select
        r.job
        ,left(date,7) as second_year_mon
        ,sum(num) as second_year_cnt
    from resume_info r
    where date between str_to_date('2026-01-01','%Y-%m-%d') and str_to_date('2026-12-31','%Y-%m-%d')
    group by r.job,left(date,7)
) t2
on t1.job = t2.job 
and right(t1.first_year_mon,2) = right(t2.second_year_mon,2) 
order by t1.first_year_mon desc,t1.job desc
;






































