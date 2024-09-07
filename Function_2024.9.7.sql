-- 函数 函数是可以直接被另一个程序调用的程序或代码
-- 字符串函数
-- concat(s1, s2, ..., sn) 字符串拼接，将s1 - sn拼接成一个字符串
select concat('hello', 'MySql');

-- lower(str) 将字符串str全部转为小写
select lower('HELLO');

-- upper(str) 将字符串str全部转为大写
select upper('hello');

-- lpad(str, n, pad) 用字符串pad，对str的左边进行填充，使str达到n个字符串长度
select lpad('01', 5, '-');

-- rpad(str, n, pad) 用字符串pad，对str的右边进行填充，使str达到n个字符串长度
select rpad('01', 5, '-');

-- trim(str) 去掉字符串头部和尾部的空格（仅限头尾，中间不管）
select trim('   hello world   ');

-- substring(str, start, len) 返回字符串str从start位置起的len个长度的子串
-- 注意：MySql中的substring中的索引是从1开始的，而不是为0
select substring('hello world', 1, 5);


-- 案例
-- 改变员工的工号，统一为5位数，不足5位数的在前面补0
update emp_info set id = lpad(id, 5, '0');


-- 数值函数
-- ceil(x) 向上取整
select ceil(4.01);
select ceil(4.99);

-- floor(x) 向下取整
select floor(4.99);
select floor(4.01);

-- mod(x, y) 返回x % y
select mod(5, 2);

-- rand() 返回0 - 1 的随机数
-- 看似只能生成0-1的，但可以配合乘法，生成比1大的随机数
select rand();

-- round(x, y) 求x四舍五入的值，保留y位小数
select round(4.495, 2);
select round(4.494, 2);

-- 案例：通过数据库中的函数，生成一个六位数的验证码
-- 分析：rand函数可以生成0-1的随机数，可以通过*1000000来得到一个随机的六位数，并通过round四舍五入，
-- 假如遇到特殊情况，只有五位数，那么通过rpad，为其后面补0，限定其长度为6，建议用lpad，看着好看一点

select rpad(round(rand() * 1000000, 0) , 6, 0);
select lpad(round(rand() * 1000000, 0) , 6, 0);

-- 日期函数
-- curdate() 返回当前日期，返回的是一个date
select curdate();
-- curtime() 返回当前时间，返回的是一个date
select curtime();
-- now() 返回当前的日期和时间
select now();
-- year(date) 获取指定date的年份
select year(curtime());
-- month(date) 获取指定date的月份
select month(now());
-- day(date) 获取指定date的日期
select day(now());
-- date_add(date, interval expr type) 返回一个日期/时间值加上一个时间间隔expr后的时间值
select date_add(now(), interval 70 month);
-- datediff(date1, date2) 返回起始时间date1和结束时间date2之间的天数，是date1 - date2
select datediff('2004-10-14', '1998-08-29');

-- 案例，查询员工的入职天数，并且根据其进行倒序排序
select name, datediff(curdate(), entrydate) as 'entryDays' from emp_info order by entryDays desc;

-- 流程函数
-- if(value, t, f) 如果value为true，则返回t，否则返回f
select if (true, 'TRUE', 'FALSE');
select if (false, 'TRUE', 'FALSE');
-- ifnull(value1, value2) 如果value1不为空，则返回value1，否则返回value2
select ifnull('not null', 'null');
select ifnull(null, 'null');
-- case when [val1] then [res1] ... else [default] end 如果val1为true，返回res1，否则返回default默认值；when-then可以写多个
-- 案例 查询员工信息，查询其地址，若为川渝，则输出川渝地区
select
    name,
    ( case address when '重庆' then '川渝地区' when '四川' then '川渝地区' else '其他地区' end ) as '籍贯'
from emp_info;
-- case [expr] when [val1] then [res1] ... else [default] end 如果expr的值等于val1，那么返回res1，否则返回default默认值
