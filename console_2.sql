# -- 查看当前已经存在的数据库
# show databases;
#
# -- 创建一个新的数据库，主要存放用户信息
# create database if not exists users;
#
# -- 转到该数据库
# use users;
#
# -- 查看是否成功进入该数据库
# select database();
#
# -- 查看该库中的存在的表
# show tables;
#
# -- 创建一个表，用于存储用户信息
# -- 括号内是：列名 + 类型
# -- comment相当于注释，每一列后的comment相当于是这行的注释，而括号外的注释相当于整张表的注释
# create table if not exists tb_users(
#     user_name varchar(15) comment '用户名',
#     password varchar(20) comment '密码',
#     Email varchar(25) comment '电子邮箱',
#     phone_number char(11) comment '手机号码'
# ) comment '用户信息表';
#
# -- 查看这张表的结构
# describe tb_users;
#
# -- 为这张表添加信息，列和信息要一一对应
# -- 为指定的列添加信息（假如指定的列是全部，则完整添加了一行信息）
# -- 注意！如果使用 value，只能插入一行数据。想要插入多行数据，需要使用 values
# insert into tb_users(user_name, password, Email, phone_number) values('root', '123456', 'linux@qq.com', '12345678902');
# -- 为所有的列添加信息（完整添加了一行信息）
# insert into tb_users values('administer', '654321', 'microsoft@qq.com', '98765432101');
# -- 为所有的列添加多条信息（完整添加多行信息）
# insert into tb_users values('user1', '123456', 'microsoft@qq.com', '14725836901'),
#                           ('user2', '654321', 'iphone@qq.com', '96325874101');
#
# -- 添加信息之后，查看这张表
# select * from tb_users;


-- 练习创建库、表；然后查表
-- 查看当前数据库
show databases;
-- 创建数据库
create database if not exists users_test;
-- 转到数据库
use users_test;
-- 查看是否成功进入该数据库
select database();
-- 查看该库中的所有表
show tables;
-- 创建一个表
create table if not exists tb_test(
    userName varchar(15) comment '用户名',
    password varchar(20) comment '密码',
    phoneNumber char(11) comment '手机号码',
    uid varchar(10) comment '用户id'
) comment '用户表测试版';

-- 查看该表的结构
describe tb_test;

-- 为表添加信息
-- 这是按照指定的条目进行添加（如果包含所有条目，则相当于添加一行）
insert into tb_test (userName, password, phoneNumber, uid) values('root', '123456', '12345678911', '1');
-- 这是直接添加一行
insert into tb_test values('administer', '654321', '98765432111', '2');
-- 这是直接添加多行
insert into tb_test values('iphone', '147852', '87945631200', '3'),
                          ('android', '963258', '48579543211', '4'),
                          ('ubuntu', '123456', '45687856432', '5');

-- 查看这张表
select * from tb_test;

-- 为这张表插入一个信息
insert into tb_test values('centOS7', '456870', '14645645613', '6');
insert into tb_test values('centOS8', '456870', '14645645613', '6');

-- 删除这张表中的一个信息
delete from tb_test where userName = 'centOS8';

-- 查看这张表，用where加入条件过滤
select * from tb_test where uid < 4;
-- 查看这张表中的用户名和密码，用where加入条件过滤
select userName, password from tb_test where uid < 4;

-- 用聚合函数查看表
select count(uid) from tb_test;
-- select sum(password) from tb_test;
select min(uid) from tb_test;
select max(uid) from tb_test;
-- select avg(uid) from tb_test;
-- 聚合函数还可以搭配where进行过滤
select avg(uid) from tb_test where uid <= 3;

-- 分组查询，可以配合where进行过滤
select userName, count(*) from tb_test where uid >= 3 group by userName;
select password, count(*) from tb_test where uid >= 3 group by password having count(*) > 1;

-- 排序（默认升序）asc
select * from tb_test order by uid asc;
-- 排序 降序 desc
select * from tb_test order by uid desc;
-- 多种排序规则
select * from tb_test order by uid asc, password desc;





