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


-- 8️⃣ Employees Above Department Average

SELECT *
FROM employees  AS e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees AS e2
    WHERE e1.department_id = e2.department_id
);

-- 9️⃣ Find Employees Without Manager

SELECT *
FROM employees
WHERE manager_id IS NULL;


-- 🔟 UNION vs UNION ALL

SELECT name FROM employees
UNION
SELECT name FROM Customers;

-- 11️⃣ Count Orders Per Customer

SELECT COUNT(*) AS order_count, customer_id
FROM Orders
GROUP BY customer_id;

-- 12️⃣ Customers With More Than 2 Orders
SELECT customer_id
FROM Orders
GROUP BY customers_id
HAVING COUNT(*) > 2;


-- 13️⃣ Monthly Revenue
SELECT DATE_TRUNC('month',order_date) AS MONTH,
SUM(amount) AS revenue
FROM orders
GROUP BY month


-- 14️⃣ Running Total of Revenue

SELECT order_date,
SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM orders
ORDER BY order_date;


-- 15️⃣ 7-Day Moving Average

SELECT order_date,
AVG(amount) OVER (
    ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING  AND CURRENT ROW) AS moving_avg
    FROM orders


    -- 16️⃣ Rank Employees by Salary

    SELECT name,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employees;

    -- 18️⃣ First Purchase Per Customer
    SELECT * 
    FROM(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rank_number
FROM orders
    ) AS t
    WHERE rank_number = 1;


--  19️⃣ Find Previous Order Using LAG
SELECT customer_id,order_date,amount,
LAG(amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_amount
FROM orders

-- 20️⃣ Percentage Contribution

SELECT customer_id,
SUM(amount) * 100 / SUM(SUM(amount)) OVER() AS percentage_contribution
FROM orders
GROUP BY customer_id



-- 21️⃣ Monthly Active Users (MAU)

SELECT DATE_TRUNC('month', login_date) AS month,
COUNT(DISTINCT user_id)
FROM logins
GROUP BY month;


-- 22️⃣ Daily Active Users (DAU)
SELECT DATE_TRUNC('day',login_date) AS day,
COUNT(DISTINCT user_id)
FROM logins
GROUP BY day;


-- 23️⃣ Retention Rate (30 Day)

SELECT COUNT(DISTINCT l.user_id) * 100 /
COUNT(DISTINCT c.customer_id) AS retention_rate
FROM customers c
LEFT JOIN logins AS l
ON c.customer_id = l.user_id
AND l.login_date >= c.signup_date + INTERVAL "30 days";

-- 24️⃣ Churn Rate
SELECT COUNT(*) * 100 / (SELECT COUNT(*) FROM customers) AS churn_rate
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders)

-- 25️⃣ Conversion Rate (Signup → Order)

SELECT COUNT(DISTINCT o.customer_id) * 100 /
COUNT(DISTINCT c.customer_id)   AS conversion_rate
FROM customer AS C
LEFT JOIN order AS ORDER BY
ON c.customer_id = o.customer_id

SELECT * FROM employees

-- 26️⃣ Create Index
CREATE INDEX idx_salary ON employees(salary);

-- 27️⃣ Check Execution Plan
EXPLAIN ANALYZE
SELECT * FROM employees WHERE salary > 70000;


-- 28️⃣ Partitioning Example
CREATE TABLE orders_2025 PARTITION OF orders
FOR VALUES FROM ('2025-01-01') TO ('2025-12-31');

-- 29️⃣ CTE Example

WITH department_avg AS ( 
    SELECT department_id,AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)

SELECT e.name, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg d 
ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;



-- 30️⃣ Correlated Subquery
SELECT name 
FROM employees AS e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees AS e2
    WHERE e1.department_id = e2.department_id
);