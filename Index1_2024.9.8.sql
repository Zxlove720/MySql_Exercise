-- MySql的索引是在存储引擎层实现的，不同的存储引擎有不同的结构
-- 几种主要的索引结构

-- 1.B+Tree 最常见的索引类型，大部分的引擎都支持
-- 支持：InnoDB、MylSAM、Memory

-- 2.Hash 底层的数据结构由hash表实现，只有精确匹配索引列的查询才有效，hash索引不支持范围查询
-- 支持：Memory
-- 实现原理：采用一定的hash算法，将键值计算为新的hash值，映射到hash表中对应的位置，存储在hash表中
-- 特点：1.hash索引只能用于对等比较（“=” 或 “in”），不支持范围查询（between，>，<......）
--       2.无法利用索引进行排序
--       3.查询效率极高，若避免哈希碰撞，通常只需检索一次就可以成功查询

-- 3.R-tree（空间索引） 空间索引是MylSAM引擎的一个特殊的索引类型，主要用于地理空间数据类型，适用面较少
-- 支持MylSAM

-- 4.Full-text（全文索引） 是一种通过建立倒排索引，快速匹配文档的方式
-- 5.6之后的InnoDB支持、MylSAM支持





-- 索引的分类
--      1.主键索引：针对表中的主键创建索引       特点：默认自动创建主键索引，只能有一个主键索引       关键字：primary
--      2.唯一索引：避免同一个表中某数据列中的值重复     特点：可以有多个     关键字：unique
--      3.常规索引：快速定位特定数据     特点：可以有多个
--      4.全文索引：全文索引是查找文本中的关键词，而不是比较索引中的值     特点：可以有多个     关键字：fulltext

-- 在InnoDB存储引擎中，根据索引的存储形式，可以分为聚集索引和二级索引
--      1.聚集索引：将数据存储和索引放在一块，索引结构的叶子节点保存了这一行的数据     特点：有且仅有一个
--      2.二级索引（辅助索引）：将数据存储和索引分开，索引结构的叶子节点关联其对应的主键     特点：可以存在多个

-- InnoDB存储的查询示例
/* 假如查询一张表，id是主键；那么id就会根据id创造一个聚集索引，数据结构是B+Tree，叶子节点存的是id值和id对应的这一行的数据
   如果根据id进行查找，就会找到id，从而找到id对应的一行的数据；字段name会创造出一个二级索引，数据结构也是B+Tree，但是叶子
   节点存储的是name和name所对应的id，若想根据name查到其他的，则会通过id值，回到聚集索引中，根据id找到对应的行的数据，
   这种方式也称为回表查询 */

-- 数据准备

create database exercise_linux;

use exercise_linux;

create table tb_user(
                        id int primary key auto_increment comment '主键',
                        name varchar(50) not null comment '用户名',
                        phone varchar(11) not null comment '手机号',
                        email varchar(100) comment '邮箱',
                        profession varchar(11) comment '专业',
                        age tinyint unsigned comment '年龄',
                        gender char(1) comment '性别 , 1: 男, 2: 女',
                        status char(1) comment '状态',
                        createtime datetime comment '创建时间'
) comment '系统用户表';

INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('吕布', '17799990000', 'lvbu666@163.com', '软件工程', 23, '1', '6', '2001-02-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('曹操', '17799990001', 'caocao666@qq.com', '通讯工程', 33, '1', '0', '2001-03-05 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('赵云', '17799990002', '17799990@139.com', '英语', 34, '1', '2', '2002-03-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('孙悟空', '17799990003', '17799990@sina.com', '工程造价', 54, '1', '0', '2001-07-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('花木兰', '17799990004', '19980729@sina.com', '软件工程', 23, '2', '1', '2001-04-22 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('大乔', '17799990005', 'daqiao666@sina.com', '舞蹈', 22, '2', '0', '2001-02-07 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('露娜', '17799990006', 'luna_love@sina.com', '应用数学', 24, '2', '0', '2001-02-08 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('程咬金', '17799990007', 'chengyaojin@163.com', '化工', 38, '1', '5', '2001-05-23 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('项羽', '17799990008', 'xiaoyu666@qq.com', '金属材料', 43, '1', '0', '2001-09-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('白起', '17799990009', 'baiqi666@sina.com', '机械工程及其自动化', 27, '1', '2', '2001-08-16 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('韩信', '17799990010', 'hanxin520@163.com', '无机非金属材料工程', 27, '1', '0', '2001-06-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('荆轲', '17799990011', 'jingke123@163.com', '会计', 29, '1', '0', '2001-05-11 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('兰陵王', '17799990012', 'lanlinwang666@126.com', '工程造价', 44, '1', '1', '2001-04-09 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('狂铁', '17799990013', 'kuangtie@sina.com', '应用数学', 43, '1', '2', '2001-04-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('貂蝉', '17799990014', '84958948374@qq.com', '软件工程', 40, '2', '3', '2001-02-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('妲己', '17799990015', '2783238293@qq.com', '软件工程', 31, '2', '0', '2001-01-30 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('芈月', '17799990016', 'xiaomin2001@sina.com', '工业经济', 35, '2', '0', '2000-05-03 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('嬴政', '17799990017', '8839434342@qq.com', '化工', 38, '1', '1', '2001-08-08 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('狄仁杰', '17799990018', 'jujiamlm8166@163.com', '国际贸易', 30, '1', '0', '2007-03-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('安琪拉', '17799990019', 'jdodm1h@126.com', '城市规划', 51, '2', '0', '2001-08-15 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('典韦', '17799990020', 'ycaunanjian@163.com', '城市规划', 52, '1', '2', '2000-04-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('廉颇', '17799990021', 'lianpo321@126.com', '土木工程', 19, '1', '3', '2002-07-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('后羿', '17799990022', 'altycj2000@139.com', '城市园林', 20, '1', '0', '2002-03-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('姜子牙', '17799990023', '37483844@qq.com', '工程造价', 29, '1', '4', '2003-05-26 00:00:00');

select * from tb_user;

-- 创建索引
-- create [unique|fulltext] index index_name on table_name (index_col_name,...);
-- (index_col_name)是索引关联的字段，若一个索引只关联一个字段，则称为单列索引；若一个索引关联了多个字段，则称为联合（组合）索引

-- 1.name字段为姓名字段，可能会重复，为该字段创建索引
create index idx_user_name on tb_user(name);
-- 2.phone手机号字段的值是非空、唯一的，为该字段创建唯一索引
create unique index idx_user_phone on tb_user(phone);
-- 3.为profession、age、status创建联合索引
create index idx_user_pro_age_sta on tb_user(profession, age, status); -- 联合索引的字段顺序有讲究
-- 4.为Email创建合适的索引提升查询效率
create unique index idx_user_email on tb_user(email);

-- 查看索引（查看指定表中的索引）
-- show index from table_name
show index from tb_user;
-- 删除索引（删除指定表中的索引）
-- drop index index_name on table_name
create index idx_user_cr on tb_user(createtime);
drop index idx_user_cr on tb_user;


