--1.
--Text
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);
INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT 
    id,
    name,
    salary
FROM 
    employees
WHERE 
    salary = (SELECT MIN(salary) FROM employees);
--2.
--Text
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);
INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

SELECT 
    id,
    product_name,
    price
FROM 
    products
WHERE 
    price > (SELECT AVG(price) FROM products);
--3.
--Text
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

SELECT 
    e.id,
    e.name,
    e.department_id
FROM 
    employees e
    INNER JOIN departments d ON e.department_id = d.id
WHERE 
    d.department_name = 'Sales';
-4.
--Text
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

SELECT 
    c.customer_id,
    c.name
FROM 
    customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL;
--5.
--Text
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);
INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

SELECT id, product_name, price, category_id
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);
--6.
--Text
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');
INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

WITH MaxPrice AS (
    SELECT category_id, MAX(price) AS max_price
    FROM products
    GROUP BY category_id
)
SELECT p.id, p.product_name, p.price, p.category_id
FROM products p
INNER JOIN MaxPrice mp
    ON p.category_id = mp.category_id AND p.price = mp.max_price;
--7.
--Text
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);
INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

WITH AvgSalary AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
INNER JOIN AvgSalary a
    ON e.department_id = a.department_id
WHERE e.salary > a.avg_salary;
--8.
--Text
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');
INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

WITH MaxGrade AS (
    SELECT course_id, MAX(grade) AS max_grade
    FROM grades
    GROUP BY course_id
)
SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
INNER JOIN grades g ON s.student_id = g.student_id
INNER JOIN MaxGrade m ON g.course_id = m.course_id AND g.grade = m.max_grade;
--9.
--Text
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);
INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

WITH RankedProducts AS (
    SELECT id, product_name, price, category_id,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
    FROM products
)
SELECT id, product_name, price, category_id
FROM RankedProducts
WHERE price_rank = 3;
--10.
--Text
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);
INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

WITH CompanyAvg AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
),
DeptMax AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
CROSS JOIN CompanyAvg ca
INNER JOIN DeptMax dm ON e.department_id = dm.department_id
WHERE e.salary > ca.avg_salary AND e.salary < dm.max_salary;
