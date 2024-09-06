show databases;
use exercise;
select * from emp_info order by id desc;

-- 分页查询，这是sql中的方言
-- limit总是在sql语句中的最后
-- 方言：不同的数据库对于同一个东西，有不同的实现
-- 如果查询第一页，则起始索引的参数可以省略
select * from emp_info limit 0,5;
-- 这二者是等价的
select * from emp_info limit 5;
-- 查询第二页的员工数据，每页展示两条记录 ---> 第一个参数是（页码 - 1） * 每页展示的记录数， 第二个参数是这一页要 展示的记录数
select * from emp_info limit 2, 5;
-- 分页查询，每一页3条数据
select * from emp_info limit 0,3;
select * from emp_info limit 3,3;
select * from emp_info limit 6,3;
select * from emp_info limit 9,3;

select * from emp_info where gender = '女' and age > 0;
select * from emp_info where gender = '男' and age between 18 and 100 and name like '___';
select gender, count(*) from emp_info where age <= 60 group by gender;

-- DQL语句的编写顺序
-- select, from, where, group by, having, order by, limit
-- DQL语句的执行顺序
-- from, where, group by, having, select, order by, limit

-- mysql数据库是mysql中的系统数据库
-- 其中user这张表是专门用来存储用户信息的表
use mysql;
select * from user;
show grants for 'faker'@'localhost';
-- 创建一个新的用户
-- create user 用户名@主机名 identified by 密码
create user 'faker'@'localhost' identified by '262460';
-- 修改一个用户的密码
-- alter user 用户名.主机名 identified with 身份验证插件 by 新密码
alter user 'faker'@'localhost' identified with mysql_native_password by '123456';
-- 删除用户
-- drop user 用户名.主机名
drop user 'faker'@'localhost';

-- 查询用户权限
-- show grants for 用户名@主机名
show grants for 'faker'@'localhost';
show grants for 'root'@'localhost';
-- 授予权限
-- grant 权限列表 on 数据库名.表名 to 用户名.主机名; （*是通配符，代表所有，*.*相当于所有数据库中的所有表）
grant all on *.* to 'faker'@'localhost';
-- 提供查询的权限
grant select on *.* to 'faker'@'localhost';
-- 提供插入、删除的权限
grant insert on *.* to 'faker'@'localhost';
grant delete on *.* to 'faker'@'localhost';


-- 撤销权限
-- revoke 权限列表 on 数据库名.表名 from 用户名.主机名
revoke all on *.* from 'faker'@'localhost';


