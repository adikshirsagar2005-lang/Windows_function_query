create database windows_function;
use windows_function;

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(30),
    salary INT
);

INSERT INTO employee VALUES
(101, 'Amit', 'IT', 60000),
(102, 'Rahul', 'IT', 50000),
(103, 'Priya', 'IT', 50000),
(104, 'Sneha', 'IT', 40000),
(105, 'Rohit', 'HR', 70000),
(106, 'Pooja', 'HR', 60000),
(107, 'Neha', 'HR', 60000),
(108, 'Karan', 'HR', 45000),
(109, 'Om', 'Sales', 55000),
(110, 'Riya', 'Sales', 45000),
(111, 'Ajay', 'Sales', 45000),
(112, 'Kavya', 'Sales', 35000);


select * from employee;
-- Q1. Assign a ROW_NUMBER() to employees based on salary in descending order within each department.
select *,
row_number() over(partition by department order by salary desc) 
from employee;

-- Q2. Rank employees by salary within each department using RANK().
select *, 
rank()  over(partition by department order by salary desc)
from employee;

-- Q3. Rank employees by salary within each department using DENSE_RANK().
select *, 
		dense_rank()  over(partition by department order by salary desc) 
        from employee
        ;

-- Q4. Find all employees earning the second-highest distinct salary in each department.
with ranked_employees as
					(select *,
					dense_rank()  over(partition by department order by salary desc) as salary_rank
					from employee)
   (
   select *
   from  ranked_employees
   where salary_rank = 2);

-- Q5. Find the top 3 highest-paid employees in each department.

with ranked_employee as (
select *,
		dense_rank()  over(partition by department order by salary desc) as salary_rank
        from employee) 
        
(select * 
from ranked_employee 
where  salary_rank <= 3);

-- Q6. Find employees whose salary is greater than their department's average salary.

with ranked_employee as (
select * ,
		avg(salary) over(partition by department ) as department_avg_salary
        from employee) 
        
select * from  ranked_employee 
where salary >  department_avg_salary;

-- Q7. Find all employees earning the highest salary in each department.
select * from (
select *, 
		rank() over(partition by department order by salary desc) as salary_rank
        from employee 
        ) as t
where salary_rank =1;

-- Q8. Find all employees earning the third-highest distinct salary in each department.
with ranked_employee as (
select *,
		dense_rank()  over(partition by department order by salary desc) as salary_rank
        from employee
        )
select * from ranked_employee
where salary_rank =3;

-- Q9. Find employees who have the same salary.
select *
from(
		select *,
		count(*) over(partition by salary ) as salary_count
        from employee
        ) as t
        where salary_count > 1;



