
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

--1.
SELECT DISTINCT CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
    AND YEAR(s2.SaleDate) = 2024
    AND MONTH(s2.SaleDate) = 3
)
ORDER BY CustomerName;
--2.
SELECT Product
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS SubQuery
);
--3.
SELECT MAX(Quantity * Price) AS SecondHighestSale
FROM #Sales
WHERE (Quantity * Price) < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);
--4.
SELECT 
    MONTH(SaleDate) AS SaleMonth,
    SUM(Quantity) AS TotalQuantity
FROM #Sales
WHERE SaleDate IN (
    SELECT SaleDate 
    FROM #Sales
)
GROUP BY MONTH(SaleDate)
ORDER BY SaleMonth;
--5.
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName != s1.CustomerName
    AND s2.Product = s1.Product
)
ORDER BY s1.CustomerName;
--6.
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

SELECT Name, Fruit, COUNT(*) AS FruitCount
FROM Fruits
GROUP BY Name, Fruit
ORDER BY Name, Fruit;
--7.
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

SELECT ParentId AS OlderPerson, ChildId AS YoungerPerson
FROM Family
ORDER BY ParentId;
--8.
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT CustomerID, OrderID, DeliveryState, Amount
FROM #Orders o1
WHERE DeliveryState = 'TX'
AND EXISTS (
    SELECT 1
    FROM #Orders o2
    WHERE o2.CustomerID = o1.CustomerID
    AND o2.DeliveryState = 'CA'
)
ORDER BY CustomerID, OrderID;
--9.
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

UPDATE #residents
SET fullname = (
    SELECT TRIM(SUBSTRING(address, CHARINDEX('name=', address) + 5, 
                         CHARINDEX(' ', address, CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5))
    FROM #residents r2
    WHERE r2.resid = #residents.resid
    AND address LIKE '%name=%'
)
WHERE fullname IS NULL OR fullname = '';
--10.
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

WITH Paths AS (
    -- Anchor: Start from Tashkent
    SELECT 
        RouteID,
        DepartureCity,
        ArrivalCity,
        Cost,
        CAST(CONCAT(DepartureCity, ' -> ', ArrivalCity) AS VARCHAR(MAX)) AS RoutePath,
        1 AS HopCount
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    -- Recursive: Join with next possible routes
    SELECT 
        r.RouteID,
        p.DepartureCity,
        r.ArrivalCity,
        p.Cost + r.Cost AS Cost,
        CAST(CONCAT(p.RoutePath, ' -> ', r.ArrivalCity) AS VARCHAR(MAX)) AS RoutePath,
        p.HopCount + 1 AS HopCount
    FROM Paths p
    INNER JOIN #Routes r ON p.ArrivalCity = r.DepartureCity
    WHERE p.ArrivalCity != 'Khorezm' -- Stop recursion when Khorezm is reached
)

SELECT 
    RoutePath,
    Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
AND Cost IN (
    (SELECT MIN(Cost) FROM Paths WHERE ArrivalCity = 'Khorezm'),
    (SELECT MAX(Cost) FROM Paths WHERE ArrivalCity = 'Khorezm')
)
ORDER BY Cost;
--11.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

SELECT 
    Vals,
    ID,
    RANK() OVER (ORDER BY ID) AS ProductRank
FROM #RankingPuzzle
WHERE Vals = 'Product';
--12.
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT 
    e.EmployeeName,
    e.Department,
    e.SalesAmount
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales e2
    WHERE e2.Department = e.Department
)
ORDER BY e.Department, e.EmployeeName;
--13.
SELECT DISTINCT e1.EmployeeName, e1.Department, e1.SalesAmount, e1.SalesMonth, e1.SalesYear
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.Department = e1.Department
    AND e2.SalesMonth = e1.SalesMonth
    AND e2.SalesYear = e1.SalesYear
    GROUP BY e2.Department, e2.SalesMonth, e2.SalesYear
    HAVING MAX(e2.SalesAmount) = e1.SalesAmount
)
ORDER BY e1.SalesYear, e1.SalesMonth, e1.Department, e1.EmployeeName;
--14.
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT DISTINCT e1.EmployeeName, e1.Department
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth, SalesYear
    FROM #EmployeeSales e2
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e3
        WHERE e3.EmployeeName = e1.EmployeeName
        AND e3.SalesMonth = e2.SalesMonth
        AND e3.SalesYear = e2.SalesYear)
   )
ORDER BY e1.EmployeeName;
--15.
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Name;
--16.
SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products)
ORDER BY Name;
--17.
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category 
    FROM Products 
    WHERE Name = 'Laptop'
)
ORDER BY Name;
--18.
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
)
ORDER BY Name;
--19.
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

SELECT p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Products p2
    WHERE p2.Category = p.Category
)
ORDER BY p.Category, p.Name;
--20.
SELECT DISTINCT p.Name
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID
ORDER BY p.Name;
--21.
SELECT p.Name
FROM Products p
INNER JOIN (
    SELECT ProductID, SUM(Quantity) AS TotalQuantity
    FROM Orders
    GROUP BY ProductID
    HAVING SUM(Quantity) > (
        SELECT AVG(TotalQty)
        FROM (
            SELECT SUM(Quantity) AS TotalQty
            FROM Orders
            GROUP BY ProductID
        ) AS AvgQuantities
    )
) o ON p.ProductID = o.ProductID
ORDER BY p.Name;
--22.
SELECT ProductID
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Orders);
--23.
SELECT ProductID, SUM(Quantity) AS TotalQuantity
FROM Orders
GROUP BY ProductID
ORDER BY TotalQuantity DESC
