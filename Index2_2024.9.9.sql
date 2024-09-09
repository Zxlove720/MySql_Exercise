use exercise_linux;
-- 索引使用
-- 最左前缀法则（联合索引才遵循）
-- 如果使用了多列（联合索引），要遵守最左前缀法则；最左前缀法则是指查询从索引的最左列开始，并且不能跳过索引中的
-- 任何一列；若跳过了某一列，那么索引将部分失效（跳过那列之后的字段的索引将失效）

-- 查询一张表中存在的索引
show index from tb_user;     -- 发现profession、age、status构成一个联合索引
-- 案例
explain select * from tb_user where profession = '软件工程' and age = 31 and status = '0';
-- 可见其type是ref，说明使用了索引，而确实也使用了索引
explain select * from tb_user where profession = '软件工程' and age = 31;
-- 只根据两个条件查询，但中间没有跳过任何一列，所以说type仍然是ref，实际上仍然使用了索引
explain select * from tb_user where profession = '软件工程';
-- 只根据两个条件查询，但中间没有跳过任何一列，所以说type仍然是ref，实际上仍然使用了索引
explain select * from tb_user where age = 31 and status = '0';
-- type变成all，说明是全表查询，没有使用索引，因为跳过了profession这一列，但是age和status都在其之后，所以说其索引失效
explain select * from tb_user where status = '0';
-- type变成all，说明是全表查询，没有使用索引，因为跳过了profession这一列，但是age和status都在其之后，所以说其索引失效

-- 注：即使不按照索引关联顺序，并不会影响到索引，字段只需要存在
explain select * from tb_user where age = 31 and status = '0' and profession = '软件工程';



-- 范围查询
-- 在联合索引中，若出现范围查询<, >，范围查询右侧的列索引失效
explain select * from tb_user where profession = '软件工程' and age > 30 and status = '0';
-- 用了索引，但是根据key_len可以判断，status的索引并没有使用，因为在查询age时用了范围查询，所以说其右侧索引失效
explain select * from tb_user where profession = '软件工程' and age >= 30 and status = '0';
-- 虽然范围查询可以使范围查询右侧的索引失效，但是≥和≤不这种范围查询不会使右侧索引失效，所以说只要业务允许，在范围查询时应该使用≥这种



-- 索引列运算
-- 不要在索引列上进行运算操作，否则索引将失效
explain select * from tb_user where phone = '17799990015';
-- type为const 且 使用了索引
explain select * from tb_user where substring(phone, 10, 2) = '15';
-- type为all 且 没有使用索引，因为在索引上使用了substring进行函数运算，所以说索引失效了

-- 字符串要加引号
-- 字符串类型字段使用时，若不加引号，索引将失效
select * from tb_user where phone = 17799990015;
-- phone是varchar类型的字符串，但是查询时不加引号也可以正确的查询
explain select * from tb_user where phone = 17799990015;
-- 但是type是all，是全表查询，索引失效了，所以说字符串类型的字段使用时必须严格加上双引号



-- 模糊查询
-- 若是尾部进行模糊匹配，索引不会失效；若头部进行模糊匹配，则索引失效
-- 进行尾部模糊匹配，索引没有失效
explain select * from tb_user where profession like '软件%';
-- 进行头部模糊匹配，索引失效
explain select * from tb_user where profession like '%工程';
-- 所以说在大数据量的情况下，一定要避免头部的模糊匹配，否则会极大影响效率



-- or连接的条件
-- 使用or分割开的条件，若or前的条件中的条目有有索引，而后面的条目中没索引，那么不会使用任何的索引，索引将失效
-- 必须要or前后的条件的条目中均存在索引，才可以使用索引
explain select * from tb_user where id = 10 or age = 23;
-- 这条SQL不会使用索引，因为id有索引；而age没有索引（age有联合索引，但是左侧的条目被跳过了，根据最左前缀法则，age索引失效）

explain select * from tb_user where id = 10 or profession = '软件工程';
-- 这条SQL就有索引了，因为id有索引，profession有联合索引，且没有跳过条目，or前后的条件的条目中均存在索引，所以说索引生效



-- 数据分布影响——可以理解为，若查找出来的数据是大部分的，则不会使用索引（全表扫描更快），查找出来的数据是少部分的，则会使用索引
-- 若MySql评估使用索引比全表扫描更慢，则不使用索引
explain select * from tb_user where phone >= '17799990000';
select * from tb_user where phone >= '17799990000';
-- 因为用该条件去查找数据，所有数据都会被找到，所以说MySql评估全表扫描的速度优于使用索引，所以说不会使用索引



-- Sql提示，若字段有多个索引，可以通过Sql提示选择索引使用或选择索引不用
-- Sql提示，是优化数据库的一个重要手段，简单而言，就是在Sql语句中加入一些人为的提示来达到优化操作的目的

create index idx_user_pro on tb_user(profession);

-- use index ：提示Sql要用哪一个索引
-- 注意：use index 只是一个建议，MySql评估效率之后可能不会接受你的建议
-- explain select * from tb_user use index(index_name) where ... ;
explain select * from tb_user where profession = '软件工程';
-- 可能的索引列表中有profession条目所有的索引，然后会根据MySql的评估来选择一个索引使用
explain select * from tb_user use index(idx_user_pro) where profession = '软件工程'; -- 指定了之后
-- 可能的索引列表中只有指定的索引，成功指定了索引

-- ignore index ：提示Sql要忽略（不要用）哪一个索引
-- explain select * from tb_user ignore index(index_name) where ... ;
explain select * from tb_user ignore index(idx_user_pro_age_sta, idx_user_pro) where profession = '软件工程';
-- ignore index()，忽略了指定的索引，MySql就不会在被忽略的索引中选择了

-- force index ：强制Sql必须用哪一个索引，不是建议，是强制！
-- explain select * from tb_user force index(index_name) where ...;
explain select * from tb_user force index(idx_user_pro) where profession = '软件工程';
-- force 强制MySql必须使用指定的索引

explain select * from tb_user where profession = '软件工程' and age = 31 and status = '0';

-- 覆盖索引
-- 在查询中尽可能的使用覆盖索引（查询使用了索引，并且需要返回的列在该索引中能够全部找到），其目的是为了减少回表查询
-- 同样，为了减少回表查询，尽量不要使用select*

-- 一个避免了回表查询的Sql语句
select id, profession, age, status from tb_user where profession = '软件工程' and age= 31 and status = '0';
explain select id, profession, age, status from tb_user where profession = '软件工程' and age= 31 and status = '0';

-- 一个导致了回表查询的Sql语句
select name, id, profession, age, status from tb_user where profession = '软件工程' and age= 31 and status = '0';
-- 因为返回的列在索引中无法全部找到，所以说需要回表查询，效率降低



-- 前缀索引
-- 当字段类型为字符串（varchar，text等）时，有时候需要很长的字符串，这会使得索引变得很大，查询时浪费IO，影响查询效率
-- 那么此时可以只将字符串的一部分前缀建立索引，可以极大节约索引空间，从而提高效率

-- 前缀长度：可以根据索引的选择性决定，选择性是指：不重复的索引值（基数）和数据表的记录总数的比值，索引选择性越高则查询
-- 效率越高，唯一索引的选择性是1，这是最好的、性能最好的索引
-- select count(distinct email) / count(*) from tb_user;
-- select count(distinct substring(email, 1, 5)) / count(*) from tb_user;
-- 不断的尝试算选择性，越接近于1越好，但是也需要考虑前缀的长度，二者是成反比的，前缀越短，效率高了；选择性低了



-- 单列索引和联合索引的选择问题
-- 在业务场景，如果存在多个查询条件，考虑针对查询字段建立索引时，建议建立联合索引，而非单列索引，可以避免回表查询

-- 多表联合查询时，MySql优化器会评估哪个字段的索引效率更高，会选择效率高的索引完成本次查询


-- 索引设计的原则

-- 1.针对数据量大（至少得万级），且查询频繁的表建立索引

-- 2.针对于常作为查询条件（where）、排序（order by）、分组（group by）操作的字段建立索引

-- 3.尽量选择区分度高的列作为索引，尽量建立唯一索引，区分度越高，使用索引的效率越高（性别这种列的区分度就十分低）

-- 4.如果是字符串类型的字段，字段的长度较长，建议根据字段的特点，建立前缀索引

-- 5.尽量使用联合索引，减少单列索引的使用，因为在查询时，联合索引很多时候可以覆盖索引，节省存储空间，避免回表查询

-- 6.要控制索引的数量，并非索引越多越好，索引多了之后，维护索引的代价也就越大，会影响效率

-- 7.若索引列不能存储null值，那么在创建表时就应该用not null约束，优化器若知道每列是否包含null值，可以更好的确定用哪个索引有效查询





