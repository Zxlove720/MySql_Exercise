use exercise_linux;


-- SQL性能分析


-- 想要对SQL进行性能优化，必须先知道其不同的SQL语句执行的频率，知道其增删改查哪个操作用的多，然后再对应进行优化
-- show [session|global] status 显示服务器状态信息
-- 然后就可以进行对服务器状态模糊匹配 like 'com_______' (7个下划线) 看到当前数据库增删改查的频率
show global status like 'com_______';
-- 这样就可以看到对应增删改查的频率

-- 若一个数据库中查询占绝大部分，那么就需要针对其进行优化


-- 慢查询日志
-- 可以查询到哪些Sql语句的效率较低，然后对于效率较低的Sql语句进行优化
-- 慢查询日志记录了所有执行时间超过了指定参数（long_query_time, 单位：s，默认10s）的所有Sql语句
-- MySql的慢查询日志默认关闭，需要手动配置

-- 查询慢查询日志是否开启
show variables like 'slow_query_log';
-- 配置慢查询日志
-- 1.开启MySql慢查询日志开关
-- slow_query_log = 1
-- 2.设置慢查询日志时间为2s，Sql语句执行时间超过2S，则视为慢查询，则被记录
-- long_query_time = 2



-- Profile 详情
-- show profile能够在Sql优化时帮助我们了解时间耗费到何处去了，可以通过have_profiling参数，查看当前MySql是否支持profile操作
-- 查询是否支持profile
select @@have_profiling;
-- 默认profiling是关闭的，可以通过set在session/global级别中开启profiling
select @@profiling;
set profiling = 1;

-- 通过profile监视Sql耗时情况
select * from tb_user;
select * from tb_user where id = 1;
select * from tb_user where name = '白起';

-- 查询在当前会话中Sql语句的耗时情况
show profiles;
-- 查询指定query_id的Sql语句各个阶段的耗时情况
-- show profile for query query_id;
-- query_id必须存在，并且是正确的
show profile for query 322;
show profile cpu for query 359;
select version();

-- explain执行计划
-- explain或者desc命令获取MySql如何执行select语句的信息，包括select语句执行过程中表如何连接极其连接的顺序
-- 语法：直接在select语句前加上关键字explain/des
-- explain/desc select 字段列表 from 表名 where 条件
explain select * from tb_user where name = '吕布';
desc select * from tb_user where name = '吕布';
-- explain执行计划中各字段的含义
-- id：select查询的序列号，表示查询中执行select子句或者操作表的顺序（id相同，执行顺序从上到下；id不同，id大的先执行）

-- select_type：表示select的类型，常见取值为simple（简单表，即不适用表连接或子查询）、primary（主查询，即外层查询）
-- union（union中的第二个或者后面的查询语句）、subquery（select/where之后包含了子查询）；这个参考价值不大

-- type：表示连接类型，性能由好->差的连接类型为null、system、const、eq_ref、ref、range、index、all，优化时尽量往前优化
-- 虽然null的性能是最好的，但是在真实的业务开发中，不可能达到null，因为null是不查询任何表才可以达到的
-- const是使用主键/唯一索引查询出现的type；ref是非唯一索引查询出现的type

-- key：实际使用的索引，如果为null，则没有使用索引

-- key_len；表示索引中使用的字节数，该值为索引字段最大的可能长度，而非实际长度，在不损失精确性的前提下，长度越短越好

-- rows：MySql认为必须执行查询的行数，但是在innoDB存储引擎中，可能并不准确

-- filtered：表示返回结果的行数占需要读取行数的百分比，filtered的值越大越好
