-- insert into table中，指定的列和后面插入的信息，必须一一对应
-- 在指定的列中插入一条记录，列名和对应的值必须一一对应
insert into emp_info(id, worknumber, name, gender, age, idcard, entrydate, username)
values (1, '1', '张三', '男', 18, '123456789987654321', '2000-10-14', '123456');

-- 在所有列中插入多条记录，按顺序提供值
insert into emp_info values(3, '3', '王五', '男', 18, '456654123321789978', '1998-2-5', '789456'),
                           (4, '4', '赵六', '男', 19, '132654789978456123', '1999-2-6', '789455');

-- desc是describe的缩写，用途是描述指定表的结构
desc emp_info;

-- 创建一个新的数据库，若数据库已经存在则无效
create database test_database;
-- 创建一个新的数据库，但是要先判断该数据库是否已经存在，若已存在，那么就不会创建
create database if not exists test_database;

-- 删除一个数据库，若数据库不存在则报错
drop database test_database;
-- 删除一个数据库，但是先判断该数据库是否已经存在，若存在才删除
drop database if exists test_database;

-- 切换数据库
use exercise;
use student;
-- 如果不存在该数据库那么就报错
-- use my_database;

-- 展示所有的数据库
show databases;

-- 显示当前处于哪个数据库中
select database();

-- 展示当前处于的数据库中的所有的表
show tables;

use test_database;
select * from emp_info;