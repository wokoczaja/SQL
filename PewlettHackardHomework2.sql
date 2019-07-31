--Create table for departments csv file
create table departments (
dept_no char(5) not null primary key,
dept_name varchar(100) not null
);
--select * from departments

--Create table for employees csv file
create table employees (
emp_no int not null primary key,
birth_date date not null,
first_name char(20) not null,
last_name char(20) not null,
gender varchar(10) not null,
hire_date date not null);
--select * from employees

--Create table for dept_emp
create table dept_emp (
emp_no int not null,
dept_no char(5) not null,
from_date date not null,
to_date date not null);
--select * from dept_emp

--Create table for dept_manager csv file
create table dept_manager (
dept_no char(5) not null,
emp_no int not null,
from_date date not null,
to_date date not null);
--select * from dept_manager

--Create table for salaries csv
create table salaries (
emp_no int not null primary key,
salary decimal not null,
from_date date not null,
to_date date not null);
--select * from salaries

--Create table for titles csv
create table titles (
emp_no int not null,
title varchar(25) not null,
from_date date not null,
to_date date not null);
--Select * from titles

--Create schema called employeeinfo
create schema employeeinfo;

--DROP tables under public schema and add them under EmployeeInfo schema
DROP TABLE if exists employees;
DROP TABLE if exists departments;
DROP TABLE if exists dept_emp;
DROP TABLE if exists dept_manager;
DROP TABLE if exists salaries;
DROP TABLE if exists titles;

--Recreate tables under new schema
create table employeeinfo.employees (
emp_no int not null primary key,
birth_date date not null,
first_name char(20) not null,
last_name char(20) not null,
gender varchar(10) not null,
hire_date date not null);
select * from employeeinfo.employees;

create table employeeinfo.departments (
dept_no varchar(5) not null primary key,
dept_name varchar(40) not null
);
select * from employeeinfo.departments

create table employeeinfo.dept_emp (
emp_no int not null,
foreign key (emp_no) references employeeinfo.employees(emp_no),
dept_no varchar(5) not null,
foreign key (dept_no) references employeeinfo.departments(dept_no),
from_date date not null,
to_date date not null);
select * from employeeinfo.dept_emp

create table employeeinfo.dept_manager (
dept_no char(5) not null,
foreign key (dept_no) references employeeinfo.departments(dept_no),
emp_no int not null,
from_date date not null,
to_date date not null);
select * from employeeinfo.dept_manager

create table employeeinfo.salaries (
emp_no int not null primary key,
foreign key (emp_no) references employeeinfo.employees(emp_no),
salary decimal not null,
from_date date not null,
to_date date not null);
select * from employeeinfo.salaries

create table employeeinfo.titles (
emp_no int not null,
foreign key (emp_no) references employeeinfo.employees(emp_no),
title varchar(25) not null,
from_date date not null,
to_date date not null);
Select * from employeeinfo.titles


SELECT 'postgresql' AS dbms,t.table_catalog,t.table_schema,t.table_name,c.column_name,c.ordinal_position,c.data_type,c.character_maximum_length,n.constraint_type,k2.table_schema,k2.table_name,k2.column_name FROM information_schema.tables t NATURAL LEFT JOIN information_schema.columns c LEFT JOIN(information_schema.key_column_usage k NATURAL JOIN information_schema.table_constraints n NATURAL LEFT JOIN information_schema.referential_constraints r)ON c.table_catalog=k.table_catalog AND c.table_schema=k.table_schema AND c.table_name=k.table_name AND c.column_name=k.column_name LEFT JOIN information_schema.key_column_usage k2 ON k.position_in_unique_constraint=k2.ordinal_position AND r.unique_constraint_catalog=k2.constraint_catalog AND r.unique_constraint_schema=k2.constraint_schema AND r.unique_constraint_name=k2.constraint_name WHERE t.TABLE_TYPE='BASE TABLE' AND t.table_schema NOT IN('information_schema','pg_catalog');

--1. List the following details about each employee: Employee#, last name, first name, gender, and salary
Select e.emp_no, e.last_name, e.first_name, e.gender, s.salary
from employeeinfo.employees e inner join employeeinfo.salaries s
	on e.emp_no = s.emp_no;
	
--2. List employees hired in 1986
--change hire_date to a varchar first
alter table employeeinfo.employees alter column hire_date type varchar(20);
--then list hire_dates of 1986
Select * From employeeinfo.employees where hire_date like '1986%';

--3. List the manager of each department with the dept number, dept name, the manager's employee number, last name
--   first name, and start and end employment dates.
Select d.dept_no, d.dept_name,dm.emp_no,e.last_name,e.first_name,dm.from_date,dm.to_date
	from employeeinfo.departments d inner join employeeinfo.dept_manager dm on
	d.dept_no=dm.dept_no
	join employeeinfo.employees e on e.emp_no=dm.emp_no;
	
--4. List the departments of each employee by employee #, last name, first name, dept name
Select e.emp_no, e.last_name, e.first_name, d.dept_name
	from employeeinfo.employees e inner join employeeinfo.dept_emp de on
	e.emp_no=de.emp_no
	join employeeinfo.departments d on d.dept_no=de.dept_no;
	
--5. List all employees whose first name is "Hercules" and last names begin with "B."
select * from employeeinfo.employees;
Select * from employeeinfo.employees where first_name ='Hercules'
and last_name like 'B%';

--6. List all employees in the Sales Dept by employee #, last name, first name, and dept name
select e.emp_no, e.last_name,e.first_name,d.dept_name
	from employeeinfo.employees e inner join employeeinfo.dept_emp de on
	e.emp_no=de.emp_no 
	join employeeinfo.departments d on de.dept_no=d.dept_no
	where d.dept_name='Sales';
	
--7. List all employees in the Sales and Development departments by employee #, last name, first name,
--    and dept name
select e.emp_no, e.last_name,e.first_name,d.dept_name
	from employeeinfo.employees e inner join employeeinfo.dept_emp de on
	e.emp_no=de.emp_no 
	join employeeinfo.departments d on de.dept_no=d.dept_no
	where d.dept_name='Sales' or d.dept_name='Development';
	
-- 8. List in descending order the frequency count of employee last names
select last_name, count(*) as numberofnames
from employeeinfo.employees
group by last_name
order by numberofnames desc;
	


