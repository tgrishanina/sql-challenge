-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

--Create tables by exporting from QuickDBD

CREATE TABLE "employees" (
    "emp_no" INTEGER PRIMARY KEY NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE "titles" (
    "title_id" VARCHAR PRIMARY KEY NOT NULL,
    "title" VARCHAR NOT NULL

);

CREATE TABLE "departments" (
    "dept_no" VARCHAR PRIMARY KEY NOT NULL,
    "dept_name" VARCHAR NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
	
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
	    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER NOT NULL,
    "salary" INTEGER  NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);


--Analysis

-- 1) List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
JOIN salaries AS s ON e.emp_no = s.emp_no;


-- 2) List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- 3) List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT e.emp_no, e.last_name, e.first_name, m.dept_no
FROM employees AS e
JOIN dept_manager AS m on e.emp_no = m.emp_no;


-- 4) List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT demp.dept_no, d.dept_name, e.emp_no, e.first_name, e.last_name
FROM employees AS e
JOIN dept_emp as demp on demp.emp_no = e.emp_no
JOIN departments as d on d.dept_no = demp.dept_no;


-- 5) List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';


-- 6) List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN
	(SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN
		(SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'));


-- 7) List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT demp.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS demp ON e.emp_no = demp.emp_no
JOIN departments AS d on d.dept_no = demp.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';


-- 8) List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) as name_count
FROM employees
GROUP BY last_name
ORDER BY name_count DESC;