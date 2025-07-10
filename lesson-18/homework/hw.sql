--1.
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

-- Create temporary table
CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(12,2)
);

-- Insert data for current month (July 2025)
INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
WHERE 
    YEAR(s.SaleDate) = 2025 
    AND MONTH(s.SaleDate) = 7
GROUP BY 
    s.ProductID;

-- Return results
SELECT 
    ProductID,
    TotalQuantity,
    TotalRevenue
FROM 
    #MonthlySales
ORDER BY 
    ProductID;
--2.
CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    COALESCE(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM 
    Products p
LEFT JOIN 
    Sales s ON p.ProductID = s.ProductID
GROUP BY 
    p.ProductID, p.ProductName, p.Category;
--3.
CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(12,2);
    
    SELECT @TotalRevenue = COALESCE(SUM(s.Quantity * p.Price), 0)
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID;
    
    RETURN @TotalRevenue;
END;
--4.
CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS @Result TABLE (
    ProductName VARCHAR(100),
    TotalQuantity INT,
    TotalRevenue DECIMAL(12,2)
)
AS
BEGIN
    INSERT INTO @Result (ProductName, TotalQuantity, TotalRevenue)
    SELECT 
        p.ProductName,
        COALESCE(SUM(s.Quantity), 0) AS TotalQuantity,
        COALESCE(SUM(s.Quantity * p.Price), 0) AS TotalRevenue
    FROM 
        Products p
    LEFT JOIN 
        Sales s ON p.ProductID = s.ProductID
    WHERE 
        p.Category = @Category
    GROUP BY 
        p.ProductName;
    
    RETURN;
END;
--5.
CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @IsPrime BIT = 1;
    DECLARE @Divisor INT = 2;

    IF @Number <= 1
        SET @IsPrime = 0;
    ELSE
        WHILE @Divisor <= SQRT(@Number)
        BEGIN
            IF @Number % @Divisor = 0
            BEGIN
                SET @IsPrime = 0;
                BREAK;
            END
            SET @Divisor = @Divisor + 1;
        END Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

    RETURN CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;
END;
--6.
CREATE FUNCTION fn_GetNumbersBetween
(
    @StartNum INT,
    @EndNum INT
)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    -- Ensure start number is less than or equal to end number
    DECLARE @MinNum INT = CASE WHEN @StartNum <= @EndNum THEN @StartNum ELSE @EndNum END;
    DECLARE @MaxNum INT = CASE WHEN @StartNum <= @EndNum THEN @EndNum ELSE @StartNum END;
    
    -- Insert numbers into the return table
    WITH NumberSequence AS
    (
        SELECT @MinNum AS Number
        UNION ALL
        SELECT Number + 1
        FROM NumberSequence
        WHERE Number < @MaxNum
    )
    INSERT INTO @Numbers (Number)
    SELECT Number
    FROM NumberSequence;
    
    RETURN;
END;
--7.
CREATE FUNCTION fn_GetNthHighestSalary
(
    @N INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = Salary
    FROM (
        SELECT DISTINCT Salary,
               DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM Employee
    ) RankedSalaries
    WHERE SalaryRank = @N;

    RETURN @Result;
END;
--8.
CREATE TABLE FriendRequests (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);
-- Sample data
INSERT INTO FriendRequests (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');
select * from FriendRequests
--9.
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);
-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');
-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

CREATE VIEW CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city;
--10.
SELECT 
    n.Number AS order_id,
    CASE WHEN o.order_id IS NULL THEN 'Missing' ELSE 'Present' END AS status
FROM dbo.fn_GetNumbersBetween(
    (SELECT MIN(order_id) FROM Orders),
    (SELECT MAX(order_id) FROM Orders)
) n
LEFT JOIN Orders o ON n.Number = o.order_id
ORDER BY n.Number;
