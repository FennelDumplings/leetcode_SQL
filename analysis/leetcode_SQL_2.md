
本期的题目为 leetcode SQL 的第 6 ~ 15 题，题目和主要技术点如下:

| 题目                                                                                                   | 技术点                                                                                                 |
| --                                                                                                     | --                                                                                                     |
| [181. 超过经理收入的员工](https://leetcode-cn.com/problems/employees-earning-more-than-their-managers) | 自连接(《SQL必知必会》13-2) <br> 内连接(《SQL必知必会》12-2)                                           |
| [182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails)                           | 子查询(《SQL必知必会》11-2) <br> 过滤查询(《SQL必知必会》10-3)                                         |
| [183. 从不订购的客户](https://leetcode-cn.com/problems/customers-who-never-order)                      | IN, NOT 操作符(《SQL必知必会》5-2, 5-3) <br> 左连接(《SQL必知必会》13-2)                               |
| [184. 部门工资最高的员工](https://leetcode-cn.com/problems/department-highest-salary)                  | IN 操作符(《SQL必知必会》5-2) <br> 内连接, 分组查询 <br> 窗口函数 RANK                                 |
| [185. 部门工资前三高的所有员工](https://leetcode-cn.com/problems/department-top-three-salaries)        | 内连接, 分组查询 <br> 窗口函数 DENSE_RANK                                                              |
| [196. 删除重复的电子邮箱](https://leetcode-cn.com/problems/delete-duplicate-emails)                    | 中间表 `FROM (SELECT * FROM tablename) tmp`                                                            |
| [197. 上升的温度](https://leetcode-cn.com/problems/rising-temperature)                                 | 比较日期，DATEDIFF <br> 内连接, 自连接                                                                 |
| [262. 行程和用户](https://leetcode-cn.com/problems/trips-and-users)                                    | 四舍五入 ROUND 函数 <br> 统计满足条件的条数: `SUM(IF(expr, 0, 1))` <br> 过滤方法, 连接(JOIN), 集合(IN) |
| [511. 游戏玩法分析 I](https://leetcode-cn.com/problems/game-play-analysis-i)                           | 用 MIN 函数求最早的日期                                                                                |
| [512. 游戏玩法分析 II](https://leetcode-cn.com/problems/game-play-analysis-ii)                         | IN 操作符                                                                                              |

---

# [181. 超过经理收入的员工](https://leetcode-cn.com/problems/employees-earning-more-than-their-managers)

## 题目描述

Employee 表包含所有员工，他们的经理也属于员工。每个员工都有一个 Id，此外还有一列对应员工的经理的 Id。

```plain
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
```
给定 Employee 表，编写一个 SQL 查询，该查询可以获取收入超过他们经理的员工的姓名。在上面的表格中，Joe 是唯一一个收入超过他的经理的员工。

```plain
+----------+
| Employee |
+----------+
| Joe      |
+----------+
```

## 分析

### 方案1: 自连接

#### 代码(MySQL)

```sql
SELECT t1.Name AS Employee
FROM Employee AS t1, Employee AS t2
WHERE t1.ManagerId = t2.Id
    AND t1.Salary > t2.Salary
```

### 方案2: 内连接

#### 代码(MySQL)

```sql
SELECT t1.Name AS Employee
FROM Employee AS t1 INNER JOIN Employee AS t2
ON t1.ManagerId = t2.Id
    AND t1.Salary > t2.Salary
```

---

# [182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails)

编写一个 SQL 查询，查找 Person 表中所有重复的电子邮箱。

示例：

```plain
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```
根据以上输入，你的查询应返回以下结果：

```plain
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```
说明：所有电子邮箱都是小写字母。

## 分析

### 方案: 分组查询+子查询

利用子查询进行过滤

#### 代码(MySQL)

```sql
SELECT Email
FROM (
    SELECT *, COUNT(Email) as Cnt
    FROM Person
    GROUP BY Email
) AS t
WHERE Cnt > 1
```

### 分组查询+过滤分组

注意顺序: where > group by > having > order by

#### 代码(MySQL)

```sql
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1
```

---

# [183. 从不订购的客户](https://leetcode-cn.com/problems/customers-who-never-order)

某网站包含两个表，Customers 表和 Orders 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户。

Customers 表：

```plain
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```
Orders 表：

```plain
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
```
例如给定上述表格，你的查询应返回：

```plain
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

## 分析

### 方案: IN

高级过滤方法: IN 操作符，后面可以接子查询。

#### 代码(MySQL)

```sql
SELECT c.Name AS Customers
FROM Customers AS c
WHERE c.Id NOT IN (
    SELECT CustomerId
    FROM Orders
)
```

### 方案2: 左连接

用左连接处理在表 a 但不在表 b 的数据

#### 代码(MySQL)

```sql
SELECT c.Name AS Customers
FROM Customers AS c LEFT JOIN Orders AS o
ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL
```

---

# [184. 部门工资最高的员工](https://leetcode-cn.com/problems/department-highest-salary)

Employee 表包含所有员工信息，每个员工有其对应的 Id, salary 和 department Id。

```plain
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```
Department 表包含公司所有部门的信息。

```plain
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
编写一个 SQL 查询，找出每个部门工资最高的员工。对于上述表，您的 SQL 查询应返回以下行（行的顺序无关紧要）。

```plain
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```
解释：

Max 和 Jim 在 IT 部门的工资都是最高的，Henry 在销售部的工资最高。

## 分析

通过 Employee.DepartmentId 和 Department.Id 左连接 Employee 和 Department

```sql
SELECT d.Name AS Department, e.Name AS Employee, e.Salary AS Salary
FROM Employee AS e INNER JOIN Department AS d
ON e.DepartmentId = d.Id
```

然后按 Department 分组

```sql
SELECT Department, Employee, MAX(Salary) AS Salary
FROM (
    SELECT d.Name AS Department, e.Name AS Employee, e.Salary AS Salary
    FROM Employee AS e LEFT JOIN Department AS d
    ON e.DepartmentId = d.Id
) AS t
GROUP BY Department
```

但这样的话如果最大值有多个，只能取到1个。

### 方案: 用 IN 应对多个最值的情况

在内连接后的临时表里用 IN 操作符，左侧是 (e.DepartmentId, e.Salary)，右侧是 (e.DepartmentId, MAX(e.Salary))。

#### 代码(MySQL)

```sql
SELECT d.Name AS Department, e.Name AS Employee, e.Salary AS Salary
FROM Employee AS e INNER JOIN Department AS d
ON e.DepartmentId = d.Id
WHERE (e.DepartmentId, e.Salary) IN (
    SELECT DepartmentId, MAX(Salary)
    FROM Employee
    GROUP BY DepartmentId
    )
```

### 方案2: 窗口函数 Rank 可以处理并列的情况

按 e.DepartmentId 分组，按 e.Salary 降序排序。构造新属性 r. 

r = 1 的为目标数据。

#### 代码(MySQL)

```sql
SELECT department, employee, salary
FROM (
    SELECT d.name AS Department, e.name AS Employee, e.Salary AS Salary,
        RANK() OVER (PARTITION by e.DepartmentId ORDER BY e.Salary DESC) AS r
    FROM Employee AS e INNER JOIN Department as d
    on e.DepartmentId = d.Id
) t
where r = 1
```

---

# [185. 部门工资前三高的所有员工](https://leetcode-cn.com/problems/department-top-three-salaries)

## 题目描述

Employee 表包含所有员工信息，每个员工有其对应的工号 Id，姓名 Name，工资 Salary 和部门编号 DepartmentId 。

```plain
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
```
Department 表包含公司所有部门的信息。

```plain
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
编写一个 SQL 查询，找出每个部门获得前三高工资的所有员工。例如，根据上述给定的表，查询结果应返回：

```plain
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
```
解释：

IT 部门中，Max 获得了最高的工资，Randy 和 Joe 都拿到了第二高的工资，Will 的工资排第三。销售部门（Sales）只有两名员工，Henry 的工资最高，Sam 的工资排第二。

## 分析

首先将 Employee 和 Department 两张表按 Employee.DepartmentId = Department.Id 内连接。

然后在内连接的临时表上用窗口函数 DENSE_RANK 并创建新属性 dr

dr < 4 的即为需要的数据。

### 方案: 窗口函数 Dense_Rank 可以处理并列的情况

#### 代码(MySQL)

```sql
SELECT Department, Employee, Salary
FROM (
    SELECT d.Name as Department, e.Name AS Employee, e.Salary AS Salary,
        DENSE_RANK() OVER(PARTITION BY e.DepartmentId ORDER BY e.Salary DESC) AS dr
    FROM Employee as e INNER JOIN Department as d
    ON e.DepartmentId = d.Id
) AS t
WHERE dr < 4
```

---

# [196. 删除重复的电子邮箱](https://leetcode-cn.com/problems/delete-duplicate-emails)

## 题目描述

编写一个 SQL 查询，来删除 Person 表中所有重复的电子邮箱，重复的邮箱里只保留 Id 最小 的那个。

```plain
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
```
Id 是这个表的主键。
例如，在运行你的查询语句之后，上面的 Person 表应返回以下几行:

```plain
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
```

提示：

执行 SQL 之后，输出是整个 Person 表。
使用 delete 语句。

## 分析

### 方案: DELETE + 中间表

删除特定行: 

```sql
DELETE FROM Person
WHERE ...;
```

注意: 

在 MYSQL 里，不能先 SELECT 一个表的记录，在按此条件进行更新和删除同一个表的记录。解决办法是，将 SELECT 得到的结果，再通过中间表 SELECT 一遍。

中间表可以这么写 `FROM (SELECT * FROM Person) t`

#### 代码(MySQL)

```sql
DELETE FROM Person
WHERE Id NOT IN (
    SELECT MIN(tmp.Id) AS Id
    FROM (SELECT * FROM Person) tmp
    GROUP BY tmp.Email 
    )
```

---

# [197. 上升的温度](https://leetcode-cn.com/problems/rising-temperature)

## 题目描述

表 Weather

```plain
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
```
id 是这个表的主键
该表包含特定日期的温度信息

编写一个 SQL 查询，来查找与之前（昨天的）日期相比温度更高的所有日期的 id 。

返回结果 不要求顺序 。

查询结果格式如下例：

Weather
```plain
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
```

Result table:
```plain
+----+
| id |
+----+
| 2  |
| 4  |
+----+
```
2015-01-02 的温度比前一天高（10 -> 25）
2015-01-04 的温度比前一天高（20 -> 30）

## 分析

### 方案: DATEDIFF 比较日期

#### 代码(MySQL)

内连接

```sql
SELECT w2.ID AS id
FROM Weather AS w1 INNER JOIN Weather AS w2
ON DATEDIFF(w2.recordDate, w1.recordDate) = 1
    AND w1.Temperature < w2.Temperature
```

自连接

```sql
SELECT w2.ID AS id
FROM Weather AS w1, Weather AS w2
WHERE DATEDIFF(w2.recordDate, w1.recordDate) = 1
    AND w1.Temperature < w2.Temperature
```

---

# [262. 行程和用户](https://leetcode-cn.com/problems/trips-and-users)

## 题目描述

表：Trips
```plain
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| Id          | int      |
| Client_Id   | int      |
| Driver_Id   | int      |
| City_Id     | int      |
| Status      | enum     |
| Request_at  | date     |     
+-------------+----------+
```
Id 是这张表的主键。
这张表中存所有出租车的行程信息。每段行程有唯一 Id ，其中 Client_Id 和 Driver_Id 是 Users 表中 Users_Id 的外键。
Status 是一个表示行程状态的枚举类型，枚举成员为(‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’) 。

表：Users
```plain
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| Users_Id    | int      |
| Banned      | enum     |
| Role        | enum     |
+-------------+----------+
```
Users_Id 是这张表的主键。
这张表中存所有用户，每个用户都有一个唯一的 Users_Id ，Role 是一个表示用户身份的枚举类型，枚举成员为 (‘client’, ‘driver’, ‘partner’) 。
Banned 是一个表示用户是否被禁止的枚举类型，枚举成员为 (‘Yes’, ‘No’) 。

写一段 SQL 语句查出 "2013-10-01" 至 "2013-10-03" 期间非禁止用户（乘客和司机都必须未被禁止）的取消率。非禁止用户即 Banned 为 No 的用户，禁止用户即 Banned 为 Yes 的用户。

取消率 的计算方式如下：(被司机或乘客取消的非禁止用户生成的订单数量) / (非禁止用户生成的订单总数)。

返回结果表中的数据可以按任意顺序组织。其中取消率 Cancellation Rate 需要四舍五入保留 两位小数 。

查询结果格式如下例所示：

Trips 表：
```plain
+----+-----------+-----------+---------+---------------------+------------+
| Id | Client_Id | Driver_Id | City_Id | Status              | Request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
| 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
| 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
| 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
| 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
| 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
| 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
| 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
| 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+
```

Users 表：
```plain
+----------+--------+--------+
| Users_Id | Banned | Role   |
+----------+--------+--------+
| 1        | No     | client |
| 2        | Yes    | client |
| 3        | No     | client |
| 4        | No     | client |
| 10       | No     | driver |
| 11       | No     | driver |
| 12       | No     | driver |
| 13       | No     | driver |
+----------+--------+--------+
```

Result 表：
```plain
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.50              |
+------------+-------------------+
```

- 2013-10-01：
    - 共有 4 条请求，其中 2 条取消。
    - 然而，Id=2 的请求是由禁止用户（User_Id=2）发出的，所以计算时应当忽略它。
    - 因此，总共有 3 条非禁止请求参与计算，其中 1 条取消。
    - 取消率为 (1 / 3) = 0.33
- 2013-10-02：
    - 共有 3 条请求，其中 0 条取消。
    - 然而，Id=6 的请求是由禁止用户发出的，所以计算时应当忽略它。
    - 因此，总共有 2 条非禁止请求参与计算，其中 0 条取消。
    - 取消率为 (0 / 2) = 0.00
- 2013-10-03：
    - 共有 3 条请求，其中 1 条取消。
    - 然而，Id=8 的请求是由禁止用户发出的，所以计算时应当忽略它。
    - 因此，总共有 2 条非禁止请求参与计算，其中 1 条取消。
    - 取消率为 (1 / 2) = 0.50

## 分析

先对 Trips 表做过滤，过滤条件如下

- Trips.Client_Id 和 Trips.Driver_Id 在 Users 表中的 Banned 都是 No 
- Trips.Request_at 范围是 "2013-10-01" ~ "2013-10-03"

### 过滤方法1: 用连接

```sql
SELECT *
FROM Trips AS t
JOIN Users AS u1 
ON (t.client_id = u1.users_id AND u1.banned ='No')
JOIN Users AS u2 
ON (t.driver_id = u2.users_id AND u2.banned ='No')
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
```

### 过滤方法2: 用集合

```sql
SELECT *
FROM Trips AS t
WHERE t.Client_Id NOT IN (
    SELECT users_id
    FROM users
    WHERE banned = 'Yes'
)
AND t.Driver_Id NOT IN (
    SELECT users_id
    FROM users
    WHERE banned = 'Yes'
)
AND t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
```

然后按日期分组，统计每组的总行程数，取消的行程数。

### 计算方案: SUM 函数和 ROUND 函数

每组的总行程数：COUNT(t.STATUS)。
每组的取消的行程数：
```sql
SUM(
    IF(t.STATUS = 'completed', 0, 1)
)
```

四舍五入函数 ROUND

#### 代码(MySQL)

- 用连接过滤

```sql
SELECT t.request_at AS Day, ROUND(
    SUM(IF(T.STATUS = 'completed', 0, 1)) / COUNT(T.STATUS), 2
    ) AS 'Cancellation Rate'
FROM Trips AS t
JOIN Users AS u1 
ON (t.client_id = u1.users_id AND u1.banned ='No')
JOIN Users AS u2 
ON (t.driver_id = u2.users_id AND u2.banned ='No')
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at
```

- 用集合过滤

```sql
SELECT t.request_at AS Day, ROUND(
    SUM(IF(T.STATUS = 'completed', 0, 1)) / COUNT(T.STATUS), 2
    ) AS 'Cancellation Rate'
FROM Trips AS t
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
AND t.Client_Id NOT IN (
    SELECT users_id
    FROM users
    WHERE banned = 'Yes'
    )
AND t.Driver_Id NOT IN (
    SELECT users_id
    FROM users
    WHERE banned = 'Yes'
    )
GROUP BY t.request_at
```

---

# [511. 游戏玩法分析 I](https://leetcode-cn.com/problems/game-play-analysis-i)

## 题目描述

活动表 Activity：

```plain
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
```
表的主键是 (player_id, event_date)。
这张表展示了一些游戏玩家在游戏平台上的行为活动。
每行数据记录了一名玩家在退出平台之前，当天使用同一台设备登录平台后打开的游戏的数目（可能是 0 个）。

写一条 SQL 查询语句获取每位玩家 第一次登陆平台的日期。

查询结果的格式如下所示：

Activity 表：
```plain
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

Result 表：
```plain
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+
```

## 分析

### 方案: 求最早的日期 MIN

#### 代码(MySQL)

```sql
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id
```

---

# [512. 游戏玩法分析 II](https://leetcode-cn.com/problems/game-play-analysis-ii)

## 问题描述

Table: Activity

```plain
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
```
(player_id, event_date) 是这个表的两个主键
这个表显示的是某些游戏玩家的游戏活动情况
每一行是在某天使用某个设备登出之前登录并玩多个游戏（可能为0）的玩家的记录
请编写一个 SQL 查询，描述每一个玩家首次登陆的设备名称

查询结果格式在以下示例中：

Activity table:
```plain
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

Result table:
```plain
+-----------+-----------+
| player_id | device_id |
+-----------+-----------+
| 1         | 2         |
| 2         | 3         |
| 3         | 1         |
+-----------+-----------+
```

## 分析

### 方案: IN 操作符

#### 代码(MySQL)

```sql
SELECT player_id, device_id
FROM Activity
WHERE (player_id, event_date) IN (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
    )
```

---
