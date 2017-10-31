A. Create Database
------------------
create database test;

B. Select Database
------------------
use test;

C. Create table for storing transactional records
-------------------------------------------------
create table transactions(txnno INT, txndate STRING, custno INT, amount DOUBLE,
category STRING, product STRING, city STRING, state STRING, spendby STRING)
row format delimited
fields terminated by ','
stored as textfile;

D. Load the data into the table
-------------------------------
LOAD DATA LOCAL INPATH 'path/txns' OVERWRITE INTO TABLE transactions;

E. Describing metadata or schema of the table
---------------------------------------------
describe transactions;

F. Counting no of records
-------------------------
select count(*) from transactions;

G. Counting total spending by category of products
--------------------------------------------------
select category, sum(amount) from transactions group by category;

H. 10 customers
--------------------
select custno, sum(amount) from transactions group by custno limit 20;

I. Create partitioned table
---------------------------
create table TransCategory(txnno INT, txndate STRING, custno INT, amount DOUBLE,
product STRING, city STRING, state STRING, spendby STRING)
partitioned by (category STRING)
clustered by (state) INTO 10 buckets
row format delimited
fields terminated by ','
stored as textfile;


J. Configure Hive to allow partitions
-------------------------------------

set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
set hive.enforce.bucketing=true;

K. Load data into partition table
----------------------------------
from transactions txn INSERT OVERWRITE TABLE TransCategory PARTITION(category)
select txn.txnno, txn.txndate,txn.custno, txn.amount,txn.product,txn.city,txn.state,
txn.spendby, txn.category DISTRIBUTE BY category;


==========================
find sales based on age group
==========================

create table customer(custno string, firstname string, lastname string, age int,profession string)
row format delimited
fields terminated by ',';

load data local inpath 'path/custs' into table customer;

create table temp (custno int,firstname string,age int,profession string,amount double,product string)
row format delimited
fields terminated by ',';

insert overwrite table temp
select a.custno,a.firstname,a.age,a.profession,b.amount,b.product
from customer a JOIN transactions b ON a.custno = b.custno;

select * from temp limit 100;

create table temp2(custno int,firstname string,age int,profession string,amount double,product string, level string)
row format delimited
fields terminated by ',';

insert overwrite table temp2
select * , case
 when age<30 then 'Group1'
 when age>=30 and age < 50 then 'Group2'
 when age>=50 then 'Group3'
 else 'Group4'
end
from temp;



 select * from temp2 limit 100;

 describe temp2;

create table temp3 (level string, amount double)
row format delimited
fields terminated by ',';

insert overwrite table temp3
 select level,sum(amount) from temp2 group by level;
