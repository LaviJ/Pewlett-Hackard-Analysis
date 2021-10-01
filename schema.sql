--Module 7.2.2 Create tables in SQL & 7.2.3 Import Data
-- Drop table if exists
DROP TABLE departments;

-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

SELECT * FROM departments

-- Drop table if exists
DROP TABLE employee;

CREATE TABLE employee (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
	 first_name VARCHAR NOT NULL,
	 last_name VARCHAR NOT NULL,
	 gender VARCHAR NOT NULL,
	 hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

SELECT * FROM employee

-- Drop table if exists
DROP TABLE dept_manager;

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employee (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager

-- Drop table if exists
DROP TABLE salaries;

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employee (emp_no),
  PRIMARY KEY (emp_no)
);

SELECT * FROM salaries

-- Drop table if exists
DROP TABLE department_employee;

CREATE TABLE department_employee (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employee (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
	
SELECT * FROM department_employee

-- Drop table if exists
DROP TABLE titles;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(30) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employee (emp_no),
	PRIMARY KEY (emp_no,title,from_date)
);

SELECT * FROM titles

SELECT *
FROM information_schema.columns
WHERE table_name = 'titles';

--Module 7.3.1 Query Dates
SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employee
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employee
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employee
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employee
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

--Module 7.3.2 Join the Tables
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employee
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

--Module 7.3.3 Joins in Action

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    department_employee.to_date
	FROM retirement_info
	LEFT JOIN department_employee
	ON retirement_info.emp_no = department_employee.emp_no;
	
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN department_employee as de
ON ri.emp_no = de.emp_no;

DROP TABLE current_emp;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN department_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * from current_emp;

--Module 7.3.4 Use Count, Group By, and Order By
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_department_summary
FROM current_emp as ce
LEFT JOIN department_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM retirement_department_summary;



--Module 7.3.5 Create Additional Lists
--List 1: Employee Information
SELECT * FROM salaries;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT * FROM retirement_info;

SELECT emp_no,
    first_name,
	last_name,
    gender
INTO emp_info
FROM employee
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;

DROP TABLE emp_info;

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employee as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN department_employee as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
SELECT * FROM emp_info;

--List 2: Management
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT * FROM manager_info;

--List 3: Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN department_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info;

DROP TABLE sales_list;

--7.3.6 Create a Tailored List
SELECT de.emp_no,
ri.first_name,
ri.last_name,
d.dept_name
INTO sales_list
FROM retirement_info as ri
INNER JOIN department_employee AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

SELECT * FROM sales_list;

DROP TABLE sales_dev_list;

--7.3.6 Create a Tailored List for Sales & Development departments
SELECT de.emp_no,
ri.first_name,
ri.last_name,
d.dept_name
INTO sales_dev_list
FROM retirement_info as ri
INNER JOIN department_employee AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

SELECT * FROM sales_dev_list;

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
