--1.
SELECT MIN(Price)
FROM Products;
--2.
SELECT MAX(Salary)
FROM Employees;
--3.
SELECT COUNT(*) 
FROM Customers;
--4.
SELECT COUNT(DISTINCT Category)
FROM Products;
--5.
SELECT SUM(SaleAmount)
FROM Sales
WHERE ProductID = 7;
--6.
SELECT AVG(Age)
FROM Employees;
--7.
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;
--8.
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;
--9.
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;
--10.
SELECT DepartmentName
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;
--11.
SELECT p.Category, SUM(s.SaleAmount) AS TotalSales, AVG(s.SaleAmount) AS AverageSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.Category;
--12.
SELECT COUNT(*) AS EmployeeCount
FROM Employees
WHERE DepartmentName = 'HR';
--13.
SELECT DepartmentName, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;
--14.
SELECT DepartmentName, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName;
--15.
SELECT DepartmentName, AVG(Salary) AS AverageSalary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;
--16.
SELECT Category, AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;
--17.
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);
--18.
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;
--19.
SELECT 
    DepartmentName,
    AVG(Salary) as AvgSalary,
    COUNT(*) as EmployeeCount
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000
ORDER BY AVG(Salary) DESC;
--20
SELECT 
    Category,
    AVG(Price) as AvgPrice,
    COUNT(*) as ProductCount,
    MIN(Price) as MinPrice,
    MAX(Price) as MaxPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150
ORDER BY AVG(Price) DESC;
--21.
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Country,
    SUM(o.TotalAmount) as TotalSales,
    COUNT(o.OrderID) as OrderCount,
    AVG(o.TotalAmount) as AvgOrderValue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email, c.Country
HAVING SUM(o.TotalAmount) > 1500
ORDER BY SUM(o.TotalAmount) DESC;
--22.
SELECT 
    DepartmentName,
    COUNT(*) as EmployeeCount,
    SUM(Salary) as TotalSalary,
    AVG(Salary) as AvgSalary,
    MIN(Salary) as MinSalary,
    MAX(Salary) as MaxSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000
ORDER BY AVG(Salary) DESC;
--23.
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName as CustomerName,
    c.Country,
    COUNT(o.OrderID) as OrderCount,
    SUM(o.TotalAmount) as TotalOrderValue,
    AVG(o.TotalAmount) as AvgOrderValue,
    MIN(o.TotalAmount) as MinOrderValue,
    MAX(o.TotalAmount) as MaxOrderValue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 50
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY SUM(o.TotalAmount) DESC;
--24.
SELECT 
    YEAR(o.OrderDate) as SalesYear,
    MONTH(o.OrderDate) as SalesMonth,
    DATENAME(MONTH, o.OrderDate) as MonthName,
    COUNT(DISTINCT o.ProductID) as UniqueProductsSold,
    COUNT(o.OrderID) as TotalOrders,
    SUM(o.TotalAmount) as TotalSales,
    AVG(o.TotalAmount) as AvgOrderValue,
    SUM(o.Quantity) as TotalQuantity
FROM Orders o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), DATENAME(MONTH, o.OrderDate)
HAVING COUNT(DISTINCT o.ProductID) >= 2
ORDER BY SalesYear DESC, SalesMonth DESC;
--25.
SELECT 
    YEAR(OrderDate) as OrderYear,
    COUNT(OrderID) as TotalOrders,
    MIN(Quantity) as MinOrderQuantity,
    MAX(Quantity) as MaxOrderQuantity,
    MIN(TotalAmount) as MinOrderAmount,
    MAX(TotalAmount) as MaxOrderAmount,
    AVG(Quantity) as AvgQuantity,
    AVG(TotalAmount) as AvgOrderAmount,
    SUM(Quantity) as TotalQuantityPerYear,
    SUM(TotalAmount) as TotalSalesPerYear
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear DESC;
