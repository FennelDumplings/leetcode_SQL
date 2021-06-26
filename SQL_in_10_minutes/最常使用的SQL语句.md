
为了在需要时找到相应语句的语法,这里列出了最常使用的 SQL 语句的语法。每条语句以简要的描述开始,然后给出它的语法。

下面列出的语法几乎对所有 DBMS 都有效。关于具体语法可能变动的细节,可以参考 DBMS 文档。

---

# ALTER TABLE

更新已经存在的表的结构。

Ref: 《SQL必知必会》Chap17

```sql
ALTER TABLE tablename
(
    ADD|DROP column datatype [NULL|NOT NULL] [CONSTRAINTS],
    ADD|DROP column datatype [NULL|NOT NULL] [CONSTRAINTS],
    ...
);
```

---

# COMMIT

用于将事务写入数据库。

Ref: 《SQL必知必会》Chap20

```sql
COMMIT [TRANSACTION];
```

---

# CREATE INDEX

在一个或多个列上创建索引。

Ref: 《SQL必知必会》Chap22

```sql
CREATE INDEX indexname
ON tablename (column, ...);
```

---

# CREATE PROCEDURE

用于创建存储过程。

Ref: 《SQL必知必会》Chap19

```sql
CREATE PROCEDURE procedurename [parameters] [options]
AS
SQL statement;
```

---

# CREATE TABLE

用于创建新数据库表。更新已经存在的表的结构。

Ref: 《SQL必知必会》Chap17

```sql
CREATE TABLE tablename
{
    column datatype [NULL|NOT NULL] [CONSTRAINTS],
    column datatype [NULL|NOT NULL] [CONSTRAINTS],
    ...
};
```

---

# CREATE VIEW

创建一个或多个表上的新视图

Ref: 《SQL必知必会》Chap18

```sql
CREATE VIEW viewname AS
SELECT columns, ...
FROM tables, ...
[WHERE ...]
[GROUP BY ...]
[HAVING ..];
```

---

# DROP

永久地删除数据库对象(表、视图、索引等)。

Ref: 《SQL必知必会》Chap17

```sql
DROP INDEX|PROCEDURE|TABLE|VIEW
indexname|procedurename|tablename|viewname;
```

---

# INSERT

为表添加一行

Ref：《SQL必知必会》Chap15

```sql
INSERT INTO tablename [(columns, ...)]
VALUES(values, ...);
```

---

# INSERT SELECT

将 SELECT 的结果插入一个表。

Ref: 《SQL必知必会》Cahp15

```sql
INSERT INTO tablename [(columns, ...)]
SELECT columns, ... FROM tablename, ...
[WHERE ...];
```

---

# ROLLBACK

用于撤销一个事务块。

Ref: 《SQL必知必会》Chap20

```sql
ROLLBACK [TO savepointname];
```

或者

```sql
ROLLBACK TRANSACTION;
```

---

# SELECT

用于从一个表或多个表(视图)中检索数据。

Ref: 《SQL必知必会》Chap2~4, Chap5~14

```sql
SELECT columnname, ...
FROM tablename, ...
[WHERE ...]
[UNION ...]
[GROUP BY ...]
[HAVING ...]
[ORDER BY ...];
```

---

# UPDATE

更新表中的一行或多行。

Ref: 《SQL必知必会》Chap16

```sql
UPDATE tablename
SET columnname = value, ...
[WHERE ...];
```
