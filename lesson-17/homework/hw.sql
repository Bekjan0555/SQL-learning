create database homework17 
use homework17

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

SELECT 
    r.Region,
    d.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM 
    (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN 
    (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN 
    #RegionSales rs ON r.Region = rs.Region AND d.Distributor = rs.Distributor
ORDER BY 
    r.Region, d.Distributor;

--2.
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT 
    e2.name
FROM 
    Employee e1
JOIN 
    Employee e2 ON e1.managerId = e2.id
GROUP BY 
    e1.managerId, e2.name
HAVING 
    COUNT(*) >= 5;
--3.
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM 
    Orders o
JOIN 
    Products p ON o.product_id = p.product_id
WHERE 
    YEAR(o.order_date) = 2020 
    AND MONTH(o.order_date) = 2
GROUP BY 
    p.product_id, p.product_name
HAVING 
    SUM(o.unit) >= 100;
--4.
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

WITH VendorCounts AS (
    SELECT 
        CustomerID,
        Vendor,
        COUNT(*) AS order_count,
        RANK() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC, Vendor ASC) AS rnk
    FROM 
        Orders
    GROUP BY 
        CustomerID, Vendor
)
SELECT 
    CustomerID,
    Vendor
FROM 
    VendorCounts
WHERE 
    rnk = 1;
--5.
DECLARE @Check_Prime INT = 91;
DECLARE @IsPrime BIT = 1;
DECLARE @Divisor INT = 2;

IF @Check_Prime <= 1
    SET @IsPrime = 0;
ELSE
    WHILE @Divisor <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @Divisor = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @Divisor = @Divisor + 1;
    END

SELECT 
    CASE 
        WHEN @IsPrime = 1 THEN 'This number is prime'
        ELSE 'This number is not prime'
    END AS Result;
--6.
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

WITH SignalCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signal_count,
        RANK() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC, Locations ASC) AS rnk
    FROM 
        Device
    GROUP BY 
        Device_id, Locations
)
SELECT 
    d.Device_id,
    COUNT(DISTINCT d.Locations) AS number_of_locations,
    MAX(CASE WHEN sc.rnk = 1 THEN sc.Locations END) AS most_signals_location,
    COUNT(*) AS total_signals
FROM 
    Device d
LEFT JOIN 
    SignalCounts sc ON d.Device_id = sc.Device_id
GROUP BY 
    d.Device_id;
--7.
drop table Employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

WITH DeptAvgSalary AS (
    SELECT 
        DeptID,
        AVG(Salary) AS avg_salary
    FROM 
        Employee
    GROUP BY 
        DeptID
)
SELECT 
    e.EmpID,
    e.EmpName,
    e.Salary
FROM 
    Employee e
JOIN 
    DeptAvgSalary d ON e.DeptID = d.DeptID
WHERE 
    e.Salary > d.avg_salary
ORDER BY 
    e.EmpID;
--8.
WITH Matches AS (
    SELECT 
        t.TicketID,
        (
            (t.Num1 IN (w.Num1, w.Num2, w.Num3, w.Num4, w.Num5)) +
            (t.Num2 IN (w.Num1, w.Num2, w.Num3, w.Num4, w.Num5)) +
            (t.Num3 IN (w.Num1, w.Num2, w.Num3, w.Num4, w.Num5)) +
            (t.Num4 IN (w.Num1, w.Num2, w.Num3, w.Num4, w.Num5)) +
            (t.Num5 IN (w.Num1, w.Num2, w.Num3, w.Num4, w.Num5))
        ) AS MainMatches,
        (t.BonusNum = w.BonusNum) AS BonusMatch
    FROM 
        Tickets t
    CROSS JOIN 
        WinningNumbers w
    WHERE 
        w.DrawDate = '2025-07-06'
)
SELECT 
    SUM(
        CASE 
            WHEN MainMatches = 5 AND BonusMatch = 1 THEN 100
            WHEN MainMatches BETWEEN 1 AND 4 OR (MainMatches = 5 AND BonusMatch = 0) THEN 10
            ELSE 0
        END
    ) AS TotalWinnings
FROM 
    Matches;






-- Create and populate WinningNumbers table
DROP TABLE IF EXISTS WinningNumbers;
CREATE TABLE WinningNumbers (
    DrawDate DATE,
    Num1 INT,
    Num2 INT,
    Num3 INT
);
INSERT INTO WinningNumbers (DrawDate, Num1, Num2, Num3)
VALUES ('2025-07-06', 25, 45, 78);

-- Create and populate sample Tickets table
DROP TABLE IF EXISTS Tickets;
CREATE TABLE Tickets (
    TicketID INT,
    Num1 INT,
    Num2 INT,
    Num3 INT
);
INSERT INTO Tickets (TicketID, Num1, Num2, Num3)
VALUES 
    (1, 25, 45, 78),  -- Matches all 3
    (2, 25, 45, 10),  -- Matches 2
    (3, 25, 12, 13),  -- Matches 1
    (4, 11, 12, 13);  -- Matches 0

-- Query to calculate total winnings
WITH Matches AS (
    SELECT 
        t.TicketID,
        (   CAST((t.Num1 = w.Num1 OR t.Num1 = w.Num2 OR t.Num1 = w.Num3) AS INT) +
            CAST((t.Num2 = w.Num1 OR t.Num2 = w.Num2 OR t.Num2 = w.Num3) AS INT) +
            CAST((t.Num3 = w.Num1 OR t.Num3 = w.Num2 OR t.Num3 = w.Num3) AS INT)
        ) AS MatchCount
    FROM 
        Tickets t
    CROSS JOIN 
        WinningNumbers w
    WHERE 
        w.DrawDate = '2025-07-06'
)
SELECT 
    COALESCE(SUM(
        CASE 
            WHEN MatchCount = 3 THEN 100
            WHEN MatchCount IN (1, 2) THEN 10
            ELSE 0
        END
    ), 0) AS TotalWinnings
FROM 
    Matches;
--9.
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped (
    Product VARCHAR(100) PRIMARY KEY,
    Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
    ('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

-- Degroup query
WITH Numbers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
    WHERE object_id <= (SELECT MAX(Quantity) FROM Grouped)
)
SELECT g.Product
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product;
