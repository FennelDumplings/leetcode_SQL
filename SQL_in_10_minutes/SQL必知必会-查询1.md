
# 1. Understand SQL

## 1-1 Database Basics


**database** -- a collection of data stored in some organized fashion
**Table** -- A structured list of data of a specific type
**Schema** -- Imformation about database and table layout and properties
**Column** -- A single field in a table. All tables are made up of one or more columns
**Datatype** -- A type of allowed data. Every table column has an associated datatype that restricts(or allows) specific data in that column
**Rows** -- A record in a table
**Primary key** -- A column (or set of columns) whose values uniquely identify every row in a table
**Foreign key** -- a column in a table whose values must be listed in a primary key in another table.

Primary key conditions:
1. No two rows can have the same primary key value
2. every row must have a primary key value(primary key value columns may not allow NULL values)
3. Values in primary key column should never be modifed or updated
4. primary key column should never be reused(If a row is deleted from the table, its primary key may not be assigned to any new rows in the future)

---

# 2. Retrieving Data

## 2-1 the SELECT Statement

[SQL保留字](https://chengzhaoxi.xyz/e3915335.html)
[SQL数据类型](https://chengzhaoxi.xyz/1488131b.html)

## 2-2 Retrieving Individual Columns

```sql
SELECT column_name FROM table_name
```

If query results are not explicitly sorted, then data will be returned in no order of any significant

All extra white space within a SQL statement is ignored when that statement is processed., So the following threee statements are funcitonality indentical:

```sql
SELECT prod_name
FROM Products;
```

```sql
SELECT prod_name FROM Products;
```

```sql
SELECT
prod_name
FROM
Products;
```

## 2-3 Retrieving Multiple Columns

```sql
SELECT prod_id, prod_name, prod_price
FROM Products;
```

## 2-4 Retrieving All Columns

```sql
SELECT *
FROM Products;
```

慎用：Retrieving unnecessary columns usually slows down the performance of your retrieval and your applications

## 2-5 Retrieving Distinct Rows

```sql
SELECT DISTINCT vend_id
FROM Products；
```

### Caution： Can't Be Partially DISTINCT

The DISTINCT keyword applies to all columns, not just the one it precedes.

If you were to specify SELECT DISTINCT vend_id, prod_price, all rows would be retrieved unless both of the specified columns were distinct

## 2-6 Limiting Results

This is one of the situations where all SQL implementations are not created equal.

(1) Microsoft SQL

```sql
SELECT TOP 5 prod_name
FROM Products;
```

(2) DB2

```sql
SELECT prod_name
FROM Products
FETCH FIRST 5 ROW ONLY;
```

(3) Oracle

```sql
SELECT prod_name
FROM Products
WHERE ROWNUM < 5;
```

(4) MySQL, PostgreSQL, SQLite, MariaDB

```sql
SELECT prod_name
FROM Products
LIMIT 5;
```

## 2-7 Using Comments

```sql
SELECT prod_name  -- this is a comment
FROM Products
```

```sql
# This is a comment
SELECT prod_name
FROM Products;
```

```sql
/* SELECT prod_name, vend_id
FROM Products; */
SELECT prod_name
FROM Products;
```

---

# 3. Sorting Retrieved Data

## 3-1 Sorting Data

use the SELECT statement’s ORDER BY clause to sort retrieved data as needed.

Relational database design theory states that the sequence of retrieved data cannot be assumed to have significance if ordering was not explicitly specified.

ORDER BY takes the name of one or more columns by which to sort the output.

```sql
SELECT prod_name 
FROM Products 
ORDER BY prod_name;
```

注意：When specifying an ORDER BY clause, be sure that it is the last clause in your SELECT statement. If it is not the last clause, an error will be generated.

## 3-2 Sorting by Multiple Columns

The following code retrieves three columns and sorts the results by two of them

```sql
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY prod_price, prod_name;
```

## 3-3 Sorting by Column Position

```sql
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY 2, 3;
```

## 3-4 Specifying Sort Direction

```sql
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY prod_price DESC;
```

The DESC keyword only applies to the column name that directly precedes it.
DESC is short for DESCENDING，The opposite of DESC is ASC(default)

### Case-Sensitivity and Sort Orders

In dictionary sort order, A is treated the same as a, and that is the default behavior for most Database Management Systems. However, most good DBMSs enable database administrators to change this behavior if needed.

The key here is that, if you do need an alternate sort order, you may not be able to accomplish this with a simple ORDER BY clause. You may need to contact your database administrator.

---

# 4. Filtering Data

## 4-1 Using the WHERE Clause

```sql
SELECT prod_name, prod_price 
FROM Products 
WHERE prod_price = 3.49;
```

As a rule, this practice is strongly discouraged. Databases are optimized to perform filtering quickly and efficiently. Making the client application (or development language) do the database’s job will dramatically impact application performance and will create applications that cannot scale properly. In addition, if data is filtered at the client, the server has to send unneeded data across the network connections, resulting in a waste of network bandwidth usage.

## 4-2 The WHERE Clause Operators

SQL supports a whole range of conditional operators

| Operator  | Description                  |
| --        | --                           |
| `=`       | Equality                     |
| `<>`      | Non-equality                 |
| `!=`      | Non-equality                 |
| `<`       | Less than                    |
| `<=`      | Less than or equal to        |
| `!<`      | Not less than                |
| `>`       | Greater than                 |
| `>=`      | Greater than or equal to     |
| `!>`      | Not greater than             |
| `BETWEEN` | Between two specified values |
| `IS NULL` | Is a NULL value              |

Some of the operators listed are redundant, examples:

`<>` is the same as `!=`
`!<` [not less than] accomplishes the same effect as `>=` [greater than or equal to]

If you are comparing a value against a column that is a string datatype, the delimiting quotes are required. Quotes are not used to delimit values used with numeric columns.

`!=` and `<>` can usually be used interchangeably. However, not all DBMSs support both forms of the non-equality operator.

**`NULL`: No value, as opposed to a field containing 0, or an empty string, or just spaces.**

Many DBMSs extend the standard set of operators, providing advanced filtering options. Refer to your DBMS documentation for more information.

### 注意：NULL and Non-matches

You might expect that when you filter to select all rows that do not have a particular value, rows with a NULL will be returned. But they will not. Because of the special meaning of unknown, the database does not know whether or not they match, and so they are not returned when filtering for matches or when filtering for non-matches.

When filtering data, make sure to verify that the rows with a NULL in the filtered column are really present in the returned data.

---

# 5. Advanced Data Filtering

## 5-1 Combining Where Clauses

For a greater degree of filter control, SQL lets you specify multiple WHERE clauses. These clauses may be used in two ways: as AND clauses or as OR clauses.

### Using the AND Operator

### Using the OR Operator

In fact, most of the better DBMSs will not even evaluate the second condition in an OR WHERE clause if the first condition has already been met

### Understanding Order of Evaluation

```sql
SELECT prod_name, prod_price 
FROM Products 
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01' AND prod_price >= 10;
```

SQL (like most languages) processes AND operators before OR operators. When SQL sees the above WHERE clause, it reads any products costing $10 or more made by vendor BRS01, and any products made by vendor DLL01 regardles of price.

```sql
SELECT prod_name, prod_price 
FROM Products 
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') AND prod_price >= 10;
```

## 5-2 Using the IN Operator

The IN operator is used to specify a range of conditions, any of which can be matched.

```sql
SELECT prod_name, prod_price 
FROM Products 
WHERE vend_id IN ('DLL01','BRS01') 
ORDER BY prod_name;
```

IN 的好处

- When you are working with long lists of valid options, the IN operator syntax isfar cleaner and easier to read.
- The order of evaluation is easier to manage when IN is used in conjunction with other AND and OR operators.
- IN operators almost always execute more quickly than lists of OR operators (although you’ll not see any performance difference with very short lists like the ones we’re using here).
- The biggest advantage of IN is that the IN operator can contain another SELECT statement, enabling you to build highly dynamic WHERE clauses.

## 5-3 Using the NOT Operator

NOT is useful in more complex clauses. For example, using NOT in conjunction with an IN operator makes it simple to find all rows that do not match a list of criteria.

---

# 6. Using Wildcard Filtering

## 6-1 Using the LIKE Operator

Using wildcards, you can create search patterns that can be compared against your data.

The wildcards themselves are actually characters that have special meanings within SQL WHERE clauses, and SQL supports several different wildcard types.
To use wildcards in search clauses, the LIKE operator must be used. LIKE instructs the DBMS that the following search pattern is to be compared using a wildcard match rather than a straight equality match.

Technically, LIKE is a predicate, not an operator.
Wildcard searching can only be used with text fields (strings)

### The Percent Sign (%) Wildcard

The most frequently used wildcard is the percent sign (%). Within a search string, **% means, match any number of occurrences of any character.**

```sql
SELECT prod_id, prod_name 
FROM Products 
WHERE prod_name LIKE '%bean bag%';
```

% also matches zero characters.
it may seem that the % wildcard matches anything, there is one exception, NULL. Not even the clause WHERE prod_name LIKE '%' will match a row with the value NULL as the product name.

### The Underscore (_) Wildcard
The underscore is used just like %, but instead of matching multiple characters the underscore matches just a single character.

### The Brackets ([]) Wildcard
The brackets ([]) wildcard is used to specify a set of characters, any one of which must match a character in the specified position (the location of the wildcard).

Unlike the wildcards describes thus far, **the use of [] to create sets is not supported by all DBMSs. Sets are supported by Microsoft Access and Microsoft SQL Server**. Consult your DBMS documentation to determine if sets are supported.

## 6-2 Tips for Using Wildcards

Wildcard searches typically take far longer to process than any other search types discussed previously. Here are some rules to keep in mind when using wildcards:

- Don’t overuse wildcards. If another search operator will do, use it instead.
- When you do use wildcards, try to not use them at the beginning of the search pattern unless absolutely necessary. Search patterns that begin with wildcards are the slowest to process
- Pay careful attention to the placement of the wildcard symbols. If they are misplaced, you might not return the data you intended.

---

# 7. Creating Calculated Fields

## 7-1 Understanding Calculated Fields

Data stored within a database’s tables is often not available in the exact format needed by your applications.
This is where calculated fields come in. Unlike all the columns that we retrieved in the lessons thus far, calculated fields don’t actually exist in database tables. Rather, a calculated field is created on-the-fly within a SQL SELECT statement.

It is important to note that only the database knows which columns in a SELECT statement are actual table columns and which are calculated fields.
From the perspective of a client, a calculated field’s data is returned in the same way as data from any other column.

**Many of the conversions and reformatting that can be performed within SQL statements can also be performed directly in your client application.**
**However, as a rule, it is far quicker to perform these operations on the database server than it is to perform them within the client.**

## 7-2 Concatenating Fields

In SQL SELECT statements, you can concatenate columns using a special operator. Depending on what DBMS you are using, this can be a plus sign (+) or two pipes (||).

```sql
# the syntax used by most DBMSs
SELECT vend_name + ' (' + vend_country + ')'
FROM Vendors
ORDER BY vend_name;
# The following is the same statement, but using the || syntax
SELECT vend_name || ' (' || vend_country || ')'
FROM Vendors
ORDER BY vend_name;
# here’s what you’ll need to do if using MySQL or MariaDB
SELECT Concat(vend_name, ' (', vend_country, ')')
FROM Vendors
ORDER BY vend_name;
```

Many databases(although not all) save text values padded to the column width, so your own results may indeed not contain those extraneous spaces. To return the data formatted properly, you must trim those padded spaces. This can be done using the SQL **RTRIM() function**

```sql
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
FROM Vendors
ORDER BY vend_name;
```

The SELECT statement used to concatenate the address field works well, as seen in the above output. But **what is the name of this new calculated column?** Well, the truth is, **it has no name; it is simply a value**.
Although this can be fine if you are just looking at the results in a SQL query tool, an unnamed column cannot be used within a client application because there is no way for the client to refer to that column.
To **solve this problem, SQL supports column aliases. An alias is just that, an alternate name for a field or value. Aliases are assigned with the AS keyword**.

```sql
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
AS vend_title
FROM Vendors
ORDER BY vend_name;
```

Aliases have other uses too. Some common uses include renaming a column if the real table column name contains illegal characters (for example, spaces), and expanding column names if the original names are either ambiguous or easily misread.

## 7-3 Performing Mathematical Calculations

```sql
SELECT prod_id,
       quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;
```

SQL supports the basic mathematical operators: +, -, *, /

### Test the Calculation

Although SELECT is usually used to retrieve data from a table, the FROM clause may be omitted to simply access and work with expressions. For example, SELECT 3 * 2; would return 6, SELECT Trim(' abc '); would return abc, and SELECT Now(); uses the Now() function to return the current date and time.

---

# 8. Using Data Manipulation Functions

## 8-1 Understanding Functions

An example of a function is the RTRIM()

functions tend to be very DBMS specific. In fact, very few functions are supported identically by all major DBMSs. Although all types of functionality are usually available in each DBMS, the function name or syntax can differ greatly.

| Function                 | Syntax                                                                                                                                                               |
| --                       | --                                                                                                                                                                   |
| Extract part of a string | Access uses `MID()`. DB2, Oracle, PostgreSQL, and SQLite use `SUBSTR()`. MariaDB, MySQL ans SQL Server use `SUBSTRING()`                                             |
| Datatype conversion      | Access and Oracle use multiple functions, one for each conversion type. DB2 and PostgreSQL uses `CAST()`. MariaDB, MySQL and SQL Server use `CONVERT()`              |
| Get current date         | Access use `NOW()`. DB@ and PostgreSQL use `CURRENT_DATE.` MariaDB and MySQL use `CURDATE()`. Oracle uses `SYSDATE`. SQL Server use `GETDATE()`. SQLite use `DATE()` |

## 8-2 Using Functions 

Most SQL implementations support the following types of functions:

- **Text functions** are used to manipulate strings of text (for example, trimming or padding values and converting values to upper and lowercase).
- **Numeric functions** are used to perform mathematical operations on numeric data (for example, returning absolute numbers and performing algebraic calculations).
- **Date and time functions** are used to manipulate date and time values and to extract specific components from these values (for example, returning differences between dates, and checking date validity).
- **System functions** return information specific to the DBMS being used (for example, returning user login information).

### Text Manipulation Functions

Commonly Used Text-Manipulation Functions

| Function                                    | Description                            |
| --                                          | --                                     |
| `LEFT()` (or use substring function)        | Returns characters from left of string |
| `LENGTH()` (also `DATALENGTH()` or `LEN()`) | Returns the length of a string         |
| `LOWER()` (`LCASE()` if using Access)       | Converts string to lowercase           |
| `LTRIM()`                                   | Trims while space from right of string |
| `SOUNDEX()`                                 | Returns a strings SOUNDEX value        |
| `UPPER()` (`UCASE()` if using Access)       | Converts string to uppercase           |

SOUNDEX is an algorithm that converts any string of text into an alphanumeric pattern describing the phonetic representation of that text. SOUNDEX takes into account similar sounding characters and syllables, enabling strings to be compared by how they sound rather than how they have been typed.

```sql
-- search using the SOUNDEX() function to match all contact names that sound 
-- similar to Michael Green:
SELECT cust_name, cust_contact 
FROM Customers 
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');
```

### Date and Time Manipulation Functions

The format used to store dates and times is usually of no use to your applications, and so date and time functions are almost always used to read, expand, and manipulate these values. Because of this, date and time manipulation functions are some of the most important functions in the SQL language. Unfortunately, they also tend to be the least consistent and least portable.

DBMSs typically offer far more than simple date part extraction. Most have functions for **comparing dates, performing date based arithmetic, options for formatting dates, and more**. But, as you have seen, **date-time manipulation functions are particularly DBMS specific**. Refer to your DBMS documentation for the list of the date-time manipulation functions it supports.

### Numeric Manipulation Functions

all the functions found in the major DBMSs, the numeric functions are the ones that are most uniform and consistent.

| Function | Description                                            |
| --       | --                                                     |
| `ABS()`  | Returns a number's absolute value                      |
| `COS()`  | Returns the trigonometric consine of a specified angle |
| `EXP()`  | Returns the exponential value of a specified number    |
| `PI()`   | Returns the value of PI                                |
| `SIN()`  | Returns the trigonometric sine of a specified angle    |
| `SQRT()` | Returns the square root of a specified number          |
| `TAN()`  | Returns the trigonometric tangent of a specified angle |

---

# 9. Summarizing Data

## 9-1 Using Aggregate functions

It is often necessary to summarize data without actually retrieving it all, and SQL provides special functions for this purpose. Using these functions, SQL queries are often used to retrieve data for analysis and reporting purposes. Examples of this type of retrieval are

- Determining the number of rows in a table (or the number of rows that meet some condition or contain a specific value).
- Obtaining the sum of a set of rows in a table.
- Finding the highest, lowest, and average values in a table column (either for all rows or for specific rows).

To facilitate this type of retrieval, SQL features a set of five aggregate functions

| Function  | Description                            |
| --        | --                                     |
| `AVG()`   | Returns a column's average value       |
| `COUNT()` | Returns the number of rows in a column |
| `MAX()`   | Returns a column's highest value       |
| `MIN()`   | Returns a column's lowest value        |
| `SUM()`   | Returns the sum of a column's values   |


### The AVG() Function

AVG() can be used to return the average value of all columns or of specific columns or rows

### Caution: Individual Columns Only

AVG() may only be used to determine the average of a specific numeric column, and that column name must be specified as the function parameter. To obtain the average value of multiple columns, multiple AVG() functions must be used.

#### Note: NULL Values

Column rows containing NULL values are ignored by the AVG() function.

```sql
SELECT AVG(prod_price) AS avg_price 
FROM Products 
WHERE vend_id = 'DLL01';
```

### The COUNT() Function

Using COUNT(), you can determine the number of rows in a table or the number of rows that match a specific criterion.

两种用法

- Use `COUNT(*)` to count the number of rows in a table, whether columns contain values or NULL values.
- Use `COUNT(column)` to count the number of rows that have values in a specific column, ignoring NULL values.

#### Note: NULL Values

Column rows with NULL values in them are ignored by the COUNT() function if a column name is specified, but not if the asterisk (*) is used.

```sql
SELECT COUNT(cust_email) AS num_cust 
FROM Customers;
```

### The MAX() Function

MAX() returns the highest value in a specified column. MAX() requires that the column name be specified

```sql
SELECT MAX(prod_price) AS max_price 
FROM Products;
```

#### Tip: Using MAX() with Non-Numeric Data

many (but not all) DBMSs allow it to be used to return the highest value in any columns including textual columns. When used with textual data, MAX() returns the row that would be the last if the data were sorted by that column.

#### Note: NULL Values

Column rows with NULL values in them are ignored by the MIN() function.

### The MIN() Function
MIN() does the exact opposite of MAX();

### The SUM() Function

```sql
SELECT SUM(item_price * quantity) AS total_price 
FROM OrderItems 
WHERE order_num = 20005;
```

#### Tip: Performing Calculations on Multiple Columns

All the aggregate functions can be used to perform calculations on multiple columns using the standard mathematical operators, as shown in the example.

## 9-2 Aggregates on Distinct Values

The five aggregate functions can all be used in two ways:
- To perform calculations on all rows, specify the ALL argument or specify no argument at all (because ALL is the default behavior).
- To only include unique values, specify the DISTINCT argument.

### Tip: ALL Is Default

The ALL argument need not be specified because it is the default behavior. If DISTINCT is not specified, ALL is assumed.

### Note: Not in Access

Microsoft Access does not support the use of DISTINCT within aggregate functions, and so the following example will not work with Access. To achieve a similar result in Access you will need to use a subquery to return DISTINCT data to an outer SELECT COUNT(*) statement.

```sql
SELECT AVG(DISTINCT prod_price) AS avg_price 
FROM Products 
WHERE vend_id = 'DLL01';
```

### Caution: No DISTINCT With COUNT(*)

**DISTINCT may only be used with COUNT() if a column name is specified.** DISTINCT may not be used with COUNT(*). Similarly, DISTINCT must be used with a column name and not with a calculation or expression.

### Tip: Using DISTINCT with MIN() and MAX()
Although DISTINCT can technically be used with MIN() and MAX(), there is actually no value in doing so. The minimum and maximum values in a column will be the same whether or not only distinct values are included.

### Note: Additional Aggregate Arguments
In addition to the DISTINCT and ALL arguments shown here, **some DBMSs support additional arguments such as TOP and TOP PERCENT that let you perform calculations on subsets of query results**. Refer to your DBMS documentation to determine exactly what arguments are available to you.

## 9-3 Combining Aggregate Functions

SELECT statements may contain as few or as many aggregate functions as needed.

```sql
SELECT COUNT(*) AS num_items, 
       MIN(prod_price) AS price_min, 
       MAX(prod_price) AS price_max, 
       AVG(prod_price) AS price_avg 
FROM Products;
```

Tips : When specifying alias names to contain the results of an aggregate function, try to not use the name of an actual column in the table.

---
