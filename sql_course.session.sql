-- -- 1️⃣ Create Departments Table
-- CREATE TABLE departments (
--     id SERIAL PRIMARY KEY,
--     department_name VARCHAR(50) NOT NULL
-- );

-- -- Insert Sample Data
-- INSERT INTO departments (department_name) VALUES
-- ('Engineering'),
-- ('Sales'),
-- ('HR'),
-- ('Marketing'),
-- ('Finance');

-- ------------------------------------------------
-- -- 2️⃣ Create Employees Table
-- CREATE TABLE employees (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(50) NOT NULL,
--     department_id INT REFERENCES departments(id),
--     salary NUMERIC(10,2) NOT NULL,
--     manager_id INT
-- );

-- -- Sample Data
-- INSERT INTO employees (name, department_id, salary, manager_id) VALUES
-- ('Alice', 1, 90000, NULL),
-- ('Bob', 1, 80000, 1),
-- ('Charlie', 2, 70000, NULL),
-- ('David', 2, 60000, 3),
-- ('Eve', 3, 50000, NULL),
-- ('Frank', 3, 45000, 5),
-- ('Grace', 4, 75000, NULL),
-- ('Heidi', 4, 72000, 7),
-- ('Ivan', 5, 85000, NULL),
-- ('Judy', 5, 80000, 9);

-- ------------------------------------------------
-- -- 3️⃣ Create Customers Table
-- CREATE TABLE customers (
--     customer_id SERIAL PRIMARY KEY,
--     name VARCHAR(50),
--     signup_date DATE
-- );

-- INSERT INTO customers (name, signup_date) VALUES
-- ('John Doe', '2025-01-10'),
-- ('Jane Smith', '2025-02-15'),
-- ('Mike Johnson', '2025-03-20'),
-- ('Sara Lee', '2025-04-05'),
-- ('Tom Brown', '2025-05-12');

-- ------------------------------------------------
-- -- 4️⃣ Create Orders Table
-- CREATE TABLE orders (
--     order_id SERIAL PRIMARY KEY,
--     customer_id INT REFERENCES customers(customer_id),
--     order_date DATE,
--     amount NUMERIC(10,2)
-- );

-- INSERT INTO orders (customer_id, order_date, amount) VALUES
-- (1, '2025-02-01', 120.50),
-- (2, '2025-02-20', 250.00),
-- (1, '2025-03-15', 75.00),
-- (3, '2025-03-30', 400.00),
-- (4, '2025-04-10', 180.00),
-- (2, '2025-04-22', 220.00),
-- (5, '2025-05-20', 300.00),
-- (3, '2025-05-25', 150.00),
-- (1, '2025-06-05', 90.00);

-- ------------------------------------------------
-- -- 5️⃣ Create Logins Table
-- CREATE TABLE logins (
--     user_id INT REFERENCES customers(customer_id),
--     login_date DATE
-- );

-- INSERT INTO logins (user_id, login_date) VALUES
-- (1, '2025-02-01'),
-- (1, '2025-03-16'),
-- (1, '2025-06-05'),
-- (2, '2025-02-20'),
-- (2, '2025-04-23'),
-- (3, '2025-03-31'),
-- (3, '2025-05-26'),
-- (4, '2025-04-11'),
-- (5, '2025-05-21');



                     -- Find the 2nd highest salary

SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

SELECT salary
FROM (

SELECT salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
FROM
employees

) AS ranked_salaries
WHERE rnk = 2;

    -- Find duplicate records
    SELECT email, COUNT(*)
    FROM users
    GROUP BY email
    HAVING COUNT(*) > 1;


    -- 5. Find 3rd highest salary per department

SELECT *
    FROM (
SELECT salary, department_id,
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rnk
FROM employees
    ) AS t
WHERE rnk = 3;


-- 6. Find employees earning more than their manager

SELECT e.name, m.name
FROM employees e
INNER JOIN employees AS m
ON e.name = m.name
WHERE e.salary > m.salary;



-- 5️⃣ Find Nth Highest Salary

SELECT salary
FROM (
SELECT salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees
) AS t
WHERE rank = 3;



-- 7️⃣ Find Highest Salary Per Department
SELECT department_id, MAX(salary) AS highest_salary
FROM employees
GROUP BY department_id;


8️⃣ Employees Above Department Average

SELECT *
FROM employees  AS e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees AS e2
    WHERE e1.department_id = e2.department_id
);