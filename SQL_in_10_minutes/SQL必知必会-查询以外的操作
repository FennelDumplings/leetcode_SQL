# 15. Inserting Data

Use the SQL INSERT statement

(1). 插入完整的行

VALUE 子句
各列必须以它们在表定义中出现的次序填充。
如果不提供列名,则必须给每个表列提供一个值，可以提供 NULL;

(2). 插入部分行

省略某些列，条件：
该列定义为允许NULL
在表定义中给出默认值

(3). 插入检索出的数据

可以一条 INSERT 插入多行
不一定要求列名匹配。但要列的顺序匹配

```sql
INSERT INTO Customers(cust_id,cust_contact)
SELECT cust_id,cust_contact
FROM CustNew;
```

要将一个表的内容复制到一个全新的表(运行中创建的表),可以使用 SELECT INTO 语句。

INSERT SELECT 和 SELECT INTO 一个重要差别：前者插入数据，后者导出数据

任何 SELECT 选项和子句都可以使用,包括 WHERE 和 GROUP BY ;
可利用联结从多个表插入数据;
不管从多少个表中检索数据,数据都只能插入到一个表中。

测试用途：

SELECT INTO 是试验新 SQL 语句前进行表复制的很好工具。先进行复制,可在复制的数据上测试 SQL 代码,而不会影响实际的数据。

---

# 16. Updating and Deleting Data

## 更新数据

两种方式：更新特定行，更新所有行(不加WHERE)

要更新的表;
列名和它们的新值; 可以多个列
确定要更新哪些行的过滤条件。

```sql
UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = '1000000005';
```

可以用子查询，用 SELECT 检索出的数据更新列数据
可以用 FROM 用一个表的数据更新另一个表的行(需要看 DBMS 是否支持)

删除某个列的值，可以设置其为 NULL

## 删除数据

两种方式：删除特定行，删除所有行(不加 WHERE)

```sql
DELETE FROM Customers
WHERE cust_id = '1000000006';
```

DELETE 不需要列名或通配符。 DELETE 删除整行而不是删除列。要删除指定的列,请使用 UPDATE 语句。

如果想从表中删除所有行,不要使用 DELETE 。可使用 TRUNCATE TABLE语句,它完成相同的工作,而速度更快(因为不记录数据的变动)。

简单联结两个表只需要这两个表中的公用字段。也可以让 DBMS 通过使用外键来严格实施关系。
存在外键时,DBMS 使用它们实施引用完整性。
使用外键确保引用完整性的一个好处是, DBMS 通常可以防止删除某个关系需要用到的行 。

NULL 值就是没有值或缺值。允许 NULL 值的列也允许在插入行时不给出该列的值。

SQL 允许指定默认值,在插入行时如果不给出值,DBMS 将自动采用默认值。默认值在 CREATE TABLE 语句的列定义中用关键字 DEFAULT 指定。

许多数据库开发人员喜欢使用 DEFAULT 值而不是 NULL 列,对于用于计算或数据分组的列更是如此。

---

# 17. Creating and Manipulating Tables

CREATE TABLE 创建表,必须给出下列信息:

新表的名字,在关键字 CREATE TABLE 之后给出;
表列的名字和定义,用逗号分隔;
的 DBMS 还要求指定表的位置。

指定  NULL/NOT NULL
指定默认值：DEFAULT

## 更新表

```sql
ALTER TABLE
```

- 理想情况下,不要在表中包含数据时对其进行更新。应该在表的设计过程中充分考虑未来可能的需求,避免今后对表的结构做大改动。
- 所有的 DBMS 都允许给现有的表增加列,不过对所增加列的数据类型(以及 NULL 和 DEFAULT 的使用)有所限制。
- 许多 DBMS 不允许删除或更改表中的列。
- 多数 DBMS 允许重新命名表中的列。
- 许多 DBMS 限制对已经填有数据的列进行更改,对未填有数据的列几乎没有限制。

以增加列为例

```sql
ALTER TABLE Vendors
ADD vend_phone CHAR(20);
```

更改或删除列、增加约束或增加键,这些操作也使用类似的语法

(1) 用新的列布局创建一个新表;
(2) 使用 INSERT SELECT 语句从旧表复制数据到新表。有必要的话,可以使用转换函数和计算字段;
(3) 检验包含所需数据的新表;
(4) 重命名旧表(如果确定,可以删除它);
(5) 用旧表原来的名字重命名新表;
(6) 根据需要,重新创建触发器、存储过程、索引和外键。


## 删除表
DROP TABLE CustCopy;

## 重命名表

需要参考 DBMS 手册。

---

# 18. Using Views

**视图是虚拟的表。与包含数据的表不一样,视图只包含使用时动态检索数据的查询。**

视图的常见应用

重用 SQL 
简化复杂的 SQL
使用表的一部而不是整个表
保护数据，可以授予用户访问表的特定部分的访问权限
更改数据格式和表示

视图本身不包含数据

因每次使用视图都要处理查询执行时需要的所有检索，因此有性能问题。部署需要测试

视图的规则比较多，参考 DBMS 文档

## 创建视图
```sql
CREATE VIEW
```

## 删除视图
```sql
DROP VIEW
```

### 利用视图简化复杂的联结
最常见的视图应用是隐藏复杂的 SQL,这通常涉及联结。
一次性编写基础的 SQL,然后根据需要多次使用。

```sql
CREATE VIEW ProductCustomers AS
SELECT cust_name, cust_contact, prod_id
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
AND OrderItems.order_num = Orders.order_num;
```

### 用视图重新格式化检索出的数据

```sql
CREATE VIEW VendorLocations AS
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
AS vend_title
FROM Vendors;
```

### 用视图过滤不想要的数据

```sql
CREATE VIEW CustomerEMailList AS
SELECT cust_id, cust_name, cust_email
FROM Customers
WHERE cust_email IS NOT NULL;
```

从视图检索数据时如果使用了一条 WHERE 子句,则两组子句(一组在视图中,另一组是传递给视图的)将自动组合。

### 使用视图与计算字段

```sql
CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
       prod_id,
       quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM OrderItems;
```

视图为虚拟的表。它们包含的不是数据而是根据需要检索数据的查询。视图提供了一种封装 SELECT 语句的层次,可用来简化数据处理,重新格式化或保护基础数据。

---

# 19. Working with Stored Procedures

## 存储过程

经常会有一些复杂的操作需要针对许多表的多条 SQL 语句才能完成

存储过程就是为以后使用而保存的一条或多条 SQL 语句。

### 存储过程的好处
通过把处理封装在一个易用的单元中,可以简化复杂的操作
由于不要求反复建立一系列处理步骤,因而保证了数据的一致性。
简化对变动的管理。如果表名、列名或业务逻辑(或别的内容)有变化,那么只需要更改存储过程的代码。
因为存储过程通常以编译过的形式存储,所以 DBMS 处理命令所需的工作量少,提高了性能。
存在一些只能用在单个请求中的 SQL 元素和特性,存储过程可以使用它们来编写功能更强更灵活的代码。

### 存储过程的缺陷
不同 DBMS 中的存储过程语法有所不同
编写存储过程比编写基本 SQL 语句复杂,需要更高的技能

## 执行存储过程
EXECUTE 接受存储过程名和需要传递给它的任何参数

```sql
EXECUTE
```

## 创建存储过程

```sql
CREATE PROCEDURE
```

具体参阅 DBMS 文档

---

# 20. Managing Transaction Processing

## 事务处理

使用事务处理(transaction processing),通过确保成批的 SQL 操作要么完全执行,要么完全不执行,来维护数据库的完整性。

因为一个 SQL 过程可能涉及多张表，中间发生故障，各表之间关系可能就错了。
**事务处理是一种机制,用来管理必须成批执行的 SQL 操作,保证数据库不包含不完整的操作结果。**

**如果没有错误发生,整组语句提交给(写到)数据库表;如果发生错误,则进行回退(撤销),将数据库恢复到某个已知且安全的状态。**

### 一些术语

- 事务(transaction)指一组 SQL 语句;
- 回退(rollback)指撤销指定 SQL 语句的过程;
- 提交(commit)指将未存储的 SQL 语句结果写入数据库表;
- 保留点(savepoint)指事务处理中设置的临时占位符(placeholder), 可以对它发布回退(与回退整个事务处理不同)。

事务处理用来管理 INSERT, UPDATE, DELETE
但不能回退 SELECT 
但不能回退 CREATE 和 DROP

**管理事务的关键在于将 SQL 语句组分解为逻辑块,并明确规定数据何时应该回退,何时不应该回退。**

有的 DBMS 要求明确标识事务处理块的开始和结束。例如 MySQL 的写法如下

```sql
START TRANSACTION
...
```

## ROLLBACK

SQL 的 ROLLBACK 命令用来回退(撤销)SQL 语句

```sql
DELETE FROM Orders;
ROLLBACK;
```

SQL 的 ROLLBACK 命令用来回退(撤销)SQL 语句
在事务处理块中, DELETE 操作(与INSERT 和 UPDATE 操作一样)并不是最终的结果。

## COMMIT 

一般的 SQL 语句都是针对数据库表直接执行和编写的。这就是所谓的隐式提交(implicit commit),即提交(写或保存)操作是自动进行的。

在事务处理块中,提交不会隐式进行。

进行明确的提交,使用 COMMIT 语句。

使用简单的 ROLLBACK 和 COMMIT 语句,就可以写入或撤销整个事务。但是,只对简单的事务才能这样做,复杂的事务可能需要部分提交或回退。

要支持回退部分事务,必须在事务处理块中的合适位置放置占位符。这样,如果需要回退,可以回退到某个占位符。在 SQL 中,这些占位符称为保留点。

```sql
SAVEPOINT delete1;
```

回退到保留点

```sql
ROLLBACK TO delete1;
```

---

# 21. Using Cursors

## 游标
有时,需要在检索出来的行中前进或后退一行或多行,这就是游标的用途所在。

在存储了游标之后,应用程序可以根据需要滚动或浏览其中的数据。

## 使用游标

- 在使用游标前,必须声明(定义)它。这个过程实际上没有检索数据,它只是定义要使用的 SELECT 语句和游标选项。
- 一旦声明,就必须打开游标以供使用。这个过程用前面定义的 SELECT语句把数据实际检索出来。
- 对于填有数据的游标,根据需要取出(检索)各行。
- 在结束游标使用时,必须关闭游标,可能的话,释放游标(有赖于具体的 DBMS)。

声明游标后,可根据需要频繁地打开和关闭游标。在游标打开时,可根据需要频繁地执行取操作。

### (1) 创建游标

```sql
-- DECLARE 语 句 用 来 定 义 和 命 名 游 标 , 这 里 为 CustCursor 。
DECLARE CustCursor CURSOR
FOR
SELECT * FROM Customers
WHERE cust_email IS NULL
```

### (2) 使用游标

```sql
OPEN CURSOR CustCursor
```

在处理 OPEN CURSOR 语句时,执行查询,存储检索出的数据以供浏览和滚动

现在可以用 FETCH 语句访问游标数据了。 FETCH 指出要检索哪些行,从何处检索它们以及将它们放于何处(如变量名)。

```sql
DECLARE TYPE CustCursor IS REF CURSOR
RETURN Customers%ROWTYPE;
DECLARE CustRecord Customers%ROWTYPE
BEGIN
OPEN CustCursor;
FETCH CustCursor INTO CustRecord;
CLOSE CustCursor;
END;
```

这个例子使用 FETCH 检索当前行,放到一个名为 CustRecord 的变量中。但不一样的是,这里的 FETCH 位于 LOOP 内,因此它反复执行。代码 EXIT WHEN CustCursor%NOTFOUND 使在取不出更多的行时终止处理(退出循环)。

### (3) 关闭游标

```sql
CLOSE CustCursor
```

---

# 22. Understanding Advanced SQL Features

## 约束
正确地进行关系数据库设计,需要一种方法保证只在表中插入合法数据。

这种检查最好在 DBMS 做(高效，也避免有些客户端不做)

DBMS 通过在数据库表上施加约束来实施引用完整性。大多数约束是在表定义中定义的

```sql
CREATE TABLE
ALTER TABLE
```

### 1. 主键
保证一列(或一组列)中的值是唯一的,而且永不改动。

表中任意列只要满足以下条件,都可以用于主键。
1. 任意两行的主键值不相同
2. 每行都有一个主键值，即不允许 NULL
3. 主键值的列从不修改或更新
4. 主键值不重用

```sql
ALTER TABLE Vendors
ADD CONSTRAINT PRIMARY KEY (vend_id);
```
使用的是 CONSTRAINT 语法。此语法也可以用于 CREATE TABLE 和 ALTER TABLE 语句。

### 2. 外键
外键是表中的一列,其值必须列在另一表的主键中。外键是保证引用完整性的极其重要部分。

```sql
CREATE TABLE Orders
(
    order_num  INTEGER  NOT NULL PRIMARY KEY,
    order_date DATETIME NOT NULL,
    cust_id    CHAR(10) NOT NULL REFERENCES Customers(cust_id)
);
```

表定义使用了 REFERENCES 关键字,它表示 cust_id 中的任何值都必须是 Customers 表的 cust_id 中的值。
相同的工作也可以在 ALTER TABLE 语句中用 CONSTRAINT 语法来完成
ALTER TABLE Orders
ADD CONSTRAINT
FOREIGN KEY (cust_id) REFERENCES Customers (cust_id)

### 3. 唯一约束
保证一列(或一组列)中的数据是唯一的。它们类似于主键,但存在以下重要区别。
表可以包含多个唯一约束，但每个表只允许一个主键
唯一约束可以含 NULL
唯一约束可以修改或更新
唯一约束列的值可以重复使用
唯一约束不能用于定义外键

```sql
UNIQUE
```

#### 4. 检查约束
保证一列或一组列中的数据满足一组指定的条件。

常见用途
1. 检查最小值或最大值 (订单的物品个事)
2. 制定范围 (发货日期)
3. 只允许特定的值 (性别)

DBMS 本身将会拒绝任何无效的数据。

```sql
CREATE TABLE OrderItems
(
    order_num  INTEGER  NOT NULL,
    order_item INTEGER  NOT NULL,
    prod_id    CHAR(10) NOT NULL,
    quantity   INTEGER  NOT NULL CHECK (quantity > 0),
    item_price MONEY    NOT NULL
);

ADD CONSTRAINT CHECK (gender LIKE '[MF]')
```

## 索引
索引用来排序数据以加快搜索和排序操作的速度。

使索引有用的因素是什么?很简单,就是恰当的排序。
找出书中词汇的困难不在于必须进行多少搜索,而在于书的内容没有按词汇排序。如果书的内容像字典一样排序,则索引没有必要(字典没有索引)

数据库索引的作用也一样。**主键数据总是排序的,这是 DBMS 的工作**。因此,按主键检索特定行总是一种快速有效的操作。

但是,搜索其他列中的值通常效率不高。

解决方法是使用索引。**可以在一个或多个列上定义索引,使 DBMS 保存其内容的一个排过序的列表**。在定义了索引后,DBMS 以使用书的索引类似的方法使用它。DBMS 搜索排过序的索引,找出匹配的位置,然后检索这些行。

索引的注意事项
1. 索引改善检索性能，但降低了数据插入，修改和删除的性能(执行这些操作时，DBMS 必须动态地更新索引)
2. 索引数据可能要占用大量存储空间
3. 并非所有数据都适合做索引，例如取值不多的数据
4. 索引用于数据过滤和数据排序。如果经常以某种特定的顺序排序数据，则该数据可能适合做索引
5. 可以在索引中定义多个列

```sql
CREATE INDEX prod_name_ind
ON Products (prod_name);
```

索引的效率随表数据的增加或改变而变化。
最好定期检查索引,并根据需要对索引进行调整。

## 触发器
触发器是特殊的存储过程,它在特定的数据库活动发生时自动执行。**触发器可以与特定表上的 INSERT 、 UPDATE 和 DELETE 操作(或组合)相关联。**

与存储过程不一样(存储过程只是简单的存储 SQL 语句),触发器与**单个的表**相关联。

触发器内的代码具有以下数据的访问权:
INSERT 操作中的所有新数据;
UPDATE 操作中的所有新数据和旧数据;
DELETE 操作中删除的数据。

触发器可在特定操作执行之前或之后进行，视 DBMS

常见用途
1. 保证数据一致 (例如地址中的省名转大写)
2. 基于某个表的变动在其他表上执行活动 (每当更新或删除一行，将审计跟踪记录写进某个日志表)
3. 进行额外的验证，并根据需要回退数据(保证某个顾客的可用资金不超限定)
4. 计算计算列的值或更新时间戳

```sql
CREATE TRIGGER customer_state
ON Customers
FOR INSERT, UPDATE
AS
UPDATE Customers
SET cust_state = Upper(cust_state)
WHERE Customers.cust_id = inserted.cust_id;
```

## 数据库安全
用户授权和身份确认

有的 DBMS 为此结合使用了操作系统的安全措施,而有的维护自己的用户及密码列表,还有一些结合使用外部目录服务服务器。

需要保护的操作

- 对数据库管理功能(创建表、更改或删除已存在的表等)的访问;
- 对特定数据库或表的访问;
- 访问的类型(只读、对特定列的访问等);
- 仅通过视图或存储过程对表进行访问;
- 创建多层次的安全措施,从而允许多种基于登录的访问和控制;
- 限制管理用户账号的能力。

```sql
GRANT 
REVOKE
```

---
