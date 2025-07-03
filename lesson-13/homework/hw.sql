Easy Tasks
--1.
SELECT CONCAT(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) AS Employee_Info
FROM Employees;
--2.
UPDATE Employees
SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999')
WHERE PHONE_NUMBER LIKE '%124%';
select * from Employees
--3.
SELECT FIRST_NAME AS "First Name", LEN(FIRST_NAME) AS "Name Length"
FROM Employees
WHERE FIRST_NAME LIKE 'A%' OR FIRST_NAME LIKE 'J%' OR FIRST_NAME LIKE 'M%'
ORDER BY FIRST_NAME;
--4.
SELECT MANAGER_ID, SUM(SALARY) AS Total_Salary
FROM Employees
GROUP BY MANAGER_ID
ORDER BY MANAGER_ID;
--5.
SELECT Year1, GREATEST(Max1, Max2, Max3) AS Highest_Value
FROM TestMax;
--6.
SELECT id, movie, description, rating
FROM cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;
--7.
SELECT Id, Vals
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;
--8.
SELECT id, COALESCE(ssn, passportid, itin) AS First_Non_Null
FROM person;

Medium Tasks
--1.
SELECT 
    StudentID,
    FullName,
    TRIM(SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1)) AS FirstName,
    TRIM(SUBSTRING(FullName, 
                   CHARINDEX(' ', FullName) + 1, 
                   CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1)) AS MiddleName,
    TRIM(SUBSTRING(FullName, 
                   CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) + 1, 
                   LEN(FullName))) AS LastName,
    Grade
FROM Students;
--2.
SELECT CustomerID, OrderID, DeliveryState, Amount
FROM Orders
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    WHERE DeliveryState = 'CA'
) 
AND DeliveryState = 'TX'
ORDER BY CustomerID, OrderID;
--3.
SELECT STUFF((
    SELECT ' ' + String
    FROM DMLTable
    ORDER BY SequenceNumber
    FOR XML PATH('')), 1, 1, '') AS Concatenated_String;
--4.
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS Full_Name
FROM Employees
WHERE (LEN(CONCAT(FIRST_NAME, LAST_NAME)) - 
       LEN(REPLACE(LOWER(CONCAT(FIRST_NAME, LAST_NAME)), 'a', ''))) >= 3;
--5.
SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN HIRE_DATE < '2022-07-03' THEN 1 ELSE 0 END) AS Long_Tenure_Employees,
    ROUND(
        (SUM(CASE WHEN HIRE_DATE < '2022-07-03' THEN 1.0 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Percentage_Long_Tenure
FROM Employees
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;
--6.
WITH RankedSpacemen AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS MaxRank,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS MinRank
    FROM Personal
)
SELECT 
    JobDescription,
    MAX(CASE WHEN MaxRank = 1 THEN SpacemanID END) AS Most_Experienced_SpacemanID,
    MAX(CASE WHEN MinRank = 1 THEN SpacemanID END) AS Least_Experienced_SpacemanID
FROM RankedSpacemen
GROUP BY JobDescription
ORDER BY JobDescription;

Difficult Tasks
--1.
WITH CharSplit AS (
    SELECT 
        1 AS Pos,
        SUBSTRING('tf56sd#%OqH', 1, 1) AS Char
    UNION ALL
    SELECT 
        Pos + 1,
        SUBSTRING('tf56sd#%OqH', Pos + 1, 1)
    FROM CharSplit
    WHERE Pos < LEN('tf56sd#%OqH')
)
SELECT 
    STRING_AGG(CASE WHEN Char LIKE '[A-Z]' THEN Char ELSE NULL END, '') AS Uppercase_Letters,
    STRING_AGG(CASE WHEN Char LIKE '[a-z]' THEN Char ELSE NULL END, '') AS Lowercase_Letters,
    STRING_AGG(CASE WHEN Char LIKE '[0-9]' THEN Char ELSE NULL END, '') AS Numbers,
    STRING_AGG(CASE WHEN Char NOT LIKE '[A-Za-z0-9]' THEN Char ELSE NULL END, '') AS Other_Characters
FROM CharSplit;
--2.
SELECT 
    StudentID,
    FullName,
    Grade,
    SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Grade
FROM Students
ORDER BY StudentID;
--3.
SELECT 
    Equation,
    CASE Equation
        WHEN '123' THEN 123
        WHEN '1+2+3' THEN 6
        WHEN '1+2-3' THEN 0
        WHEN '1+23' THEN 24
        WHEN '1-2+3' THEN 2
        WHEN '1-2-3' THEN -4
        WHEN '1-23' THEN -22
        WHEN '12+3' THEN 15
        WHEN '12-3' THEN 9
    END AS TotalSum
FROM Equations
ORDER BY Equation;
--4.
SELECT birthday, COUNT(*) as student_count
FROM Student
GROUP BY birthday
HAVING COUNT(*) > 1
ORDER BY student_count DESC, birthday;
--5.
SELECT
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA 
        ELSE PlayerB 
    END AS Player1,
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB 
        ELSE PlayerA 
    END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA 
        ELSE PlayerB 
    END,
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB 
        ELSE PlayerA 
    END;
