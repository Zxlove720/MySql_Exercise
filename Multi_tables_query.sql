-- 准备数据
create table dept(
  id   int auto_increment comment 'ID' primary key,
  name varchar(50) not null comment '部门名称'
)comment '部门表';

create table emp(
  id  int auto_increment comment 'ID' primary key,
  name varchar(50) not null comment '姓名',
  age  int comment '年龄',
  job varchar(20) comment '职位',
  salary int comment '薪资',
  entrydate date comment '入职时间',
  managerid int comment '直属领导ID',
  dept_id int comment '部门ID'
)comment '员工表';

-- 添加外键
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id);

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'),(3, '财务部'), (4, '销售部'), (5, '总经办'), (6, '人事部');
INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id) VALUES
                                                                           (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),
                                                                           (2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
                                                                           (3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),
                                                                           (4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),
                                                                           (5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),
                                                                           (6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1),
                                                                           (7, '灭绝', 60, '财务总监',8500, '2002-09-12', 1,3),
                                                                           (8, '周芷若', 19, '会计',48000, '2006-06-02', 7,3),
                                                                           (9, '丁敏君', 23, '出纳',5250, '2009-05-13', 7,3),
                                                                           (10, '赵敏', 20, '市场部总监',12500, '2004-10-12', 1,2),
                                                                           (11, '鹿杖客', 56, '职员',3750, '2006-10-03', 10,2),
                                                                           (12, '鹤笔翁', 19, '职员',3750, '2007-05-09', 10,2),
                                                                           (13, '方东白', 19, '职员',5500, '2009-02-12', 10,2),
                                                                           (14, '张三丰', 88, '销售总监',14000, '2004-10-12', 1,4),
                                                                           (15, '俞莲舟', 38, '销售',4600, '2004-10-12', 14,4),
                                                                           (16, '宋远桥', 40, '销售',4600, '2004-10-12', 14,4),
                                                                           (17, '陈友谅', 42, null,2000, '2011-10-12', 1,null);


-- 多表查询
-- 进行数据库表设计时，会根据业务需求和业务模块的关系，分析并设计表的结构，因为业务之间互相关联，所以说各个表结构也存在各种联系
-- 一对多（多对一）；多对多；一对一

-- 一对多（多对一）
-- 案例：一个部门对应多个员工，多个员工对应一个部门
-- 实现：在多的一方建立外键，指向一的一方的主键

-- 多对多
-- 案例：一个学生可以选修多门课程，一门课程也可以供多个学生选择
-- 实现：建立第三张中间表，表中至少包含两个外键，分别关联两方的主键
use exercise;
create table student(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    no varchar(10) comment '学号'
) comment '学生表';
insert into student values (null, '黛绮丝', '2000100101'),(null, '谢逊', '2000100102'),(null, '殷天正', '2000100103'),(null, '韦一笑', '2000100104');

create table course(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
) comment '课程表';
insert into course values (null, 'Java'), (null, 'PHP'), (null , 'MySQL') , (null, 'Hadoop');

-- 这里，第三张中间表中用两个外键连接起了学生表和课程表
create table student_course(
    id int auto_increment comment '主键' primary key,
    studentid int not null comment '学生ID',
    courseid  int not null comment '课程ID',
    constraint fk_courseid foreign key (courseid) references course (id),
    constraint fk_studentid foreign key (studentid) references student (id)
)comment '学生课程中间表';

insert into student_course values (null,1,1),(null,1,2),(null,1,3),(null,2,2),(null,2,3),(null,3,4);

-- 一对一
-- 案例：一对一关系多用于单表拆分，将一张表的基础字段放在一张表中，其他详情字段发展另一张表中，从而提高操作效率
-- 实现：在任意一方加入外键，关联另一方的主键，并用unique约束外键
create table test_user(
    id int auto_increment primary key comment 'ID',
    name varchar(10) not null comment '姓名',
    age int check(age > 0 and age <= 100) comment '年龄',
    gender char(1) check(gender = '男' or gender = '女'),
    phone varchar(11) comment '手机号码'
) comment '测试表';

insert into test_user(id, name, age, gender, phone) values
                                                    (null,'黄渤',45,'男','18800001111'),
                                                    (null,'冰冰',35,'女','18800002222'),
                                                    (null,'码云',55,'男','18800008888'),
                                                    (null,'李彦宏',50,'男','18800009999');

create table test_edu(
    id int auto_increment primary key comment 'ID',
    degree varchar(5) not null comment '学位',
    university varchar(20) not null comment '毕业院校',
    userid int unique comment '用户id',
    constraint fk_userid foreign key(userid) references test_user(id)
) comment '教育表';

insert into test_edu(id, degree, university, userid) values
                                                     (null,'本科', '北京舞蹈学院', 1),
                                                     (null,'硕士', '北京电影学院', 2),
                                                     (null,'本科', '杭州师范大学', 3),
                                                     (null,'本科','清华大学', 4);

-- 多表查询
-- 直接多表查询会出现错误的结果，原因是笛卡尔积，产生的结果个数是第一个表个数 * 第二个表个数
-- 会根据建立联系的字段一一匹配，产生结果
select * from emp, dept;
-- 用建立联系的字段进行过滤后的查询结果才是正确的
-- 建立联系的字段为null的不参与查询
select * from emp, dept where emp.dept_id = dept.id;

-- 多表查询的分类
-- 一、连接查询
-- 1.内连接：相当于查询A、B交集部分的数据
-- 隐式内连接
-- select 字段列表 from 表1,表2 where 条件...;
select emp.name, dept.name from emp, dept where emp.dept_id = dept.id;
-- 若表名有些长，可以通过取别名的方式简化表名，取了别名之后，就只能使用别名
select e.name, d.name from emp as e, dept as d where e.dept_id = d.id;

-- 显式内连接
-- select 字段列表 from 表1 [inner] join 表2 on 连接条件...;
select e.name, d.name from emp e inner join dept d on e.dept_id = d.id;


-- 2.外连接：
--     (1).左外连接：查询左表的所有数据以及两张表交集部分的数据
-- select 字段列表 from 表1 left [outer] join 表2 on 条件...;
-- 查询emp表中的所有数据，和对应的部门信息(左外连接)
-- 左外连接会完全包含左表的数据，所以说即使左表中连接的数据是null，也可以成功的查到
select e.*, d.name from emp e left outer join dept d on e.dept_id = d.id;

--     (2).右外连接：查询右表的所有数据以及两张表交集部分的数据
-- select 字段列表 from 表1 right [outer] join 表2 on 条件...;
-- 右外连接会完全包含右表的数据，即使右表中的连接数据都是null，也可以查到（但全部都是null）
select e.*, d.name from emp e right outer join dept d on e.dept_id = d.id;

-- 3.自连接：当前表于自身的连接查询，自联结必须使用表的别名
-- select 字段列表 from 表A 别名A join 表A 别名B on 条件
select e1.name as '员工', e2.name as '领导' from emp as e1, emp as e2 where e1.managerid = e2.id;
select e1.name as '员工', e2.name as '领导' from emp as e1 join emp as e2 on e1.managerid = e2.id;
-- 必须要用外连接才可以将交集数据为null的数据成功查询到
select e1.name as '员工', e2.name as '领导' from emp as e1 left join emp as e2 on e1.managerid = e2.id;

-- 二、子查询
-- 在SQL语句中嵌套select语句，称为嵌套查询，又称为子查询
-- 子查询的外部语句可以是“增删改查”中的任意一个
-- 根据子查询查询的返回结果不同，可以分为：


-- 1.标量子查询（子查询结果为单个值）
-- 查询“销售部”的所有员工信息
-- 写成两个SQL语句
select id from dept where name = '销售部';
select * from emp where dept_id = 4;
-- 使用子查询
select * from emp where dept_id = (select id from dept where name = '销售部');

-- 查询在“方东白”入职之后的员工信息
select * from emp where entrydate > (select entrydate from emp where name = '方东白');


-- 2.列子查询（子查询结果为列）
-- 常用操作符：in, not in, any, some, all
-- in:在指定的集合范围之内，多选一
-- not in:不在指定的集合范围之内
-- any:子查询返回列表中，有任意一个满足即可
-- some:与any相同，能用some就能用any
-- all:子查询返回列表的所有值都必须满足

-- 案例：查询“销售部” 和 “市场部”的所有员工信息
select * from emp where dept_id in(select id from dept where name = '销售部' or name = '市场部');

-- 案例：查询比 财务部 所有人的工资都高的员工信息
select * from emp where salary > all(select salary from emp where dept_id = (select id from dept where name = '财务部'));

-- 案例：查询比 研发部 其中任意一人工资高的员工信息
select * from emp where salary > any(select salary from emp where dept_id = (select id from dept where name = '研发部'));
select * from emp where salary > some(select salary from emp where dept_id = (select id from dept where name = '研发部'));


-- 3.行子查询（子查询结果为一行）
-- 案例：查询与 “张无忌” 的薪资和其直属领导相同的员工信息
select salary, managerid from emp where name = '张无忌';   -- 这条SQL语句的查询结果会返回一行结果，分别是薪资和直属领导
select * from emp where (salary, managerid) = (select salary, managerid from emp where name = '张无忌');


-- 4.表子查询（子查询结果为多行多列）
-- 常用操作符：in
-- 常见用法，出现在from后面，当作一张临时的表使用

-- 案例：查询与“鹿杖客” 和 “宋远桥” 的职位和薪资相同的员工信息
select job, salary from emp where name = '鹿杖客' or name = '宋远桥';
-- 和行子查询不同，行子查询只有一行，所以说直接写=，而表子查询有多行，要写in
select * from emp where (job, salary) in (select job, salary from emp where name = '鹿杖客' or name = '宋远桥');

-- 案例：查询入职日期是“2006-01-01”之后的员工信息及其部门信息
-- a.入职日期是“2006-01-01”之后的员工信息
select * from emp where entrydate > '2006-01-01';
-- b.查询这部分员工对应的部门信息
-- 将上述的查询结果当作一张临时的表
select * from (select * from emp where entrydate > '2006-01-01') as temp_tb left join dept as d on temp_tb.dept_id = d.id;
-- 还可以根据子查询的位置，分为：where之后、from之后、select之后

-- 联合查询
-- union, union all
-- 对于联合查询，就是把多次查询的结果合并，形成一个新的查询结果集
-- select 字段列表 from 表A...
-- union [all]
-- select 字段列表 from 表B...
-- 联合查询两次查询的列数必须保持一致

-- 将薪资低于5000 和 年龄大于50岁的员工全部查询出来
select name, salary from emp where salary < 5000
union all
select name, age from emp where age > 20;

-- 只用union可以去重
select name, salary from emp where salary < 5000
union
select name, age from emp where age > 50;


