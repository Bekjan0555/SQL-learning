Easy Tasks
--1.
SELECT 
    Id,
    LTRIM(RTRIM(LEFT(Name, CHARINDEX(',', Name) - 1))) AS Name,
    LTRIM(RTRIM(SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)))) AS Surname
FROM 
    TestMultipleColumns;
--2.
SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';
--3.
SELECT 
    Id,
    PARSENAME(REPLACE(Vals, '.', '.'), 4) AS Part1,
    PARSENAME(REPLACE(Vals, '.', '.'), 3) AS Part2,
    PARSENAME(REPLACE(Vals, '.', '.'), 2) AS Part3,
    PARSENAME(REPLACE(Vals, '.', '.'), 1) AS Part4
FROM Splitter;
--4.
SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') AS ReplacedString;
--5.
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;
--6.
SELECT texts, 
       LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces
--7.
SELECT 
    e1.EMPLOYEE_ID,
    e1.FIRST_NAME AS Employee_First_Name,
    e1.LAST_NAME AS Employee_Last_Name,
    e1.SALARY AS Employee_Salary,
    e2.FIRST_NAME AS Manager_First_Name,
    e2.LAST_NAME AS Manager_Last_Name,
    e2.SALARY AS Manager_Salary
FROM 
    Employees e1
    INNER JOIN Employees e2 ON e1.MANAGER_ID = e2.EMPLOYEE_ID
WHERE 
    e1.SALARY > e2.SALARY;
--8.
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) AS Years_of_Service
FROM 
    Employees
WHERE 
    FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) > 10
    AND FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) < 15
ORDER BY 
    Years_of_Service, EMPLOYEE_ID;

Medium Tasks
--1.
SELECT 
    (SELECT STRING_AGG(SUBSTRING(str, n, 1), '')
     FROM (SELECT 'rtcfvty34redt' AS str) AS input
     CROSS APPLY (SELECT TOP(LEN(str)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n 
                  FROM master..spt_values) AS numbers
     WHERE PATINDEX('%[0-9]%', SUBSTRING(str, n, 1)) > 0) AS Integer_Values,
    (SELECT STRING_AGG(SUBSTRING(str, n, 1), '')
     FROM (SELECT 'rtcfvty34redt' AS str) AS input
     CROSS APPLY (SELECT TOP(LEN(str)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n 
                  FROM master..spt_values) AS numbers
     WHERE PATINDEX('%[a-zA-Z]%', SUBSTRING(str, n, 1)) > 0) AS Character_Values;
--2.
SELECT 
    w1.Id
FROM 
    weather w1
    INNER JOIN weather w2 
        ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE 
    w1.Temperature > w2.Temperature;
--3.
SELECT 
    player_id,
    MIN(event_date) AS first_login_date
FROM 
    Activity
GROUP BY 
    player_id;
--4.
WITH SplitFruits AS (
    SELECT 
        value,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM 
        STRING_SPLIT((SELECT fruit_list FROM fruits), ',')
)
SELECT 
    value AS third_item
FROM 
    SplitFruits
WHERE 
    rn = 3;
--5.
-- Creating table to store individual characters
CREATE TABLE CharacterRows (
    CharacterValue CHAR(1)
);

-- Inserting each character from the string as a row
INSERT INTO CharacterRows (CharacterValue)
SELECT 
    SUBSTRING(str, n, 1)
FROM 
    (SELECT 'sdgfhsdgfhs@121313131' AS str) AS input
    CROSS APPLY (
        SELECT TOP(LEN('sdgfhsdgfhs@121313131')) 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM master..spt_values
    ) AS numbers;
--6.
SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code 
        ELSE p1.code 
    END AS code
FROM 
    p1
    INNER JOIN p2 ON p1.id = p2.id;
--7.
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) AS Years_of_Service,
    CASE 
        WHEN FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) <= 5 THEN 'New'
        WHEN FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) <= 10 THEN 'Mid-Level'
        WHEN FLOOR(DATEDIFF(DAY, HIRE_DATE, '2025-07-03') / 365.25) <= 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS Employment_Stage
FROM 
    Employees
ORDER BY 
    Years_of_Service, EMPLOYEE_ID;

Difficult Tasks
--1.
WITH SplitVals AS (
    SELECT 
        Id,
        value,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY (SELECT NULL)) AS rn
    FROM 
        MultipleVals
        CROSS APPLY STRING_SPLIT(Vals, ',')
),
SwappedVals AS (
    SELECT 
        Id,
        CASE 
            WHEN rn = 1 THEN (SELECT value FROM SplitVals sv2 WHERE sv2.Id = sv1.Id AND sv2.rn = 2)
            WHEN rn = 2 THEN (SELECT value FROM SplitVals sv2 WHERE sv2.Id = sv1.Id AND sv2.rn = 1)
            ELSE value
        END AS value
    FROM 
        SplitVals sv1
)
SELECT 
    Id,
    STRING_AGG(value, ',') AS Vals
FROM 
    SwappedVals
GROUP BY 
    Id;
--2.
WITH FirstLogin AS (
    SELECT 
        player_id,
        device_id,
        event_date,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM 
        Activity
)
SELECT 
    player_id,
    device_id
FROM 
    FirstLogin
WHERE 
    rn = 1;
--3.
WITH DailySales AS (
    SELECT 
        Area,
        FinancialWeek,
        FinancialYear,
        DayName,
        Date,
        COALESCE(SalesLocal, 0) + COALESCE(SalesRemote, 0) AS DailyTotalSales
    FROM 
        WeekPercentagePuzzle
),
WeeklySales AS (
    SELECT 
        Area,
        FinancialWeek,
        FinancialYear,
        DayName,
        Date,
        DailyTotalSales,
        SUM(DailyTotalSales) OVER (PARTITION BY Area, FinancialYear, FinancialWeek) AS WeeklyTotalSales,
        LAG(SUM(DailyTotalSales) OVER (PARTITION BY Area ORDER BY FinancialYear, FinancialWeek), 1) 
            OVER (PARTITION BY Area ORDER BY FinancialYear, FinancialWeek) AS PrevWeeklyTotalSales
    FROM 
        DailySales
),
PercentageCalcs AS (
    SELECT 
        Area,
        FinancialWeek,
        FinancialYear,
        DayName,
        Date,
        DailyTotalSales,
        WeeklyTotalSales,
        CASE 
            WHEN WeeklyTotalSales = 0 THEN 0
            ELSE ROUND((DailyTotalSales * 100.0) / WeeklyTotalSales, 2)
        END AS DailyPercentage,
        CASE 
            WHEN PrevWeeklyTotalSales IS NULL OR PrevWeeklyTotalSales = 0 THEN NULL
            ELSE ROUND(((WeeklyTotalSales - PrevWeeklyTotalSales) * 100.0) / PrevWeeklyTotalSales, 2)
        END AS WeekOnWeekPercentage
    FROM 
        WeeklySales
)
SELECT 
    Area,
    FinancialWeek,
    FinancialYear,
    DayName,
    Date,
    DailyPercentage,
    WeekOnWeekPercentage
FROM 
    PercentageCalcs
ORDER BY 
    Area, FinancialYear, FinancialWeek, Date;








