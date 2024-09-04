select database();

create table emp_info(
    name varchar(10) comment '姓名',
    gender char(1) comment '性别',
    age varchar(10) comment '年龄',
    id varchar(7) comment '编号',
    entryDate date comment '入职时间',
    address varchar(20) comment '籍贯'
) comment '员工信息表';

alter table emp_info change age age tinyint unsigned comment '年龄';

insert into emp_info values('张三', '男', 18, 1, '2000-01-01', '重庆'),
                           ('李四', '男', 28, 2, '2002-02-01', '重庆'),
                           ('王五', '男', 38, 3, '2002-03-01', '重庆'),
                           ('赵六', '男', 48, 4, '2050-03-01', '重庆'),
                           ('钱七', '男', 8, 5, '2008-04-01', '四川'),
                           ('周八', '男', 78, 6, '2003-06-01', '四川'),
                           ('王小明', '男', 22, 7, '2100-04-01', '四川'),
                           ('李大明', '男', 35, 8, '2005-11-01', '北京'),
                           ('张伟', '男', 65, 9, '2003-03-01', '北京'),
                           ('小芳', '女', 15, 10, '2007-02-01', '北京'),
                           ('小花', '女', 98, 11, '2008-09-01', '上海');

insert into emp_info values('杰伦', '男', 35, 8, '2005-11-01', '北京');

update emp_info set age = '16' where name = '杰伦';

select gender, count(*) from emp_info group by gender;
-- 分组之前过滤，用where；分组之后过滤用having
select gender, count(*) from emp_info group by gender;
select address, count(*) from emp_info where age < 45 group by address having count(address) >= 3;

-- 排序 asc：升序 desc：降序
-- 支持多字段排序，若第一个字段值相同，那么根据第二个字段排序

-- 根据年龄升序（默认升序）
select * from emp_info order by age asc;
-- 根据年龄降序
select * from emp_info order by age desc;
-- 根据入职时间排序
select * from emp_info order by entryDate asc, age desc;

update emp_info set name = 'zhangSan' where id = 1;
update emp_info set name = '张三' where name = 'zhangSan';
update emp_info set name = '张san', gender = '女' where id = 1;

-- 对表内数据全部进行修改，无需用where条件
update emp_info set entrydate = '2001-11-01';

delete from emp_info where id = 8;

update emp_info set name = null where name = '张san';

-- select查询表中多个字段
select name, gender, age from emp_info;

-- select查询整张表（使用通配符*）
-- 尽量少用通配符*，不直观，而且影响效率
select * from emp_info;

-- 查询还可以为字段起别名
select name as '姓名' from emp_info;

-- 查询不重复的记录（distinct）
select distinct id from emp_info;

-- 条件查询
select name from emp_info where age = 18;
select name from emp_info where age > 18;
select name from emp_info where age >= 18;

select name from emp_info where name is null;
select name from emp_info where name is not null;

-- 使用between and进行查询，注意，between后面跟最小值，and后跟最大值
select name from emp_info where age between 15 and 20;
-- between and的顺序不能调换（这么写没有用）
select name from emp_info where age between 20 and 15;

select name from emp_info where age = 18 or age = 19;
select name from emp_info where age in (18, 19);

-- 聚合函数，所有的null不参与计算
-- count 统计字段的条数
select count(id) from emp_info;
-- avg 求字段的平均数
select avg(age) from emp_info;
-- max 找到字段中的最大值
select max(age) from emp_info;
-- min 找到字段中的最小值
select min(id) from emp_info;
-- sum 求字段中数据的和
select sum(age) from emp_info;
-- 聚合函数可以搭配where使用
select sum(age) from emp_info where name is not null;

-- 分组查询
select * from emp_info;
select gender, count(id) from emp_info group by gender;
select gender, avg(age) from emp_info group by gender;
select gender, avg(age) from emp_info where age >= 19 group by gender;








