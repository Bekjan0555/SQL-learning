--1.
SELECT ProductName AS Name
FROM Products;
--2.
SELECT *
FROM Customers AS Client;
--3.
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;
--4.
SELECT ProductName
FROM Products
INTERSECT
SELECT ProductName
FROM Products_Discounted;
--5.
SELECT DISTINCT FirstName, LastName, Country
FROM Customers;
--6.
SELECT ProductName, Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;
--7.
SELECT ProductName, StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS HighStock
FROM Products_Discounted;
--8.
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;
--9.
SELECT ProductName
FROM Products
EXCEPT
SELECT ProductName
FROM Products_Discounted;
--10.
SELECT ProductName, Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;
--11.
SELECT FirstName, LastName, Age, Salary
FROM Employees
WHERE Age < 25 OR Salary > 60000;
--12.
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentName = 'HR' OR EmployeeID = 5;
select *from Employees
--13.
SELECT SaleID, ProductID, CustomerID, SaleDate, SaleAmount,
       CASE 
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS SaleTier
FROM Sales;
--14.
SELECT CustomerID
FROM Orders
EXCEPT
SELECT CustomerID
FROM Sales;
--15.
SELECT CustomerID, Quantity,
       CASE 
           WHEN Quantity = 1 THEN 3
           WHEN Quantity BETWEEN 2 AND 3 THEN 5
           ELSE 7
       END AS DiscountPercentage
FROM Orders;
