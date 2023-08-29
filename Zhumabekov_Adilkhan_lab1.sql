select * from employees
/* #1 */
select employee_id, full_name, hire_dat, salary from employees 
/* #2 */
select employee_id, full_name, email, salary from employees
/* #3 */
select distinct job_id from employees 
/* #4 */
select * from employees where salary >= 5000
/* #5 */
select employee_id, full_name, job_id, salary from employees where salary between 4000 and 7000
/* #6 */ 
select full_name, salary from employees where salary not between 3000 and 9000 
/* #7 */ 
select employee_id,
left(full_name, charindex(' ', full_name)) as name,
substring(full_name, charindex(' ', full_name),10) as surname,
salary from employees where salary<50000
/* #8 */ 
select employee_id, full_name, salary from employees where salary between 4001 and 6999
/* #9 */
select employee_id, full_name, salary, job_id from employees where employee_id in (144, 102, 200, 205)
/* #10 */
select employee_id, full_name, salary, job_id from employees where employee_id not in (144, 102, 200, 205)
/* #11 */
alter table employees add surname varchar(15);
update employees set surname = substring(full_name, charindex(' ', full_name)+1,10);
select employee_id,full_name, surname, salary from employees where surname like '_a%';
--alter table employees drop column surname
/* #12 */ 
select full_name from employees where full_name like '__a%'
/* #13 */ 
select * from employees
alter table employees add first_letter_of_name varchar(1), surname varchar(15);
update employees set first_letter_of_name = substring(full_name,1,1), surname = upper(substring(full_name, charindex(' ', full_name)+1,10));
select employee_id, full_name, email, salary from employees where email = concat(first_letter_of_name,surname)
alter table employees drop column first_letter_of_name, surname
/* #14 */
select employee_id, full_name, email, salary, hire_dat from employees order by salary asc, hire_dat desc
/* #15 */
select employee_id, full_name, salary from employees order by employee_id desc
/* #16 */
select avg(salary) as average, max(salary) as maximum, min(salary) as minimum, sum(salary) as sum from employees
/* #17 */
select * from employees where left(phone_number,1) = right(phone_number,1)
/* #18 */
select count(distinct job_id) as unique_professions from employees
/* #19 */
select  job_id, sum(salary) from employees group by job_id
/* #20 */
select job_id, avg(salary) as average_salary from employees group by job_id
/* #21 */
select max(salary) as maximum_salary, job_id from employees group by job_id
/* #22 */
select max(average_salary) from (select avg(salary)as average_salary from employees group by job_id) as average
/* #23 */
alter table employees add dream_salary int
update employees set dream_salary = salary * 3
select full_name, salary, dream_salary from employees
--alter table employees drop column dream_salary 
/* #24 */
select full_name, len(full_name) as length from employees
/* #25 */
select substring(full_name,1,charindex(' ',full_name)) as firs_name from employees
/* #26 */
select substring(full_name,1,3) as first_name from employees
/* #27 */
select reverse(full_name) as reverse_name from employees 
/* #28 */
select replace(full_name,'en','yu') as replaced_names from employees
/* #29 */
select upper(full_name) from employees
/* #30 */
-- Write a query to display full name, salary, happiness status of employees. They can be happy if their salary bigger than $10k.
select full_name, salary, IIF(salary>10000, 'Happy', 'Not Happy') as happiness_status from employees