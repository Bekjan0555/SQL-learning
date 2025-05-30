create database homework4
Use homework4
--1.
SELECT TOP 5 EmployeeID, FirstName, LastName, DepartmentName, Salary, HireDate, Age, Email, Country
FROM Employees
ORDER BY Salary DESC;

--2.
SELECT DISTINCT Category
FROM Products;
--3.
SELECT *
FROM Products
WHERE Price > 100;

--4.
SELECT *
FROM Customers
WHERE FirstName LIKE 'A%';
--5.
SELECT *
FROM Products
ORDER BY Price ASC;
--6.
SELECT *
FROM Employees
WHERE Salary >= 60000 AND DepartmentName = 'HR';
--7.
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    DepartmentName,
    Salary,
    HireDate,
    Age,
    ISNULL(Email, 'noemail@example.com') AS Email,
    Country
FROM Employees;
--8.
SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;
--9.
SELECT DISTINCT Category, ProductName
FROM Products;
--10
SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;
--11.
SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;
--12.
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    DepartmentName,
    Salary,
    HireDate,
    Age,
    Email,
    Country,
    COALESCE(FirstName, LastName) AS Name
FROM Employees;
--13.
SELECT DISTINCT Category, Price
FROM Products;
--14.
SELECT *
FROM Employees
WHERE Age BETWEEN 30 AND 40 OR DepartmentName = 'Marketing';
--15.
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
--16.
SELECT *
FROM Products
WHERE Price <= 1000 AND StockQuantity > 50
ORDER BY StockQuantity ASC;
--17.
SELECT *
FROM Products
WHERE ProductName LIKE '%e%';
--18.
SELECT employee_id, name
FROM employees
WHERE DepartmentName IN (
    SELECT department_id
    FROM Departments
    WHERE department_name IN ('HR', 'IT', 'Finance')
);
--19.
SELECT CustomerID, FirstName, LastName, Email, City, PostalCode
FROM Customers
ORDER BY City ASC, PostalCode DESC;
--20.
SELECT TOP(5) 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity * od.CustomerID) AS SalesAmount
FROM Products p
INNER JOIN Orders od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY SalesAmount DESC;
--21.
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    Email,
    HireDate
FROM Employees;
--22.
SELECT DISTINCT 
    c.CategoryName,
    p.ProductName,
    p.Price
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Price > 50
ORDER BY c.CategoryName, p.ProductName;
--23.
SELECT *
FROM Products
WHERE Price < (0.1 * (SELECT AVG(Price) FROM Products));
--24.
SELECT * FROM Employees
WHERE Age > 30
  AND DepartmentName IN ('HR', 'IT');
--25.
SELECT Email FROM Customers
WHERE Email LIKE '%@gmail.com';
--26.
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > ALL (
    SELECT Salary
    FROM Employees
    WHERE DepartmentName = 'Sales'
);
--27.
SELECT *
FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, GETDATE()) AND GETDATE();
