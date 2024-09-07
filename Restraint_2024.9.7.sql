-- 约束
-- 约束是作用在表中字段上的规则，用于限制存储在表中的数据
-- 目的：为了保证数据库中的数据的正确、有效、完整
-- 约束是作用于表中字段上的，可以在创建/修改表的时候添加约束

-- 分类
-- 非空约束 限制该字段中的数据不能为null       关键字：not null
-- 唯一约束 保证该字段中的数据都是唯一的       关键字：unique
-- 主键约束 主键是一行数据的唯一标识，要求其非空且唯一    关键字：primary key
-- 默认约束 在字段中保存数据时，若未指定字段中的值，则采用默认值     关键字：default
-- 检查约束 保证字段值满足某一个条件     关键字：check
-- 外键约束 用于让两张表的数据之间建立连接，保证数据的一致性和完整性     关键字：foreign key

use exercise;

-- 根据合理的约束条件，创建一张约束的用户表
create table user(
    id int primary key auto_increment comment '主键',
    name varchar(10) not null unique comment '姓名',
    age int check (age > 0 and age <= 120) comment '年龄',
    status char(1) default '1' comment '状态',
    gender char(1) check (gender = '男' or gender = '女')
) comment '用户表';
-- auto_increment 自动增长

insert into user(name, age, gender) values ('tom', 19, '男'),
                                           ('jack', 25, '男');
-- 违反这些约束，则会报错
-- 插入数据失败，但是主键会自增一次
insert into user(name) value('tom1');
insert into user(name) value('张三');

-- 外键约束
-- 两张表之间建立数据连接，具有外键的表是子表，被外键所关联的表是父表

-- 用部门表当作主表
create table dept(
    id int auto_increment primary key comment 'ID',
    name varchar(15) not null comment '部门名称'
) comment '部门表';
insert into dept(id, name) values(1, '研发部'), (2, '市场部'),(3, '财务部'), (4, '销售部'), (5, '总经办');

-- 用员工表中的部门id当作主表的外键
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

INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id) VALUES
                             (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),(2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
                             (3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),(4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),
                             (5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),(6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1);

-- 添加外键的语法：
-- 1. create table 表名{ [constraint] [外键名称] foreign key(外键字段名) references 主表(主表字段名)
-- 2. alter table 表名 add constraint 外键名称 foreign key(外键字段名) references 主表(主表字段名)
alter table emp add constraint fk_dep_id foreign key(dept_id) references dept(id);
-- 有了外键约束之后，为了保证数据的一致性，无法对外键约束的条目进行操作，因为默认是no action，想要操作主表中的条目时，先要删除相关的子表数据
-- delete from dept id; -- 报错，因为违反了外键约束
-- 先删除相关的子表数据，然后再操作主表中的条目

-- 删除外键
-- alter table 表名 drop foreign key 外键名
-- 删除外键后也可以对主表中的条目进行操作
alter table emp drop foreign key fk_dep_id_;
alter table emp drop foreign key fk_dep_id;

drop table emp;
drop table dept;
-- 外键的行为
-- alter table 表名 add constraint 外键名称 foreign key(外键字段名) references 主表(主表字段名) on update 行为 on delete 行为;

-- no action 作用是在尝试删除或更新主表中的记录时，如果这些记录在子表中有引用关系，则不允许进行删除或更新操作
-- 在创建外键时，若不指定行为选项，则默认的行为是no action

-- cascade(一连串的) 外键随着主表的更新而更新
alter table emp add constraint fk_dep_id_ foreign key(dept_id) references dept(id) on update cascade on delete cascade;

-- set null 它的作用是在删除或更新主表中的记录时，将子表中引用该记录的外键字段设置为null
alter table emp add constraint fk_dep_id_ foreign key(dept_id) references dept(id) on update set null on delete set null;

