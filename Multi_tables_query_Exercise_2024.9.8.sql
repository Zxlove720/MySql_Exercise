use exercise;
-- 数据准备
create table salgrade(
                         grade int,
                         losal int,
                         hisal int
) comment '薪资等级表';
insert into salgrade values (1,0,3000);
insert into salgrade values (2,3001,5000);
insert into salgrade values (3,5001,8000);
insert into salgrade values (4,8001,10000);
insert into salgrade values (5,10001,15000);
insert into salgrade values (6,15001,20000);
insert into salgrade values (7,20001,25000);
insert into salgrade values (8,25001,30000);


-- 多表查询练习
-- 查询员工的姓名、年龄、职位、部门信息
select e.name, e.age, e.job, d.name from emp as e, dept as d where e.dept_id = d.id;

-- 查询年龄小于30岁的员工的姓名、年龄、职位、部门信息
select e.name, e.age, e.job, d.name from emp as e inner join dept as d on e.dept_id = d.id where e.age < 30;

-- 查询拥有员工的部门id、部门名称
select d.id, d.name from emp as e, dept as d where e.dept_id = d.id; -- 这样结果会有大量重复
select distinct d.id, d.name from emp as e, dept as d where e.dept_id = d.id; -- 加上distinct关键字就可以去重

-- 查询所有年龄大于40岁的员工，及其归属的部门名称；若员工没有分配部门，也需要展示出来
-- 因为若没有分配部门，那么该员工的连接信息就是null，那么就不会参与查询，要用外连接才可以将其查到
select e.*, d.name from emp as e left join dept as d on e.dept_id = d.id where e.age >= 40;

-- 查询所有员工的工资等级，连接的条件有所变化
select e.*, s.grade from emp as e, salgrade as s where e.salary between s.losal and s.hisal;

-- 查询“研发部”所有的员工信息 及其 工资等级
select e.*, s.grade from emp as e, salgrade as s where e.salary between s.losal
    and s.hisal and e.dept_id = (select id from dept where name = '研发部');

-- 查询“研发部”员工的平均工资
select avg(e.salary) from emp as e, dept as d where e.dept_id = d.id and d.name = '研发部';

-- 查询工资比“灭绝”高的员工信息
select e.* from emp as e where salary > (select salary from emp where name = '灭绝');

-- 查询比平均薪资高的员工信息
select avg(salary) from emp;
select e.* from emp as e where e.salary > (select avg(salary) from emp);
-- 查询低于平均工资的员工信息
select e.* from emp as e where e.salary < (select avg(salary) from emp);

-- 查询低于本部门平均工资的员工信息
select * from emp as e1  where e1.salary < (select avg(e2.salary) from emp as e2 where e2.dept_id = e1.dept_id);

-- 查询所有的部门信息，并统计该部门的员工数量
select d.id, d.name, (select count(*) from emp as e where e.dept_id = d.id) as '人数' from dept as d;

-- 查询所有学生的选课情况，展示学生名称、学号、课程名称
-- 三个表之间，想要消除笛卡尔积，至少需要两个连接条件
-- student.id = student_course.studentid，course.id = student_course.courseid
select s.name, s.no, c.name from student as s, student_course as sc, course as c where s.id = sc.studentid and sc.courseid = c.id;


