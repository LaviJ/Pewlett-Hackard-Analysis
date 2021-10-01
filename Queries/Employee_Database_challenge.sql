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
ORDER BY emp_no;

SELECT * FROM retirement_titles;

SELECT COUNT(*) FROM retirement_titles;


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
FROM retirement_titles as rt	
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT(*) FROM unique_titles;


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
