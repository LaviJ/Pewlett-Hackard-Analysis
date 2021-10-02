-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
ORDER BY _____, _____ DESC;

--Module 7 Challenge
--Deliverable 1: The Number of Retiring Employees by Title
DROP TABLE retirement_titles;

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    t.title,
   	t.from_date,
    t.to_date
INTO retirement_titles
FROM employee as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--AND (t.to_date = '9999-01-01')
ORDER BY emp_no;

SELECT * FROM retirement_titles;

SELECT COUNT(emp_no) FROM retirement_titles;


--Removing duplicates from the retirement_titles table :
DROP TABLE unique_titles;
	 
SELECT DISTINCT ON (emp_no)
  	emp_no,
  	first_name,
	last_name,
    title,
   	from_date,
    to_date
INTO unique_titles
FROM retirement_titles	
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT(*) FROM unique_titles;

SELECT COUNT(*) FROM unique_titles
WHERE (to_date < '9999-01-01');

-- Creting a table for sum of employees retiring titlewise.
DROP TABLE retiring_titles;

SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

SELECT SUM(count) FROM retiring_titles;

--Deliverable 2: The Employees Eligible for the Mentorship Program
DROP TABLE mentorship_eligibilty;

SELECT DISTINCT ON (emp_no)
  	e.emp_no,
  	e.first_name,
	e.last_name,
	de.from_date,
	de.to_date,
    t.title
INTO mentorship_eligibilty
FROM employee as e
INNER JOIN department_employee as de ON e.emp_no = de.emp_no
INNER JOIN titles as t ON de.emp_no = t.emp_no
--ON (e.emp_no = de.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;

SELECT * FROM mentorship_eligibilty;

SELECT COUNT(*) FROM mentorship_eligibilty;	


--Two additional queries for challenge
--Count of only current employess born from birth_date BETWEEN 1952-01-01 AND '1955-12-31 that are about to retire.
DROP TABLE curr_emp_to_retire

SELECT DISTINCT ON (emp_no)
  	e.emp_no,
  	e.first_name,
	e.last_name,
	de.from_date,
	de.to_date,
    t.title,
	s.salary
INTO curr_emp_to_retire
FROM employee as e
INNER JOIN department_employee as de ON e.emp_no = de.emp_no
INNER JOIN titles as t ON de.emp_no = t.emp_no
INNER JOIN salaries as s ON de.emp_no = s.emp_no
--ON (e.emp_no = de.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;
SELECT * FROM curr_emp_to_retire;

SELECT COUNT(*) FROM curr_emp_to_retire;

DROP TABLE summary_emp_retire;

SELECT
title,
COUNT(emp_no) as Total_Employees,
SUM(salary) as Total_Salaries
INTO summary_emp_retire
FROM curr_emp_to_retire
GROUP BY title
ORDER BY count(emp_no) DESC;
SELECT * FROM summary_emp_retire;

SELECT 
COUNT(emp_no),
SUM(salary)
FROM curr_emp_to_retire;

-- summary of employees eligible for mentorship program of employees with birh year of 1965 :
DROP TABLE mentorship_eligibilty_salary;

SELECT DISTINCT ON (emp_no)
  	me.emp_no,
  	me.first_name,
	me.last_name,
	me.from_date,
	me.to_date,
    me.title,
	s.salary
INTO mentorship_eligibilty_salary
FROM mentorship_eligibilty as me
INNER JOIN salaries as s ON me.emp_no = s.emp_no
--ON (e.emp_no = de.emp_no = t.emp_no)
ORDER BY emp_no, to_date DESC;
SELECT * FROM mentorship_eligibilty_salary;

SELECT COUNT(*) FROM mentorship_eligibilty_salary;	

DROP TABLE summary_mentorship_eligibilty_salary;

SELECT
title,
COUNT(emp_no) as Total_Employees,
SUM(salary) as Total_Salaries
INTO summary_mentorship_eligibilty_salary
FROM mentorship_eligibilty_salary
GROUP BY title
ORDER BY count(emp_no) DESC;
SELECT * FROM summary_mentorship_eligibilty_salary;

SELECT 
COUNT(emp_no),
SUM(salary)
FROM mentorship_eligibilty_salary;
