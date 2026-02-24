SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

SELECT salary
FROM(
SELECT salary,
DENSE_RANK() OVER(ORDER BY salary DESC) AS rank
FROM employees
) AS t
WHERE rank = 2;