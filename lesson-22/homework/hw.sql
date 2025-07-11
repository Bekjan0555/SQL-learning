--Text
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);
INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--1.
SELECT 
    sale_id,
    customer_id,
    customer_name,
    product_category,
    product_name,
    quantity_sold,
    unit_price,
    total_amount,
    order_date,
    region,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS RunningTotalSales
FROM sales_data
ORDER BY customer_name, order_date;
--2.
SELECT 
    product_category,
    COUNT(*) AS OrderCount
FROM sales_data
GROUP BY product_category
ORDER BY product_category;
-3.
SELECT 
    product_category,
    MAX(total_amount) AS MaxTotalAmount
FROM sales_data
GROUP BY product_category
ORDER BY product_category;
--4.
SELECT 
    product_category,
    MIN(unit_price) AS MinUnitPrice
FROM sales_data
GROUP BY product_category
ORDER BY product_category;
--5.
SELECT 
    s1.sale_id,
    s1.customer_id,
    s1.customer_name,
    s1.product_category,
    s1.product_name,
    s1.quantity_sold,
    s1.unit_price,
    s1.total_amount,
    s1.order_date,
    s1.region,
    (
        SELECT AVG(s2.total_amount)
        FROM sales_data s2
        WHERE s2.order_date BETWEEN DATEADD(DAY, -1, s1.order_date) AND DATEADD(DAY, 1, s1.order_date)
    ) AS MovingAverageSales
FROM sales_data s1
ORDER BY s1.order_date, s1.sale_id;
--6.
SELECT 
    region,
    SUM(total_amount) AS TotalSales
FROM sales_data
GROUP BY region
ORDER BY region;
--7.
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        customer_name,
        SUM(total_amount) AS TotalPurchaseAmount
    FROM sales_data
    GROUP BY customer_id, customer_name
)
SELECT 
    customer_id,
    customer_name,
    TotalPurchaseAmount,
    RANK() OVER (ORDER BY TotalPurchaseAmount DESC) AS PurchaseRank
FROM CustomerTotals
ORDER BY PurchaseRank, customer_name;
--8.
SELECT 
    sale_id,
    customer_id,
    customer_name,
    product_category,
    product_name,
    quantity_sold,
    unit_price,
    total_amount,
    order_date,
    region,
    total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS SaleAmountDifference
FROM sales_data
ORDER BY customer_name, order_date;
--9.
WITH RankedProducts AS (
    SELECT 
        product_category,
        product_name,
        unit_price,
        DENSE_RANK() OVER (
            PARTITION BY product_category 
            ORDER BY unit_price DESC
        ) AS PriceRank
    FROM sales_data
)
SELECT 
    product_category,
    product_name,
    unit_price,
    PriceRank
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY product_category, PriceRank, product_name;
--10.
SELECT 
    sale_id,
    customer_id,
    customer_name,
    product_category,
    product_name,
    quantity_sold,
    unit_price,
    total_amount,
    order_date,
    region,
    SUM(total_amount) OVER (
        PARTITION BY region 
        ORDER BY order_date
    ) AS CumulativeSales
FROM sales_data
ORDER BY region, order_date, sale_id;
--11.
SELECT 
    sale_id,
    customer_id,
    customer_name,
    product_category,
    product_name,
    quantity_sold,
    unit_price,
    total_amount,
    order_date,
    region,
    SUM(total_amount) OVER (
        PARTITION BY product_category 
        ORDER BY order_date
    ) AS CumulativeRevenue
FROM sales_data
ORDER BY product_category, order_date, sale_id;
--12.
SELECT 
    sale_id,
    customer_id,
    customer_name,
    product_category,
    product_name,
    quantity_sold,
    unit_price,
    total_amount,
    order_date,
    region,
    SUM(total_amount) OVER (ORDER BY sale_id) AS cumulative_total
FROM sales_data;
--13.
--Text
CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT 
    Value,
    SUM(Value) OVER (ORDER BY Value) AS CumulativeSum
FROM OneColumn;
--14
SELECT 
    customer_id,
    customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;
--15.
WITH RegionAverages AS (
    SELECT 
        region,
        AVG(total_amount) AS avg_region_spending
    FROM sales_data
    GROUP BY region
),
CustomerSpending AS (
    SELECT 
        s.customer_id,
        s.customer_name,
        s.region,
        SUM(s.total_amount) AS total_spending
    FROM sales_data s
    GROUP BY s.customer_id, s.customer_name, s.region
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    c.total_spending
FROM CustomerSpending c
INNER JOIN RegionAverages r ON c.region = r.region
WHERE c.total_spending > r.avg_region_spending
ORDER BY c.region, c.customer_name;
--16.
WITH CustomerSpending AS (
    SELECT 
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS total_spending
    FROM sales_data
    GROUP BY customer_id, customer_name, region
)
SELECT 
    customer_id,
    customer_name,
    region,
    total_spending,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spending DESC) AS spending_rank
FROM CustomerSpending
ORDER BY region, total_spending DESC;
--17.
SELECT 
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date;
--18.
WITH MonthlySales AS (
    SELECT 
        YEAR(order_date) AS sale_year,
        MONTH(order_date) AS sale_month,
        SUM(total_amount) AS total_sales
    FROM sales_data
    GROUP BY YEAR(order_date), MONTH(order_date)
),
GrowthCalculation AS (
    SELECT 
        sale_year,
        sale_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_year, sale_month) AS prev_month_sales
    FROM MonthlySales
)
SELECT 
    sale_year,
    sale_month,
    total_sales,
    ROUND(
        CASE 
            WHEN prev_month_sales IS NULL THEN NULL
            ELSE ((total_sales - prev_month_sales) / prev_month_sales) * 100
        END, 
        2
    ) AS growth_rate
FROM GrowthCalculation
ORDER BY sale_year, sale_month;
--19.
WITH CustomerTotal AS (
    SELECT 
        customer_id,
        customer_name,
        SUM(total_amount) AS total_spending
    FROM sales_data
    GROUP BY customer_id, customer_name
),
LastOrder AS (
    SELECT 
        customer_id,
        customer_name,
        total_amount AS last_order_amount
    FROM sales_data s
    WHERE order_date = (
        SELECT MAX(order_date)
        FROM sales_data s2
        WHERE s2.customer_id = s.customer_id
    )
)
SELECT 
    ct.customer_id,
    ct.customer_name,
    ct.total_spending,
    lo.last_order_amount
FROM CustomerTotal ct
INNER JOIN LastOrder lo ON ct.customer_id = lo.customer_id
WHERE ct.total_spending > lo.last_order_amount
ORDER BY ct.customer_id;
--20.
WITH AvgPrice AS (
    SELECT AVG(unit_price) AS avg_unit_price
    FROM sales_data
)
SELECT DISTINCT 
    product_name,
    unit_price
FROM sales_data
WHERE unit_price > (SELECT avg_unit_price FROM AvgPrice)
ORDER BY unit_price DESC;
--21.
--Text
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

SELECT 
    SUM(Val1 + Val2) OVER (PARTITION BY Grp) AS GroupSum,
    Id,
    Grp,
    Val1,
    Val2
FROM MyData;
--22.
--Text
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

SELECT 
    ID,
    SUM(Cost) AS TotalCost,
    SUM(DISTINCT Quantity) AS TotalQuantity
FROM TheSumPuzzle
GROUP BY ID;
--23.
--Text
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 
INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

WITH SortedSeats AS (
    SELECT SeatNumber, 
           ROW_NUMBER() OVER (ORDER BY SeatNumber) AS rn,
           SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS grp
    FROM Seats
),
Ranges AS (
    SELECT MIN(SeatNumber) AS StartSeat, 
           MAX(SeatNumber) AS EndSeat
    FROM SortedSeats
    GROUP BY grp
)
SELECT 
    CASE 
        WHEN StartSeat = EndSeat THEN CAST(StartSeat AS VARCHAR)
        ELSE CAST(StartSeat AS VARCHAR) + '-' + CAST(EndSeat AS VARCHAR)
    END AS SeatRange
FROM Ranges
ORDER BY StartSeat;
