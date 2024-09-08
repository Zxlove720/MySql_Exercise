-- 事务 transaction
-- 事务是一组操作的集合，是一个不可分割的工作单位，事务会将所有的操作作为一个整体一起向系统提交或撤销请求
-- 事务的操作要么同时成功，要么同时失败
-- MySql的事务默认是自动提交的，当执行一个DML语句，MySql会立即自动隐式提交事务

-- 常见案例：银行转账
-- 逻辑：A给B转账1000：1.查询A账户的余额 2.A账户余额 - 1000 3.B账户余额 + 1000
-- 这三步只能同时成功，或者同时失败；所以说这三步操作要成为一个事务

-- 数据准备
create table account(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    money int comment '余额'
) comment '账户表';
insert into account(id, name, money) VALUES (null,'张三',2000),(null,'李四',2000);
commit;

-- 恢复数据
update account set money = 2000 where name = '张三' or name = '李四';
commit;

-- 事务的两种方式
-- 1.设置事务为手动提交
set @@autocommit = 0;
set @@autocommit = 1;
select @@autocommit;

-- 执行转账逻辑（成功完成）
select money from account where name = '张三';
update account set money = money - 1000 where name = '张三';
update account set money = money + 1000 where name = '李四';

-- 执行转账逻辑（转账失败）
select money from account where name = '张三';
update account set money = money - 1000 where name = '张三';
update account set money = money + 1000 where name = '李四';
-- 失败示例：转账失败！update account set money = money + 1000 where name = '李四';
-- 通过事务的回滚，成功保证了数据的完整、正确

-- 事务若全部执行成功，那么commit
commit;
-- 若事务执行过程中有异常，那么回滚事务
rollback;

-- 2.用开启事务的方式
-- start transaction 或 begin
start transaction;

-- 执行转账逻辑
select money from account where name = '张三';
update account set money = money - 1000 where name = '张三';
update account set money = money + 1000 where name = '李四';
-- 转账失败！update account set money = money + 1000 where name = '李四';

-- 成功则提交，失败则回滚
commit;

rollback;

-- 事务的四大特性
-- 1.原子性(Atomicity)：事务是不可分割的最小操作单元，要么全部成功；要么全部失败
-- 2.一致性(Consistency)：事务完成时，必须使所有的数据都保持一致状态
-- 3.隔离性(Isolation)：数据库系统提供事务隔离机制，保证事务在不受外部并发操作影响的独立环境下运行
-- 4.持久性(Durability)：事务一旦完成，对于数据库中的数据改变是永久的

-- 并发引起的事务问题
-- 脏读：由于多线程，一个事务读取到了另外一个事务还没提交的数据
-- 不可重复读：一个事务先后读取同一条记录，但是两次读取的数据不同
-- 幻读：一个事务查询数据时，没有对应的数据行；但是在插入数据时，发现该数据行已经存在了，仿佛一个幻影

-- 事务隔离级别：隔离级别越高，性能越差（性能和安全性需要综合考虑）
-- Read uncommited：最低的隔离级别，不能解决并发引起的事务问题
-- Read commit(Oracle的默认隔离级别)：Oracle默认的隔离级别，可以解决脏读问题
-- Repeatable Read(MySql的默认隔离级别)：MySql默认的隔离级别，可以解决脏读、不可重复读的问题
-- Serializable：最高的隔离级别，可以解决一切并发引起的事务问题

-- 查看事务的隔离级别
select @@transaction_isolation;
-- 设置事务的隔离级别
-- set [session|global] transaction isolation level {隔离级别}   | session是当前对话；global是全部对话


-- 存储引擎
-- 查看可以使用的存储引擎
show engines;
-- 默认存储引擎
-- INNODB
-- INNODB和MylSAM的区别：INNODB支持事务、外键、行级锁

-- 绝大部分情况都是使用INNODB引擎，其可以保证数据的完整性，数据安全；存储核心数据
-- MylSAM一般存储非核心的数据，不太能保证安全性




