
本仓库记录 leetcode 上的所有 SQL 的题目以及代码。并随着 leetcode 每周新增的 SQL 题目更新。目录结构如下:

- `SQL_in_10_minutes`: 《SQL必知必会》
- `tips`: SQL 中的零散知识点
- `problems`: 题目的代码
- `analysis`: 题目分析

---

已更新题目记录

| 题目                                                                                                   | 技术点                                                                                                |
| --                                                                                                     | --                                                                                                    |
| [175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables)                                 | 左连接(《SQL必知必会》13-2)                                                                           |
| [176. 第二高的薪水](https://leetcode-cn.com/problems/second-highest-salary)                            | 子查询(《SQL必知必会》11) <br> LIMIT, OFFSET(《SQL必知必会》2-6) <br> ISNULL函数                      |
| [177. 第N高的薪水](https://leetcode-cn.com/problems/nth-highest-salary)                                | 自定义函数(CREATE FUNCTION) <br> 声明变量(DECLARE), 变量赋值(SET)                                     |
| [178. 分数排名](https://leetcode-cn.com/problems/rank-scores)                                          | 排名相关的窗口函数 <br> RANK/DENSE_RANK/ROW_NUMBER                                                    |
| [180. 连续出现的数字](https://leetcode-cn.com/problems/consecutive-numbers)                            | 自连接(《SQL必知必会》13-2) <br> 使用窗口函数并构造新属性 <br> 分组查询与过滤分组 (《SQL必知必会》10) |
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

