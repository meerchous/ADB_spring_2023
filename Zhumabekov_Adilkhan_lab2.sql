/* #1 */
select * 
from employees
where salary > (select avg(salary) from employees where job_id like '%_PROG')
/* #2 */
select E.employee_id, E.full_name, E.salary, E.job_id 
from (select min(salary) as minimum ,departament_id from employees group by departament_id) as N 
join employees as E on E.departament_id = N.departament_id and E.salary = N.minimum
/* #3 */
select top 1 D.* 
from departaments as D
join employees as E  on E.employee_id = D.manager_id
order by hire_dat
/* #4 */
select full_name, len(replace(full_name,' ', '')) as f_name 
from employees 
order by f_name desc
/* #5 */
select top 1 D.departament_id, count(employee_id) as numerous, avg(salary)
from employees as E 
join departaments as D on E.departament_id = D.departament_id
group by D.departament_id 
order by numerous desc
/* #6 */
select departament_id, min(salary)
from employees
where salary > (select min(salary) as minimum from employees where departament_id = 50)
and departament_id <> 50
group by departament_id 
/* #7 */
select top 1 avg(salary) as max_avg_salary 
from employees 
group by departament_id
order by max_avg_salary desc
/* #8 */
select E.employee_id, E.full_name, D.departament_name, D.departament_id
from employees as E
join departaments as D on E.departament_id = D.departament_id
/* #9 */
select departament_name from departaments 
where departament_id not in (select distinct departament_id from employees)
/* #10 */
select E.full_name, E.salary, J.gra from employees as E
join job_grades as J on E.salary between J.lowest_sal and J.highest_sal
/* #11 */
select E.full_name, E.job_id, D.departament_name, E.hire_dat, J.gra from employees as E
join departaments as D on E.departament_id = D.departament_id 
join job_grades as J on E.salary between J.lowest_sal and J.highest_sal
where hire_dat between '1995-01-01' and '2021-02-11' and gra in ('A', 'B', 'C')
/* #12 */
select E.full_name, L.loc_name from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
/* #13 */
select E.full_name, L.loc_name, E.salary*0.1 as monthly_pension_contribution,
E.salary*0.1*12 as annual_pension_contribution, E.salary*0.09 as medicine_contribution
from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
/* #14 */
select top 3 L.loc_name, avg(salary) as avg_salary from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
group by L.loc_name
order by avg_salary desc
/* #15 */
select full_name from employees 
where employee_id <> (select manager_id from departaments where departament_id in
		(select distinct departament_id from employees where employee_id in (144,142)))
and departament_id in (select distinct departament_id from departaments where employee_id in (144,142))
/* #16 */
select E.*, L.loc_name from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
where L.loc_name = 'Valencia'
/* #17 */
select E.* from employees as E
join departaments as D on E.departament_id = D.departament_id
where E.employee_id <> D.manager_id
/* #18 */
select L.loc_name from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
where E.employee_id = 178
/* #19 */
select D.manager_id, (count(E.employee_id)-1) as subordinates from employees as E
join departaments as D on E.departament_id = D.departament_id
group by D.manager_id
order by subordinates desc
/* #20 */
select * from employees where employee_id =
(select manager_id from departaments where manager_id not in
(select E.employee_id from employees as E
join departaments as D on E.departament_id = D.departament_id
where E.employee_id = D.manager_id))
/* #21 */
select distinct C.country_name, L.loc_name, D.departament_id from employees as E
join departaments as D on E.departament_id = D.departament_id
join locations as L on D.location_id = L.loc_id
join countries as C on L.country_id = C.country_id
join (select D.departament_id, (count(E.employee_id)-1) as subordinates from employees as E
	  join departaments as D on E.departament_id = D.departament_id
	  group by D.departament_id
	  having count(E.employee_id) > 2) as B on E.departament_id = B.departament_id

/* #22 */
-- Write query to display city where a lot of payments go with substracting all taxes (13task)  --
select top 1 Pay.loc_name, (payments-overall_tax) as bill from (select L.loc_name, sum(E.salary) as payments from employees as E
				join departaments as D on E.departament_id = D.departament_id
				join locations as L on D.location_id = L.loc_id
				group by L.loc_name) as Pay
join 
			  (select L.loc_name, sum(E.salary*0.19) as overall_tax
				from employees as E
				join departaments as D on E.departament_id = D.departament_id
				join locations as L on D.location_id = L.loc_id
				group by L.loc_name) as Tax on Pay.loc_name = Tax.loc_name
order by bill desc

