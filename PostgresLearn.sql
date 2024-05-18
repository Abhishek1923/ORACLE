-- Postgres New Findings:

PREPARE query(int, int) AS SELECT sum(customerid) FROM tb_customers
    WHERE customerid > $1 AND customerid < $2;
--     GROUP BY lastname;

EXPLAIN ANALYZE EXECUTE query(100, 200);

DEALLOCATE query;

PREPARE query(int, int, varchar) AS 
SELECT sum(customerid) 
FROM tb_customers
WHERE customerid > $1 AND customerid < $2
GROUP BY lastname;

EXPLAIN ANALYZE EXECUTE query(100, 200, 'Davis');


Select * from tb_customers;


EXPLAIN (FORMAT JSON) SELECT lastname, sum(customerid) 
FROM tb_customers
WHERE customerid > 1 AND customerid < 10
GROUP BY lastname;

======================================================================

-- PREPARE and EXECUTE statements

PREPARE query(int, int) AS SELECT sum(customerid) FROM tb_customers
    WHERE customerid > $1 AND customerid < $2;
--     GROUP BY lastname;

EXPLAIN ANALYZE EXECUTE query(100, 200);

DEALLOCATE query;

PREPARE query(int, int, varchar) AS 
SELECT sum(customerid) 
FROM tb_customers
WHERE customerid > $1 AND customerid < $2
GROUP BY lastname;

EXPLAIN ANALYZE EXECUTE query(100, 200, 'Davis');


Select * from tb_customers;


EXPLAIN (FORMAT JSON) SELECT lastname, sum(customerid) 
FROM tb_customers
WHERE customerid > 1 AND customerid < 10
GROUP BY lastname;

EXECUTE format('SELECT * from %s', quote_ident('result_'||(select id from ids where customerid >= 1)||'_table'))



======================================================================

SET NOCOUNT ON is a T-SQL statement that stops the message indicating the number of rows affected by a Transact-SQL statement.

    SET NOCOUNT ON is used to improve the performance of stored procedures by reducing network traffic.

    It is particularly useful when executing large scripts or batch processes.

    It is also used to suppress the '(X row(s) affected)' message in SQL Server Management Studio.

    To turn it off, use SET NOCOUNT OFF.

======================================================================

-- Generating random number and insert them in a column:

UPDATE tb_customers
SET salary = floor(random() * (999999 - 30000 + 1)) + 30000;

UPDATE tb_customers
SET salary = ROUND(50000 + RANDOM() * 100000, 2);


======================================================================


SELECT ranked_salaries.name, ranked_salaries.SALARY 
FROM (
    SELECT (firstname||' '||lastname) name,SALARY, DENSE_RANK() OVER (ORDER BY SALARY DESC) AS RANKED_SALARY 
    FROM tb_customers
) AS ranked_salaries
WHERE RANKED_SALARY = 6;

======================================================================

-- for PIVOT ans UNPIVOT

CREATE EXTENSION IF NOT EXISTS tablefunc; -- Ensure the tablefunc extension is enabled

SELECT * FROM crosstab(
    'SELECT lastname, SUM(salary) AS total_salary
     FROM tb_customers
     GROUP BY lastname
     ORDER BY lastname',
    'SELECT DISTINCT lastname FROM tb_customers ORDER BY 1'
) AS ct(lastname varchar, "Total Salary" numeric);


=====================================================================

Question 1: SQL Query to find second highest salary of Employee

Answer: There are many ways to find second highest salary of Employee in SQL, you can either use SQL Join or Sub-query to solve this problem. Here is SQL query using Sub-query:

    select MAX(Salary) from Employee WHERE Salary NOT IN (select MAX(Salary) from Employee );  

See How to find second highest salary in SQL

for more ways to solve this problem.

Question 2: SQL Query to find Max Salary from each department.

Answer: You can find the maximum salary for each department by grouping all records by DeptId and then using MAX() function to calculate maximum salary in each group or each department.

    SELECT DeptID, MAX(Salary) FROM Employee  GROUP BY DeptID.  

These questions become more interesting if Interviewer will ask you to print department name instead of department id, in that case, you need to join Employee table with Department using foreign key DeptID, make sure you do LEFT or RIGHT OUTER JOIN to include departments without any employee as well. Here is the query

    SELECT DeptName, MAX(Salary) FROM Employee e RIGHT JOIN Department d ON e.DeptId = d.DeptID GROUP BY DeptName; 

In this query, we have used RIGHT OUTER JOIN because we need the name of the department from Department table which is on the right side of JOIN clause, even if there is no reference of dept_id on Employee table.

Question 3: Write SQL Query to display the current date.

Answer: SQL has built-in function called GetDate() which returns the current timestamp. This will work in Microsoft SQL Server, other vendors like Oracle and MySQL also has equivalent functions.

    SELECT GetDate();  

Question 4: Write an SQL Query to check whether date passed to Query is the date of given format or not.

Answer: SQL has IsDate() function which is used to check passed value is a date or not of specified format, it returns 1(true) or 0(false) accordingly. Remember ISDATE() is an MSSQL function and it may not work on Oracle, MySQL or any other database but there would be something similar.

    SELECT  ISDATE('1/08/13') AS "MM/DD/YY";  

It will return 0 because passed date is not in correct format.

Question 5: Write an SQL Query to print the name of the distinct employee whose DOB is between 01/01/1960 to 31/12/1975.

Answer: This SQL query is tricky, but you can use BETWEEN clause to get all records whose date fall between two dates.

    SELECT DISTINCT EmpName FROM Employees WHERE DOB  BETWEEN ‘01/01/1960’ AND ‘31/12/1975’; 

Question 6: Write an SQL Query find number of employees according to gender whose DOB is between 01/01/1960 to 31/12/1975.

Answer :

    SELECT COUNT(*), sex from Employees  WHERE  DOB BETWEEN '01/01/1960' AND '31/12/1975'  GROUP BY sex; 

Question 7: Write an SQL Query to find an employee whose Salary is equal or greater than 10000.

Answer :

    SELECT EmpName FROM  Employees WHERE  Salary>=10000; 

Question 8: Write an SQL Query to find name of employee whose name Start with ‘M’

Answer :

    SELECT * FROM Employees WHERE EmpName like 'M%'; 

Question 9: find all Employee records containing the word "Joe", regardless of whether it was stored as JOE, Joe, or joe.

Answer :

    SELECT * from Employees  WHERE  UPPER(EmpName) like '%JOE%'; 

Question 10: Write an SQL Query to find the year from date.

Answer: Here is how you can find Year from a Date in SQL Server 2008

    SELECT YEAR(GETDATE()) as "Year"; 

Question 11: Write SQL Query to find duplicate rows in a database? and then write SQL query to delete them?
Answer: You can use the following query to select distinct records:

    SELECT * FROM emp a WHERE rowid = (SELECT MAX(rowid) FROM EMP b WHERE a.empno=b.empno) 

to Delete:

    DELETE FROM emp a WHERE rowid != (SELECT MAX(rowid) FROM emp b WHERE a.empno=b.empno); 

Question 12: There is a table which contains two column Student and Marks, you need to find all the students, whose marks are greater than average marks i.e. list of above average students.
Answer: This query can be written using subquery as shown below:

    SELECT student, marks from table where marks > SELECT AVG(marks) from table) 

Question 13: How do you find all employees which are also manager? .
You have given a standard employee table with an additional column mgr_id, which contains employee id of the manager.

Answer: You need to know about self-join to solve this problem. In Self Join, you can join two instances of the same table to find out additional details as shown below

    SELECT e.name, m.name FROM Employee e, Employee m WHERE e.mgr_id = m.emp_id; 

this will show employee name and manager name in two column e.g.

name manager_name
John David

One follow-up is to modify this query to include employees which do not have a manager. To solve that, instead of using the inner join, just use left outer join, this will also include employees without managers.

Question 14: You have a composite index of three columns, and you only provide the value of two columns in WHERE clause of a select query? Will Index be used for this operation? For example if Index is on EmpId, EmpFirstName, and EmpSecondName and you write query like

    SELECT * FROM Employee WHERE EmpId=2 and EmpFirstName='Radhe' 

If the given two columns are secondary index column then the index will not invoke, but if the given 2 columns contain the primary index(first column while creating index) then the index will invoke. In this case, Index will be used because EmpId and EmpFirstName are primary columns.

=========================================================================

In what sequence SQL statements are processed?

The clauses of the select are processed in the following sequence

    FROM clause
    WHERE clause
    GROUP BY clause
    HAVING clause
    SELECT clause
    ORDER BY clause
    TOP clause


---------------------------------
By Mistake, Duplicate records exists in a table, how can we delete the copy of a record? 

with T as
(
    select * , row_number() over (partition by Emp_ID order by Emp_ID) as rank
    from employee
)

delete
from T
where rank > 1
--------------------------------
What’s the logical difference, if any, between the following SQL expressions?

-- Statement 1 
SELECT COUNT ( * ) FROM Employees

-- Statement 2
SELECT SUM ( 1 ) FROM Employees

They’re the same unless table Employee table is empty, in which case the first yields a one-column, a one-row table containing zero, and the second yields a one-column, one-row table "containing a null."
----------------------------------
Write a Query to display even records from the table?

SELECT * FROM ( SELECT *, ROW_NUMBER() OVER (ORDER BY student_no) AS ‘ Row_ID’ FROM student)
WHERE row_id %2=0

Write a Query to display odd records from the student table?

SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY student_no) AS Row_ID FROM student)
WHERE row_id %2!=0
--------------------------------------
five uniform random numbers between 0.0 and 1.0.

SELECT random() FROM generate_series(1, 5)

--------------------------------------
SELECT floor(10 * random()) FROM generate_series(1, 5)

--------------------------------------
Using an existing table, make an empty one.
Explanation:

Select * into employeecopy from employee where 1=2 
-----------------------------------------

-- For EXTENSIONS

SELECT name, default_version, installed_version 
FROM pg_available_extensions WHERE name LIKE('plpy*')

using PL/Python SQL extension

Create extension plpython3u;

CREATE FUNCTION pymax (a integer, b integer)
  RETURNS integer
AS $$
  if a > b:
    return a
  return b
$$ LANGUAGE plpython3u;

CREATE FUNCTION pystrip(x text)
  RETURNS text
AS $$
  global x
  x = x.strip()  # ok now
  return x
$$ LANGUAGE plpython3u;
---------------------------------------

-- use of CTId in postgres

The “CTID” field is a field that exists in every PostgresSQL table, it is always unique for each and every record in the table. It denotes the Physical location of the data.

select ctid,* from tb_customers ;

-- for comparision of ctid
select ctid,* from tb_customers where ctid='(0,12)';

-- Deleting record from ctid
DELETE FROM tb_customers WHERE ctid IN
(SELECT ctid FROM tb_customers WHERE customerid = 10 LIMIT 100 FOR UPDATE)


---------------------------------------
-- EXTENSION: pg_dump :extract a PostgreSQL database into a script file or other archive file

PostgreSQL pg_dump is a database tool that helps you make automatic, consistent backups. For example, you can back up offline and online databases. The utility creates a set of SQL statements and processes them against the database instance to create a dump file that can use to restore the database later.

---------------------------------------

-- pg_hba.conf file in postgres
-- Client authentication is controlled by a configuration file, which traditionally is named pg_hba.conf and is stored in the database cluster's
--  data directory. (HBA stands for host-based authentication.) A default pg_hba.conf file is installed when the data directory is initialized by initdb.
--   It is possible to place the authentication configuration file elsewhere, however; see the hba_file configuration parameter.

--------------------------------------

-- SEQUENCE IN POSTGRES

CREATE SEQUENCE [ IF NOT EXISTS ] sequence_name
    [ AS { SMALLINT | INT | BIGINT } ]
    [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ] 
    [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ] 
    [ CACHE cache ] 
    [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]

-------------------------------------

-- CREATING CUSOTM DATATYPES

CREATE DOMAIN valid_email AS text
	NOT NULL
	CHECK (value ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
;


alter table tb_customers
add column email valid_email default 'sample123@gamil.com';

Update tb_customers t
set email='abhishek230401@gmail.com'
where t.customerid=1;

Select * from tb_customers
where customerid=1;

----------------------------------------

-- Use of pg_stat_user_indexes: for access all the indexes present in the data base as a superuser

select * from pg_stat_user_indexes

-----------------------------------------

-- EXCEPTION HANDLING

declare
   ...
begin
    ...
exception
    when condition [or condition...] then
       handle_exception;
   [when condition [or condition...] then
       handle_exception;]
   [when others then
       handle_other_exceptions;
   ]
end;


exception 
when others then
RAISE INFO 'Error Name:%',SQLERRM;
RAISE INFO 'Error State:%', SQLSTATE;
RAISE INFO 'Error Context:%', err_context;
RAISE NOTICE 'Calling cs_create_job(%)', v_job_id;
RAISE INFO 'Simple Error Message';
return -1;


Use this for specific error codes:https://www.postgresql.org/docs/current/errcodes-appendix.html

-------------------------------------------

-- FULL TEXT SEARCHING IN POSTGRES

To implement full text searching there must be a function to create a tsvector from a document and a tsquery from a user query.

to_tsvector parses a textual document into tokens, reduces the tokens to lexemes, and returns a tsvector which lists the lexemes together with their positions in the document.
 The document is processed according to the specified or default text search configuration. Here is a simple example:
SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats');


to_tsquery creates a tsquery value from querytext, which must consist of single tokens separated by the tsquery operators & (AND), | (OR), ! (NOT), and <-> (FOLLOWED BY), 
possibly grouped using parentheses. In other words, the input to to_tsquery must already follow the general rules for tsquery input. 
The difference is that while basic tsquery input takes the tokens at face value, to_tsquery normalizes each token into a lexeme using the specified 
or default configuration, and discards any tokens that are stop words according to the configuration. For example:
SELECT to_tsquery('english', 'The & Fat & Rats');

plainto_tsquery transforms the unformatted text querytext to a tsquery value. The text is parsed and normalized much as for to_tsvector, then the & (AND) tsquery operator is inserted between surviving words.
SELECT plainto_tsquery('english', 'The Fat Rats');

phraseto_tsquery behaves much like plainto_tsquery, except that it inserts the <-> (FOLLOWED BY) operator between surviving words instead of the & (AND) operator. 
Also, stop words are not simply discarded, but are accounted for by inserting <N> operators rather than <-> operators. This function is useful when 
searching for exact lexeme sequences, since the FOLLOWED BY operators check lexeme order not just the presence of all the lexemes.
SELECT phraseto_tsquery('english', 'The Fat Rats');

 plainto_tsquery and phraseto_tsquery, the websearch_to_tsquery function will not recognize tsquery operators, weight labels, or prefix-match labels in its input.
 SELECT websearch_to_tsquery('english', 'The fat rats');
 websearch_to_tsquery
----------------------
 'fat' & 'rat'
(1 row)

SELECT websearch_to_tsquery('english', '"supernovae stars" -crab');
       websearch_to_tsquery
----------------------------------
 'supernova' <-> 'star' & !'crab'
(1 row)

SELECT websearch_to_tsquery('english', '"sad cat" or "fat rat"');
       websearch_to_tsquery
-----------------------------------
 'sad' <-> 'cat' | 'fat' <-> 'rat'
(1 row)

SELECT websearch_to_tsquery('english', 'signal -"segmentation fault"');
         websearch_to_tsquery
---------------------------------------
 'signal' & !( 'segment' <-> 'fault' )
(1 row)

SELECT websearch_to_tsquery('english', '""" )( dummy \\ query <->');
 websearch_to_tsquery
----------------------
 'dummi' & 'queri'
(1 row)

-------------------------------------------

-- CROSSTAB FUNCITONS
create Table ProductSales
(    Productname varchar(50),
  Year int,
  Sales int
);
Insert into ProductSales values
  ('A',2017,100),
  ('A',2018,150),
  ('A',2019,300),
  ('A',2020,500),
  ('A',2021,450),
  ('A',2022,675),
  ('B',2017,0),
  ('B',2018,900),
  ('B',2019,1120),
  ('B',2020,750),
  ('B',2021,1500),
  ('B',2022,1980);

Select * from ProductSales;

select distinct year from ProductSales; -- 6 years so we need to create 6 columns for representing years

Select * from
crosstab('select Productname,year,sales from ProductSales order by 1,2')
as ProductSales(Productname varchar(50),year1 int,y2 int, y3 int,y4 int,y5 int,y6 int);


SELECT * FROM crosstab('
SELECT str.storename as store_name, prd.Productname as product_name, sum(sl.numberofunitssold) as total_units
FROM sales sl
LEFT JOIN DepartmentStores str ON sl.storeid = str.id
LEFT JOIN products prd ON sl.productid = prd.id
GROUP BY storename, productname
ORDER BY storename ASC, productname ASC
', 'SELECT DISTINCT Productname FROM products ORDER BY Productname ASC')
AS
productsales(storename varchar, candle int, sandlewood_stick int, soap int);

----------------------------------------------

-- VACUUM — garbage-collect and optionally analyze a database

ALTER TABLE tb_customers 
SET (autovacuum_analyze_threshold = 9)


-- when showing its ctid it resets its ctid which shows that this auto vaccum the table
select ctid,* from tb_customers;


    Number of rows in each table
    Number of dead tuples in each table
    The time of the last vacuum for each table
    The time of last analyze for each table
    The rate of data insert/update/delete in each table
    The time taken by autovacuum for each table
    Warnings about tables not being vacuumed
    Current performance of most critical queries and the tables they access
    Performance of the same queries after a manual vacuum/analyze
-----------------------------------------------

-- 2nd highest salary

WITH T AS
(
  SELECT (firstname || ' ' || lastname) AS fullname, 
         salary,
         DENSE_RANK() OVER (ORDER BY salary DESC) AS Rnk
  FROM tb_customers
)
SELECT fullname
FROM T
WHERE Rnk = 2;



SELECT name, salary
FROM employee A
WHERE n-1 = (SELECT count(1) 
             FROM employee B 
             WHERE B.salary>A.salary)

SELECT (firstname||' '||lastname), salary
FROM tb_customers A
WHERE 3 = (SELECT count(1) 
             FROM tb_customers B 
             WHERE B.salary>A.salary)


----------------------------------------------

-- fetch the duplicate records in a table
SELECT column1, column2, COUNT(*) 
FROM table_name 
GROUP BY column1, column2 
HAVING COUNT(*) > 1; 

----------------------------------------------

-- fetching odd no of records from a table

SELECT * FROM my_table WHERE MOD(my_column, 2) = 1;
SELECT * FROM tb_customers WHERE MOD(customerid, 2) = 1;

----------------------------------------------

-- nvl function

NVL() is an inbuilt function in ORACLE that replaces the NULL values with some other meaningful values in the resultant table of a query. 
Following will be the syntax for the NVL() function:

NVL(val_1, val_2);

It accepts two values as arguments:

- If the value of the first parameter is non-null, then the NVL() function will retrieve val_1.
- If the value of the first parameter “val_1” is equal to “NULL”, then the NVL() function will retrieve the value of the second parameter “val_2”.
- So, in the second parameter, users can specify any value as an alternative to the “NULL” value. So that if the value of the first argument becomes “NULL”, 
the NVL() function retrieves the specified value instead of retrieving the null value.








