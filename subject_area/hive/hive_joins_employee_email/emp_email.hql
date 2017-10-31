create table employee(name string, salary float,city string)
row format delimited
fields terminated by ',';

load data local inpath 'path/emp' into table employee;

select * from employee where name='Kathy';

create table mailid (name string, email string)
row format delimited
fields terminated by ',';


load data local inpath 'path/email' into table mailid;

select a.name,a.city,a.salary,b.email from
employee a join mailid b on a.name = b.name;

select a.name,a.city,a.salary,b.email from
employee a left outer join mailid b on a.name = b.name;

select a.name,a.city,a.salary,b.email from
employee a right outer join mailid b on a.name = b.name;

select a.name,a.city,a.salary,b.email from
employee a full outer join mailid b on a.name = b.name;