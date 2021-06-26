
本文的题目为 leetcode SQL 的第 1 ~ 5 题，题目和主要技术点如下:

| 题目                                                                                                   | 技术点                                                                                                |
| --                                                                                                     | --                                                                                                    |
| [175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables)                                 | 左连接(《SQL必知必会》13-2)                                                                           |
| [176. 第二高的薪水](https://leetcode-cn.com/problems/second-highest-salary)                            | 子查询(《SQL必知必会》11) <br> LIMIT, OFFSET(《SQL必知必会》2-6) <br> ISNULL函数                      |
| [177. 第N高的薪水](https://leetcode-cn.com/problems/nth-highest-salary)                                | 自定义函数(CREATE FUNCTION) <br> 声明变量(DECLARE), 变量赋值(SET)                                     |
| [178. 分数排名](https://leetcode-cn.com/problems/rank-scores)                                          | 排名相关的窗口函数 <br> RANK/DENSE_RANK/ROW_NUMBER                                                    |
| [180. 连续出现的数字](https://leetcode-cn.com/problems/consecutive-numbers)                            | 自连接(《SQL必知必会》13-2) <br> 使用窗口函数并构造新属性 <br> 分组查询与过滤分组 (《SQL必知必会》10) |

---

# [175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables)

## 题目描述

```plain
表1: Person
+-------------+---------+
| 列名         | 类型     |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId 是上表主键

表2: Address
+-------------+---------+
| 列名         | 类型    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId 是上表主键
```

编写一个 SQL 查询，满足条件：无论 person 是否有地址信息，都需要基于上述两表提供 person 的以下信息：

```plain
FirstName, LastName, City, State
```

## 分析

本题需要查询四个信息：FirstName, LastName, City, State，其中 FirstName，LastName 在学生表里，City，Address 在地址表里。因此涉及到多表连接，需要正确选择连接类型。

### 方法: 左连接

左连接，取左边的表的全部，右边的表按条件，符合的显示，不符合则显示null

#### 代码(MySQL)

```sql
SELECT FirstName, LastName, City, State
FROM Person LEFT JOIN Address
ON Person.PersonId = Address.PersonId
```

---

# [176. 第二高的薪水](https://leetcode-cn.com/problems/second-highest-salary)

## 题目描述

编写一个 SQL 查询，获取 Employee 表中第 n 高的薪水（Salary）。

```plain
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

例如上述 Employee 表，n = 2 时，应返回第二高的薪水 200。如果不存在第 n 高的薪水，那么查询应返回 null。

```plain
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
```

## 分析

首先查询 Employee 中的所有薪水，薪水可能有一样的值，所以使用 DISTINCT 进行去重。

然后从查询结果中再找第 n 高的。


### 方法1: 使用子查询和 LIMIT 子句

将不同的薪资按降序排序，然后使用 LIMIT 子句获得第二高的薪资。

`LINIT n` 子句表示查询结果返回前 n 条数据

`OFFSET x` 表示跳过 x 条数据，也就是从第 x 行起

`LIMIT n OFFSET x` 表示跳过 x 条数据(也就是从第 x 行起)，读取前 n 条数据，可以简写为 `LIMIT x, n`

#### 代码(MySQL)

```sql
SELECT (
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
    ) AS SecondHighestSalary
```

### 方法2: ISNULL函数

`ISNULL(expr1, expr2)`: 判断 expr1 是否为空，若是则用 expr2 代替

#### 代码(MYSQL)

```sql
SELECT IFNULL((
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
    ), NULL) AS SecondHighestSalary
```

---

# [177. 第N高的薪水](https://leetcode-cn.com/problems/nth-highest-salary)

## 题目描述

编写一个 SQL 查询，获取 Employee 表中第 n 高的薪水（Salary）。

```plain
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

例如上述 Employee 表，n = 2 时，应返回第二高的薪水 200。如果不存在第 n 高的薪水，那么查询应返回 null。

```plain
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
```

## 分析

首先查询 Employee 中的所有薪水，薪水可能有一样的值，所以使用 DISTINCT 进行去重。

然后从查询结果中再找第 n 高的。

将以上过程封装为函数 getNthHighestSalary(n)。

### 方法: 自定义函数

自定义函数的写法

```sql
CREATE FUNCTION funcname(args) RETURNS typename
BEGIN
...
END
```

声明变量: `DECLARE`

变量赋值: `SET`

#### 函数 `CERATE FUNCTION` 和过程 `CREATE PRECEDURE` 的区别

相同点
1. 过程和函数都以编译后的形式存放在数据库中
2. 过程和函数都可以有零个或多个参数

不同点
1. 函数有返回值，过程没有
2. 函数调用在一个表达式中，过程则是作为sql程序的一个语句

#### 代码(MySQL)

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE a INT DEFAULT 0;
    SET a = N - 1;
    RETURN (
        SELECT IFNULL((SELECT DISTINCT Salary
                       FROM Employee
                       ORDER BY Salary DESC
                       LIMIT 1, a), NULL));
END
```

---

# [178. 分数排名](https://leetcode-cn.com/problems/rank-scores)


## 题目描述

编写一个 SQL 查询来实现分数排名。

如果两个分数相同，则两个分数排名（Rank）相同。请注意，平分后的下一个名次应该是下一个连续的整数值。换句话说，名次之间不应该有“间隔”。

```plain
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
```

例如，根据上述给定的 Scores 表，你的查询应该返回（按分数从高到低排列）

```plain
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
```

重要提示：对于 MySQL 解决方案，如果要转义用作列名的保留字，可以在关键字之前和之后使用撇号。例如 `Rank`

## 分析

涉及排名的问题，可以用窗口函数。

排名相关的窗口函数 RANK, DENSE_RANK, ROW_NUMBER 的区别: 

- RANK: 如果有并列名次的行，会占用下一名次的位置。
- DENSE_RANK: 如果有并列名次的行，不占用下一名次的位置。
- ROW_NUMBER: 不考虑并列名次的情况。

### 方法: 排名相关的窗口函数

窗口函数的语法

```plain
SELECT 窗口函数 OVER (PARTITION BY 用于分组的列名， ORDER BY 用于排序的列名) AS ...
FROM ...
```

#### 窗口聚合函数与分组聚合函数的区别

窗口聚合函数与分组聚合函数的功能是相同的，唯一的不同如下:

- 分组聚合函数通过分组查询来进行
- 窗口聚合函数通过OVER子句定义的窗口来进行

#### 代码(MySQL)

```sql
SELECT Score,
    DENSE_RANK() OVER(ORDER BY Score DESC) AS 'Rank'
FROM Scores
```

---

# [180. 连续出现的数字](https://leetcode-cn.com/problems/consecutive-numbers)

## 题目描述

表：Logs

```plain
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
```
id 是这个表的主键。

编写一个 SQL 查询，查找所有至少连续出现三次的数字。

返回的结果表中的数据可以按 任意顺序 排列。

查询结果格式如下面的例子所示：

Logs 表：
```plain
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
```

Result 表：
```plain
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```
1 是唯一连续出现至少三次的数字。

## 分析

解决连续出现 N 次的问题。

分两步，第一步找出连续的 N 条数据，第二步判断这 N 条数据是否相等。

### 方法1: 自连接

自连接的本质是把一张表复制出多张一模一样的表来使用。

在 WHERE 中完成 N 条数据连续和 N 条数据相等的判断。

#### 代码(MySQL)

```sql
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs AS l1
    ,Logs AS l2
    ,Logs AS l3
WHERE l1.id + 1 = l2.id
    AND l2.id + 1 = l3.id
    AND l1.num = l2.num
    AND l2.num = l3.num
```

### 方法2: 窗口函数

#### ROW_NUMBER 窗口函数

用 ROW_NUMBER 窗口函数: 按 Num 分组，按 Id 排序。将 ROW_NUMBER 保存为新属性。

#### 构造新属性

通过子查询构造新属性 Id - ROW_NUMBER。用于后续的连续性判定。

#### 分组查询

当 Id - ROW_NUMBER 相同且 Num 相同时，为连续出现的相同数据。

因此分组条件为 `GROUP BY (Id + 1 - Rownum), Num`

这里 Id + 1 是为了防止 Id 从 0 开始的情况，Id - Rownum 可能为负数。

#### 过滤分组

`HAVING COUNT(*)>=3` 这里 3 换为 n 即可实现 n 个连续出现的相同数据。

#### Id 不连续的情况的处理

构造新变量 id2 替代 id，id2 单调且连续

```plain
ROW_NUMBER() OVER (ORDER BY Id) id2
```

#### 代码(MySQL)

```sql
SELECT DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY Num ORDER BY Id) As 'Rownum',
        ROW_NUMBER() OVER (ORDER BY Id) Id2
    FROM Logs
    ) AS t
GROUP BY (Id2 + 1 - Rownum), Num
HAVING COUNT(*)>=3
```

