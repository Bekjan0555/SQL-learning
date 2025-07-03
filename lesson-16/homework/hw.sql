Easy Tasks
--1.
WITH NumberCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumberCTE
    WHERE Number < 1000
)
INSERT INTO Numbers (Number)
SELECT Number
FROM NumberCTE
OPTION (MAXRECURSION 1000); -- Required for SQL Server to allow 1000 iterations
SELECT * FROM Numbers;
--2.
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID;
--3.
WITH SalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary
FROM SalaryCTE;
--4.
SELECT 
    p.ProductID,
    p.ProductName,
    dt.MaxSalesAmount
FROM Products p
JOIN (
    SELECT 
        ProductID,
        MAX(SalesAmount) AS MaxSalesAmount
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID;
--5.
CREATE TABLE DoubledNumbers (
    Number BIGINT
);

WITH DoubledCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2
    FROM DoubledCTE
    WHERE Number * 2 < 1000000
)
INSERT INTO DoubledNumbers (Number)
SELECT Number
FROM DoubledCTE;
--6.
WITH SalesCountCTE AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    cte.SalesCount
FROM Employees e
JOIN SalesCountCTE cte ON e.EmployeeID = cte.EmployeeID;
--7.
WITH HighSalesCTE AS (
    SELECT 
        ProductID,
        SalesAmount
    FROM Sales
    WHERE SalesAmount > 500
)
SELECT 
    p.ProductID,
    p.ProductName,
    h.SalesAmount
FROM Products p
JOIN HighSalesCTE h ON p.ProductID = h.ProductID
ORDER BY p.ProductID, h.SalesAmount;
--8.
WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary
FROM Employees e
CROSS JOIN AvgSalaryCTE a
WHERE e.Salary > a.AvgSalary
ORDER BY e.Salary;

Medium Tasks
--1.
SELECT TOP 5
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.SalesCount
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.SalesCount DESC, e.EmployeeID;
--2.
SELECT 
    p.CategoryID,
    SUM(dt.TotalSales) AS TotalSales
FROM Products p
JOIN (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) dt ON p.ProductID = dt.ProductID
GROUP BY p.CategoryID
ORDER BY p.CategoryID;
--3.
WITH FactorialCTE AS (
    SELECT 
        Number,
        1 AS n,
        CAST(1 AS BIGINT) AS Factorial
    FROM Numbers1
    WHERE Number >= 0
    UNION ALL
    SELECT 
        cte.Number,
        cte.n + 1,
        cte.Factorial * (cte.n + 1)
    FROM FactorialCTE cte
    WHERE cte.n < cte.Number
)
SELECT 
    Number,
    MAX(Factorial) AS Factorial
FROM FactorialCTE
GROUP BY Number
ORDER BY Number;
--4.
WITH SplitStringCTE AS (
    -- Anchor: First character of each string
    SELECT 
        Id,
        String,
        SUBSTRING(String, 1, 1) AS Character,
        1 AS Position,
        LEN(String) AS StringLength
    FROM Example
    WHERE String IS NOT NULL AND LEN(String) > 0
    UNION ALL
    -- Recursive: Next character
    SELECT 
        cte.Id,
        cte.String,
        SUBSTRING(cte.String, cte.Position + 1, 1) AS Character,
        cte.Position + 1,
        cte.StringLength
    FROM SplitStringCTE cte
    WHERE cte.Position < cte.StringLength
)
SELECT 
    Id,
    Character,
    Position
FROM SplitStringCTE
ORDER BY Id, Position;
--5.
WITH MonthlySalesCTE AS (
    SELECT 
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesDiffCTE AS (
    SELECT 
        SaleYear,
        SaleMonth,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY SaleYear, SaleMonth) AS PreviousMonthSales,
        TotalSales - LAG(TotalSales) OVER (ORDER BY SaleYear, SaleMonth) AS SalesDifference
    FROM MonthlySalesCTE
)
SELECT 
    SaleYear,
    SaleMonth,
    TotalSales,
    PreviousMonthSales,
    SalesDifference
FROM SalesDiffCTE
WHERE PreviousMonthSales IS NOT NULL
ORDER BY SaleYear, SaleMonth;
--6.
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.SaleYear,
    dt.SaleQuarter,
    dt.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        YEAR(SaleDate) AS SaleYear,
        DATEPART(QUARTER, SaleDate) AS SaleQuarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate), DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) dt ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.SaleYear, dt.SaleQuarter, e.EmployeeID;

Difficult Tasks
--1.
-- Drop the table if it exists to avoid conflicts
IF OBJECT_ID('FibonacciNumbers', 'U') IS NOT NULL
    DROP TABLE FibonacciNumbers;
-- Create the FibonacciNumbers table
CREATE TABLE FibonacciNumbers (
    Position INT,
    Fibonacci BIGINT);
-- Populate with Fibonacci numbers using recursive CTE
WITH FibonacciCTE AS (
    -- Anchor: First two Fibonacci numbers
    SELECT 0 AS Position, CAST(0 AS BIGINT) AS Fibonacci
    UNION ALL
    SELECT 1 AS Position, CAST(1 AS BIGINT) AS Fibonacci
    UNION ALL
    -- Recursive: Next Fibonacci number
    SELECT 
        f.Position + 1,
        f.Fibonacci + LAG(f.Fibonacci) OVER (ORDER BY f.Position)
    FROM FibonacciCTE f
    WHERE f.Position < 45 -- Limits to Fibonacci < 1,000,000
)
INSERT INTO FibonacciNumbers (Position, Fibonacci)
SELECT Position, Fibonacci
FROM FibonacciCTE
WHERE Fibonacci < 1000000
OPTION (MAXRECURSION 100);
-- Select to verify
SELECT Position, Fibonacci
FROM FibonacciNumbers
ORDER BY Position;
--2.
SELECT 
    Id,
    Vals
FROM FindSameCharacters
WHERE 
    Vals IS NOT NULL
    AND LEN(Vals) > 1
    AND Vals = REPLICATE(LEFT(Vals, 1), LEN(Vals));
--3.
-- Create table to store the sequence
CREATE TABLE SequenceNumbers (
    Position INT,
    Sequence VARCHAR(100)
);
-- Generate sequence for n=5 (1, 12, 123, 1234, 12345)
WITH SequenceCTE AS (
    -- Anchor: Start with '1' at Position 1
    SELECT 
        1 AS Position,
        CAST('1' AS VARCHAR(100)) AS Sequence
    UNION ALL
    -- Recursive: Append the next number to the previous sequence
    SELECT 
        cte.Position + 1,
        CAST(cte.Sequence + CAST(cte.Position + 1 AS VARCHAR(100)) AS VARCHAR(100))
    FROM SequenceCTE cte
    WHERE cte.Position < 5 -- Set n=5
)
-- Insert into SequenceNumbers table
INSERT INTO SequenceNumbers (Position, Sequence)
SELECT Position, Sequence
FROM SequenceCTE;
-- Select to verify
SELECT Position, Sequence
FROM SequenceNumbers
ORDER BY Position;
--4.
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.SalesCount
FROM 
    Employees e
INNER JOIN (
    SELECT 
        EmployeeID,
        COUNT(*) as SalesCount
    FROM 
        Sales
    WHERE 
        SaleDate >= DATEADD(MONTH, -6, '2025-07-03')
        AND SaleDate <= '2025-07-03'
    GROUP BY 
        EmployeeID
) s ON e.EmployeeID = s.EmployeeID
WHERE 
    s.SalesCount = (
        SELECT 
            MAX(SalesCount)
        FROM (
            SELECT 
                COUNT(*) as SalesCount
            FROM 
                Sales
            WHERE 
                SaleDate >= DATEADD(MONTH, -6, '2025-07-03')
                AND SaleDate <= '2025-07-03'
            GROUP BY 
                EmployeeID
        ) max_sales
    )
ORDER BY 
    e.EmployeeID;
--5.
SELECT 
    PawanName,
    Pawan_slug_name,
    CASE 
        WHEN Pawan_slug_name IS NULL THEN NULL
        ELSE 
            LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name)) + 
            dbo.RemoveDuplicatesAndSingles(
                SUBSTRING(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name) + 1, LEN(Pawan_slug_name))
            )
    END AS Cleaned_slug_name
FROM 
    RemoveDuplicateIntsFromNames;
GO
