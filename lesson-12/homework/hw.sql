
--1.
Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM 
    Person p
LEFT JOIN 
    Address a ON p.personId = a.personId;

--2.
Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

SELECT 
    e1.name AS Employee
FROM 
    Employee e1
JOIN 
    Employee e2 ON e1.managerId = e2.id
WHERE 
    e1.salary > e2.salary;

--3.
-- Drop the table if it exists to ensure a clean state
IF OBJECT_ID('Person', 'U') IS NOT NULL
    DROP TABLE Person;

-- Create the Person table
CREATE TABLE Person (
    id INT PRIMARY KEY,
    email VARCHAR(255));

-- Insert the sample data
INSERT INTO Person (id, email) VALUES 
    (1, 'a@b.com'),
    (2, 'c@d.com'),
    (3, 'a@b.com');

-- Query to find duplicate emails
SELECT 
    email AS Email
FROM 
    Person
GROUP BY 
    email
HAVING 
    COUNT(email) > 1;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Person';

--4.
DELETE p1
FROM Person p1
INNER JOIN Person p2
ON p1.email = p2.email
WHERE p1.id > p2.id;

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email);

-- Drop the table if it exists to ensure a clean state
IF OBJECT_ID('Person', 'U') IS NOT NULL
    DROP TABLE Person;

-- Create the Person table
CREATE TABLE Person (
    id INT PRIMARY KEY,
    email VARCHAR(255));

-- Delete duplicate emails, keeping the smallest id
DELETE p1
FROM Person p1
INNER JOIN Person p2
ON p1.email = p2.email
WHERE p1.id > p2.id;

-- Show the resulting table
SELECT * FROM Person;

--5.
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100));

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100));

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  

INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

SELECT DISTINCT g.ParentName
FROM girls g
LEFT JOIN boys b ON g.ParentName = b.ParentName
WHERE b.ParentName IS NULL;

SELECT DISTINCT ParentName
FROM girls
WHERE ParentName NOT IN (SELECT ParentName FROM boys);

-- Drop tables if they exist
IF OBJECT_ID('boys', 'U') IS NOT NULL DROP TABLE boys;
IF OBJECT_ID('girls', 'U') IS NOT NULL DROP TABLE girls;

-- Create tables
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

-- Insert data
INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  

INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

-- Query to find parents with only girls
SELECT DISTINCT g.ParentName
FROM girls g
LEFT JOIN boys b ON g.ParentName = b.ParentName
WHERE b.ParentName IS NULL;

--6.
-- Ensure the correct database context
USE TSQL2012;
GO

-- Verify the table exists
IF OBJECT_ID('Sales.Orders', 'U') IS NULL
BEGIN
    RAISERROR ('The table Sales.Orders does not exist in the TSQL2012 database. Please ensure the database is properly installed.', 16, 1);
    RETURN;
END;

-- Query to find total sales amount and least weight for orders with freight > 50
SELECT 
    o.custid,
    SUM(o.freight) AS TotalSalesAmount,
    MIN(o.freight) AS LeastWeight
FROM 
    Sales.Orders o
WHERE 
    o.freight > 50
GROUP BY 
    o.custid
HAVING 
    COUNT(*) > 0
ORDER BY 
    o.custid;

--8.
CREATE TABLE Cart1 (Item VARCHAR(100) PRIMARY KEY);
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cart1';
--9.
-- Drop tables if they exist to avoid conflicts
IF OBJECT_ID('Examinations', 'U') IS NOT NULL DROP TABLE Examinations;
IF OBJECT_ID('Subjects', 'U') IS NOT NULL DROP TABLE Subjects;
IF OBJECT_ID('Students', 'U') IS NOT NULL DROP TABLE Students;
GO

-- Create tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE Subjects (
    subject_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(50)
);

-- Insert data
INSERT INTO Students (student_id, student_name) VALUES
(1, 'Alice'), (2, 'Bob'), (13, 'John'), (6, 'Alex');

INSERT INTO Subjects (subject_name) VALUES
('Math'), ('Physics'), ('Programming');

INSERT INTO Examinations (student_id, subject_name) VALUES
(1, 'Math'), (1, 'Physics'), (1, 'Programming'),
(2, 'Programming'), (1, 'Physics'), (1, 'Math'),
(13, 'Math'), (13, 'Programming'), (13, 'Physics'),
(2, 'Math'), (1, 'Math');

-- Verify tables exist
IF OBJECT_ID('Students', 'U') IS NULL OR OBJECT_ID('Subjects', 'U') IS NULL OR OBJECT_ID('Examinations', 'U') IS NULL
BEGIN
    RAISERROR ('One or more tables (Students, Subjects, Examinations) do not exist. Please ensure the tables are created.', 16, 1);
    RETURN;
END;

-- Query to find exam attendance
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.student_id) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN 
    Examinations e ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY 
    s.student_id, s.student_name, sub.subject_name
ORDER BY 
    s.student_id, sub.subject_name;



