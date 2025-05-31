--1.
SELECT 
    o.OrderID,
    c.CustomerID,
    o.OrderDate
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderDate > '2022-12-31';
--2.
SELECT 
    E.EmployeeID, 
    D.DepartmentName
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('Sales', 'Marketing');
--3.
SELECT 
    d.DepartmentName, 
    MAX(e.Salary) AS MaxSalary
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY 
    d.DepartmentName;
--4.
SELECT 
    Customers.CustomerID, 
    Orders.OrderID, 
    Orders.OrderDate
FROM 
    Customers
JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
WHERE 
    Customers.Country = 'USA' 
    AND YEAR(Orders.OrderDate) = 2023;
--5.
SELECT 
    Customers.CustomerID, 
    COUNT(Orders.OrderID) AS TotalOrders
FROM 
    Customers
JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY 
    Customers.CustomerID;
--6.
SELECT 
    p.ProductName, 
    s.SupplierName
FROM 
    Products p
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
WHERE 
    s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');
--7.
SELECT 
    c.CustomerID, 
    MAX(o.OrderDate) AS MostRecentOrderDate
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID;
--8.
SELECT 
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS CustomerName,
    Orders.TotalAmount AS OrderTotal
FROM 
    Customers
    JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE 
    Orders.TotalAmount > 500;
--9.
SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;
--10.
SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;
--11.
SELECT e.DepartmentID, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR'
  AND e.Salary > 60000;
--12.
SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2023
  AND p.StockQuantity > 100;
--13.
SELECT e.EmployeeID, d.DepartmentName, e.HireDate
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales'
   OR e.HireDate > '2020-12-31';
--14.
  SELECT c.CustomerID, o.OrderID, c.Address, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
  AND LEFT(c.Address, 4) BETWEEN '0000' AND '9999';
  --15.
SELECT p.ProductName, p.Category, s.SaleAmount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
WHERE p.Category = 3 OR s.SaleAmount > 350;

SELECT p.ProductName, c.CategoryName, s.SaleAmount
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName = 'Electronics' OR s.SaleAmount > 350;
--16.
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON p.ProductID = c.CategoryID
GROUP BY c.CategoryName;
--17.
SELECT 
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS CustomerName,
    Customers.City,
    Orders.OrderID,
    Orders.TotalAmount AS Amount
FROM 
    Customers
    JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE 
    Customers.City = 'Los Angeles'
    AND Orders.TotalAmount > 300;
--18.
	SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM 
    Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentName IN ('Human Resources', 'Finance')
    OR (
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'a', ''))) 
        + (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'e', ''))) 
        + (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'i', ''))) 
        + (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'o', ''))) 
        + (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'u', ''))) >= 4
    );
--19.
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName,
    e.Salary
FROM 
    Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentName IN ('
