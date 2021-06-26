# 10. <font color=red>Grouping Data</font>

group data so that you can summarize subsets of table contents.

## 10-1 Understanding Data Grouping

All the calculations thus far were performed on all the data in a table or on data that matched a specific WHERE clause.

```sql
SELECT COUNT(*) AS num_prods 
FROM Products
WHERE vend_id = 'DLL01';
```

But what if you wanted to return the number of products offered by each vendor? Or products offered by vendors who offer a single product, or only those who offer more than ten products?

Grouping lets you divide data into logical sets so that you can perform aggregate calculations on each group.


## 10-2 Creating Groups

Groups are created using the GROUP BY clause in your SELECT statement.

```sql
SELECT vend_id, COUNT(*) AS num_prods 
FROM Products 
GROUP BY vend_id;
```

<font color=red>Before you use GROUP BY, here are some important rules about its use that you need to know</font>

- GROUP BY clauses can contain as many columns as you want. This enables you to **nest groups**, providing you with more granular control over how data is grouped.
- **If you have nested groups in your GROUP BY clause, data is summarized at the last specified group**. In other words, all the columns specified are evaluated together when grouping is established (so you won’t get data back for each individual column level).
- **Every column listed in GROUP BY must be a retrieved column or a valid expression (but not an aggregate function). If an expression is used in the SELECT, that same expression must be specified in GROUP BY. Aliases cannot be used**
- Most SQL implementations do not allow GROUP BY columns with variable length datatypes (such as text or memo fields).
- **Aside from the aggregate calculations statements, every column in your SELECT statement must be present in the GROUP BY clause**.
- **If the grouping column contains a row with a NULL value, NULL will be returned as a group**. If there are multiple rows with NULL values, they’ll all be grouped together.
- **The GROUP BY clause must come after any WHERE clause and before any ORDER BY clause**.

### Tip: The ALL Clause

Some SQL implementations (such as Microsoft SQL Server) support an optional ALL clause within GROUP BY. This clause can be used to return all groups, even those that have no matching rows (in which case the aggregate would return NULL).

### Caution: <font color=red>Specifying Columns by Relative Position</font>

Some SQL implementations allow you to specify GROUP BY columns by the position in the SELECT list. For example, GROUP BY 2,1 can mean group by the second column selected and then by the first. Although this shorthand syntax is convenient, it is not supported by all SQL implementations. It’s use is also risky in that it is highly susceptible to the introduction of errors when editing SQL statements.


## 10-3 Filtering Groups

For example, you might want a list of all customers who have made at least two orders.
WHERE does not work here because WHERE filters specific rows, not groups.
<font color=red>HAVING</font> is very similar to WHERE. In fact, all types of WHERE clauses you learned about thus far can also be used with HAVING. The only difference is that WHERE filters rows and HAVING filters groups.

### Tip: HAVING Supports All WHERE’s Operators

All the techniques and options that you learned about WHERE can be applied to HAVING.

```sql
SELECT cust_id, COUNT(*) AS orders 
FROM Orders 
GROUP BY cust_id 
HAVING COUNT(*) >= 2;
```

### <font color=red>Note: The Difference Between HAVING and WHERE</font>

**WHERE filters before data is grouped, and HAVING filters after data is grouped**. This is an important distinction; rows that are eliminated by a WHERE clause will not be included in the group. This could change the calculated values which in turn could affect which groups are filtered based on the use of those values in the HAVING clause.

use both WHERE and HAVING clauses in one statement
Suppose you want to further filter the above statement so that it returns any customers who placed two or more orders in the past 12 months.

```sql
SELECT vend_id, COUNT(*) AS num_prods 
FROM Products 
WHERE prod_price >= 4 
GROUP BY vend_id 
HAVING COUNT(*) >= 2;
```

### Note: Using HAVING and WHERE

HAVING is so similar to WHERE that most DBMSs treat them as the same thing if no GROUP BY is specified. Nevertheless, you should make that distinction yourself. **Use HAVING only in conjunction with GROUP BY clauses. Use WHERE for standard row-level filtering.**

## 10-4 Grouping and Sorting

GROUP BY and ORDER BY are very different

| ORDER BY                                            | GROUP BY                                                                                                    |
| --                                                  | --                                                                                                          |
| Sorts generated output                              | Groups rows. The output might not be in group order, however                                                |
| Any columns (even columns not selected) may be used | Only selected columns or expressions columns may be used, and every selected column expression must be used |
| Never required                                      | Required if using columns (or expressions) with aggregate functions                                         |

### Tip: Don’t Forget ORDER BY

As a rule, anytime you use a GROUP BY clause, you should also specify an ORDER BY clause. That is the only way to ensure that data will be sorted properly. Never rely on GROUP BY to sort your data.

Example:

retrieves the order number and number of items ordered for all orders containing three or more items

```sql
SELECT order_num, COUNT(*) AS items 
FROM OrderItems 
GROUP BY order_num 
HAVING COUNT(*) >= 3;
```

To sort the output by number of items ordered, all you need to do is add an ORDER BY clause, as follows

```sql
SELECT order_num, COUNT(*) AS items 
FROM OrderItems 
GROUP BY order_num 
HAVING COUNT(*) >= 3 
ORDER BY items, order_num;
```

### Note: Access Incompatibility

Microsoft Access does not allow sorting by alias, and so this example will fail. The solution is to replace items (in the ORDER BY clause) with the actual calculation or with the field position. As such, ORDER BY COUNT(*), order_num or ORDER BY 2, order_num will both work.

## 10-5 SELECT Clause Ordering

### <font color=red>SELECT Clauses and Their Sequence</font>

| Clause   | Description                           | Required                                |
| --       | --                                    | --                                      |
| SELECT   | columns or expressions to be returned | Yes                                     |
| FROM     | Table to retrieve data from           | Only if selecting data from a table     |
| WHERE    | Row-level filtering                   | No                                      |
| GROUP BY | Group specification                   | Only if calculating aggregates by group |
| HAVING   | Group-level filtering                 | No                                      |
| ORDER BY | Output sort order                     | No                                      |

---

# 11. Working with Subqueries
## 11-1 Understanding Subqueries
subqueries: queries that are embedded into other queries.

### Note: MySQL Support
If you are using MySQL, be aware that support for subqueries was introduced in version 4.1. Earlier versions of MySQL do not support subqueries.

## 11-2 Filtering by Subquery
**Example: suppose you wanted a list of all the customers who ordered item RGAN01**. What would you have to do to retrieve this information? Ref Appendix A. to find each of the tables and their relationships.

Here are the steps:
1. Retrieve the order numbers of all orders containing item RGAN01.
2. Retrieve the customer ID of all the customers who have orders listed in the order numbers returned in the previous step.
3. Retrieve the customer information for all the customer IDs returned in the previous step.

Each of these steps can be executed as a separate query. By doing so, you use **the results returned by one SELECT statement to populate the WHERE clause of the next SELECT statement**.

The first SELECT statement: retrieves the order_num column for all order items with a prod_id of RGAN01.

```sql
SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';
```

the next step is to retrieve the customer IDs associated with those orders numbers

```sql
SELECT cust_id
FROM Orders
WHERE order_num IN (20007, 20008);
```

**combine the two queries by turning the first (the one that returned the order numbers) into a subquery.**

```sql
SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num
                    FROM OrderItems
                    WHERE prod_id = 'RGAN01');
```

You now have the IDs of all the customers who ordered item RGAN01. The next step is to retrieve the customer information for each of those customer IDs.

```sql
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Order
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));
```

### Caution: Single Column Only

Subquery SELECT statements can only retrieve a single column. Attempting to retrieve multiple columns will return an error.

### Caution: Subqueries and Performance

The code shown here works, and it achieves the desired result. However, using subqueries is not always the most efficient way to perform this type of data retrieval. More on this in Chap 12, “Joining Tables,” where you will revisit this same example.

---

## 11-3 Using Subqueries as Calculated Fields

Another way to use subqueries is in creating calculated fields.

**Example: Suppose you want to display the total number of orders placed by every customer in your Customers table.**

Steps:
1. Retrieve the list of customers from the Customers table.
2. For each customer retrieved, count the number of associated orders in the

filter a specific customer ID, you can count just that customer’s orders.

```sql
SELECT COUNT(*) AS orders
FROM Orders
WHERE cust_id = '1000000001';
```

To perform that COUNT(*) calculation for each customer, use COUNT* as a subquery.

```sql
SELECT cust_name, cust_state, (
        SELECT COUNT(*)
        FROM Orders
        WHERE Orders.cust_id = Customers.cust_id
        ) AS orders
FROM Customers
ORDER BY cust_name
```

The WHERE clause in the subquery is a little different from the WHERE clauses used previously because it uses fully qualified column names, instead of just a column name (cust_id), **it specifies the table and the column name (as Orders.cust_id and Customers.cust_id).**

The following WHERE clause tells SQL to **compare the cust_id in the Orders table to the one currently being retrieved from the Customers table:**

```sql
WHERE Orders.cust_id = Customers.cust_id
```

This syntax -- the table name and the column name separated by a period -- must be used whenever there is possible ambiguity about column names.

Without fully qualifying the column names, the DBMS assumes you are comparing the cust_id in the Orders table to itself.

```sql
SELECT cust_name, cust_state, (
        SELECT COUNT(*)
        FROM Orders
        WHERE cust_id = cust_id
        ) AS orders
FROM Customers
ORDER BY cust_name
```

### Caution: Fully Qualified Column Names

A good rule is that if you are ever working with more than one table in a SELECT statement, then use fully qualified column names to avoid any and all ambiguity.

### Tip: Subqueries May Not Always Be the Best Option

As explained earlier in this lesson, although the sample code shown here works, it is often not the most efficient way to perform this type of data retrieval. You will revisit this example when you learn about JOINs in the next two lessons.

---

# 12. Joining Tables

## 12-1 Understanding Joins

Before you can effectively use joins, you must understand relational tables and the basics of relational database design.

### Understanding Relational Tables
The key here is that having multiple occurrences of the same data is never a good thing, and that principle is the basis for relational database design.
Relational tables are designed so that information is split into multiple tables, one for each data type.

### Why Use Joins
breaking data into multiple tables enables more efficient storage, easier manipulation, and greater scalability. But these benefits come with a price.
If data is stored in multiple tables, how can you retrieve that data with a single SELECT statement?

a join is a mechanism used to associate tables within a SELECT statement

A join is created by the DBMS as needed, and it persists for the duration of the query execution.

## 12-2 Creating a Join

You must specify all the tables to be included and how they are related to each other.

```sql
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;
```

Unlike all the prior SELECT statements, this one has two tables listed in the FROM clause, Vendors and Products. These are the names of the two tables that are being joined in this SELECT statement.

The tables are correctly joined with a WHERE clause that instructs the DBMS to match vend_id in the Vendors table with vend_id in the Products table.

### Caution: Don’t Forget the WHERE Clause

Make sure all your joins have WHERE clauses, or the DBMS will return far more data than you want. Similarly, make sure your WHERE clauses are correct. An incorrect filter condition will cause the DBMS to return incorrect data.

### <font color=red>Inner Joins</font>
The join you have been using so far is called an **equijoin -- a join based on the testing of equality between two tables**.
**This kind of join is also called an inner join**. In fact, you may use a slightly different syntax for these joins

```sql
SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
ON Vendors.vend_id = Products.vend_id;
```

Here the relationship between the two tables is part of the FROM clause specified as **INNER JOIN**.
When using this syntax the join condition is specified using the special **ON clause** instead of a WHERE clause.

### Joining Multiple Tables

The basic rules for creating the join remain the same. **First list all the tables, and then define the relationship between each**.

```sql
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Prodects, Vendors
WHERE Products.vend_id = Vendors.vend_id
ANF OrderItems.vend_id = Products.vend_id
AND order_num = 20007;
```

### Caution: Performance Considerations

DBMSs process joins at run-time relating each table as specified. This process can become very resource intensive so be careful not to join tables unnecessarily. The more tables you join the more performance will degrade.

revisit the following example from Chap 11, returns a list of customers who ordered product RGAN01:

```sql
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));
```

```sql
SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id IN Orders.cust_id
AND OrderItems.order_num IN Orders.order_num
AND prod_id = 'RGAN01';
```

instead of using them within nested subqueries, here two joins are used to connect the tables. There are three WHERE clause conditions here. The first two connect the tables in the join, and the last one filters the data for product RGAN01.

---

# 13. Creating Advanced Joins

## 13-1 Using Table Aliases

The syntax to alias a column

```sql
SELECT RTRIM(vend_name) + '(' + RTRIM(vend_country) + ')' AS vend_title
FROM Vendors
ORDER BY vend_name;
```


In addition to using aliases for column names and calculated fields, SQL also enables you to alias table names. There are two primary reasons to do this:
- To shorten the SQL syntax
- To enable multiple uses of the same table within a single SELECT statement

```sql
SELECT cust_name, cust_contact
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
AND OI.order_num = O.order_num
AND prod_id = 'RGAN01';
```

aliases are not limited to just WHERE. You can use aliases in the SELECT list, the ORDER BY clause, and in any other part of the statement as well.

Unlike column aliases, table aliases are never returned to the client.

## 13-2 Using Different Join Types

three additional join types: the **self join**, the **natural join**, and the **outer join**.

### Self Joins

Example: Suppose you wanted to send a mailing to all the customer contacts who work for the same company for which Jim Jones works.

```sql
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
                   FROM Customers
                   WHERE cust_contact = 'Jim Jones');
```

This first solution uses subqueries. The inner SELECT statement does a simple retrieval to return the cust_name of the company that Jim Jones works for.

the same query using a join

```sql
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
AND c2.cust_contact = 'Jim Jones';
```

The two tables needed in this query are actually the same table, and so the Customers table appears in the FROM clause twice. Although this is perfectly legal, any references to table Customers would be ambiguous because the DBMS does not know which Customers table you are referring to.
**To resolve this problem table aliases are used**. The first occurrence of Customers has an alias of C1, and the second has an alias of C2. Now those aliases can be used as table names.
The WHERE clause first joins the tables and then filters the data by cust_contact in the second table to return only the wanted data.

### Tip: Self-Joins Instead of Subqueries
Self-joins are often used to replace statements using subqueries that retrieve data from the same table as the outer statement. Although the end result is the same, many DBMSs process joins far more quickly than they do subqueries. It is usually worth experimenting with both to determine which performs better.

### <font color=red>Natural Joins</font>
Whenever tables are joined, **at least one column will appear in more than one table** (the columns being used to create the join). **Standard joins** (the inner joins that you learned about in the last lesson) return all data, **even multiple occurrences of the same column**. A <font color=red>natural join</font> simply **eliminates those multiple occurrences** so that only one of each column is returned.
A natural join is a join in which you select only columns that are unique.

```sql
SELECT C.*, O.order_num, O.order_date, OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
AND C.order_num = O.order_num
AND prod_id = 'RGAN01';
```

In this example, a wildcard is used for the first table only. All other columns are explicitly listed so that no duplicate columns are retrieved.

### <font color=red>Outer Joins</font>

Most joins relate rows in one table with rows in another. **But occasionally, you want to include rows that have no related rows**. For example, you might use joins to accomplish the following tasks:

- Count how many orders were placed by each customer, including customers that have yet to place an order.
- List all products with order quantities, including products not ordered by anyone.
- Calculate average sale sizes, taking into account customers that have not yet placed an order.

In each of these examples, the join includes table rows that have no associated rows in the related table. This type of join is called an outer join.

### Caution: Syntax Differences

It is important to note that the syntax used to create an outer join can
vary slightly among different SQL implementations.

The following SELECT statement is a simple inner join. It retrieves a list of all
customers and their orders:

```sql
SELECT Customers.cust_id, Orders.order_num
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
```

Outer join syntax is similar. To retrieve a list of all customers including those who have placed no orders

```sql
SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
```

Like the inner join seen in the last lesson, this SELECT statement uses the keywords OUTER JOIN to specify the join type (instead of specifying it in the WHERE clause).

But unlike inner joins, which relate rows in both tables, outer joins also include rows with no related rows.

When using OUTER JOIN syntax you **must use the RIGHT or LEFT keywords to specify the table from which to include all rows**

```sql
SELECT Customers.cust_id, Orders.order_num
FROM Customers RIGHT OUTER JOIN Orders
ON Orders.cust_id = Customers.cust_id;
```

## 13-3 Using Joins with Aggregate Functions

Example: You want to retrieve a list of all customers and the number of orders that each has placed.

```sql
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;
```

The GROUP BY clause groups the data by customer, and so the function call COUNT(Orders.order_num) counts the number of orders for each customer and returns it as num_ord.

```sql
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;
```

This example uses a left outer join to include all customers, even those who have not placed any orders.

## 13-4 Using Joins and Join Conditions

Before I wrap up our two lesson discussion on joins, I think it is worthwhile to summarize some key points regarding joins and their use:
- Pay careful attention to the type of join being used. More often than not, you’ll want an inner join, but there are often valid uses for outer joins, too.
- Check your DBMS documentation for the exact join syntax it supports. (Most DBMSs use one of the forms of syntax described in these two lessons.)
- Make sure you use the correct join condition (regardless of the syntax beingused), or you’ll return incorrect data.
- Make sure you always provide a join condition, or you’ll end up with the Cartesian product.
- You may include multiple tables in a join and even have different join types for each. Although this is legal and often useful, make sure you test each join separately before testing them together. This will make troubleshooting far simpler.

# 14. Combining Queries

use the UNION operator to combine multiple SELECT statements into one result set.

## 14-1 Understanding Combined Queries
Most SQL queries contain **a single SELECT statement that returns data from one or more tables.**
SQL also enables you to **perform multiple queries (multiple SELECT statements) and return the results as a single query result set.**
These combined queries are usually known as unions or compound queries.

There are basically two scenarios in which you’d use combined queries:
- To return similarly structured data from different tables in a single query
- To perform multiple queries against a single table returning the data as one query

### Tip: Combining Queries and Multiple WHERE Conditions

For the most part, **combining two queries to the same table accomplishes the same thing as a single query with multiple WHERE clause conditions**. In other words, any SELECT statement with multiple WHERE clauses can also be specified as a combined query, as you’ll see in the section that follows.

## 14-2 Creating Combined Queries

Example: You need a report on all your customers in Illinois, Indiana, and Michigan. You also want to include all Fun4All locations, regardless of state.

### UNION Rules
- A UNION must be composed of two or more SELECT statements, each separated by the keyword UNION (so, if combining four SELECT statements there would be three UNION keywords used).
- **Each query in a UNION must contain the same columns, expressions, or aggregate functions** (and some DBMSs even require that columns be listed in the same order).
- **Column datatypes must be compatible**: They need not be the exact same type, but they must be of a type that the DBMS can implicitly convert (for example, different numeric types or different date types).

### Including or Eliminating Duplicate Rows
The UNION automatically removes any duplicate rows from the query result set (in other words, it behaves just as do multiple WHERE clause conditions in a single SELECT would).
If you would, in fact, want all occurrences of all matches returned, you can use **UNION ALL** instead of UNION.


### Sorting Combined Query Results
When combining queries with a UNION only one ORDER BY clause may be used, and it must occur after the final SELECT statement.


### Tip: Working with Multiple Tables
In practice, where UNION is really useful is when you need to combine data from multiple tables, even tables with mismatched column names, in which case you can combine UNION with aliases to retrieve a single set of results.

---
