create database homework3
use homework3

--1.
BULK INSERT Employees
FROM 'C:\Users\Asus\Documents\SQL Server Management Studio\Customers.csv'
WITH (
    FIELDTERMINATOR = ',',   -- Specifies a comma as the column delimiter
    ROWTERMINATOR = '\n',      -- Specifies a newline as the row delimiter
    FIRSTROW = 2               -- Skips the header row
);
--2.
CSV, TXT, XML, xls, xlsx, 
--3.
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
--4.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
    (1, 'Laptop', 1200.00),
    (2, 'Smartphone', 800.00),
    (3, 'Tablet', 300.00);
--5.
NULL
--noma'lum qiymatni bildiradi. Bu bo'sh satr yoki nol qiymat bilan bir xil emas;
--ushbu ustunda hech narsa yozilmaganligini anglatadi.

NULL EMAS:
--Ta'rif: ustunni NULL emas deb e'lon qilish, u har doim to'g'ri qiymatni o'z ichiga olishi kerakligini anglatadi. 
--Jadvaldagi har bir yozuvda ushbu ustun uchun nol bo'lmagan qiymat bo'lishi kerakligi cheklovini amalga oshiradi.

--Foydalanish: bu asosiy kalit yoki Foydalanuvchining elektron pochta manzili kabi muhim atribut kabi 
--ilovangizning yaxlitligi va mantig'i uchun zarur bo'lgan muhim ma'lumotlar uchun foydalidir.
--
--6.
ALTER TABLE Products
ADD CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName);
--7.
-- This query retrieves all columns from the Products table to display the complete product list.
SELECT * FROM Products;
--8.
ALTER TABLE Products
ADD CategoryID INT;
--9.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
--10.
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
--SQL Server—dagi identifikatsiya ustunining maqsadi jadvalga yangi satr kiritilganda avtomatik ravishda ustun uchun noyob, 
--ketma—ket raqamli qiymatlarni yaratishdir-odatda surrogat asosiy kalit sifatida ishlatiladi.
--11.
BULK INSERT Products
FROM 'C:\Data\ProductsData.txt'
WITH
(
    FIELDTERMINATOR = ',',  -- Specifies comma as the column delimiter
    ROWTERMINATOR = '\n',     -- Specifies newline as the row delimiter
    FIRSTROW = 2              -- Skips the header row, if the file includes one
);
--12.
ALTER TABLE Products
ADD CategoryID INT;

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
ON DELETE CASCADE ON UPDATE CASCADE;
--13.
CREATE TABLE Users (
    UserID INT NOT NULL,
    Username VARCHAR(50),
    PRIMARY KEY (UserID)
);
select * from Users
--13.
CREATE TABLE Employees (
    EmployeeID INT NOT NULL PRIMARY KEY,
    Email VARCHAR(100),
    SSN VARCHAR(11),
    UNIQUE (Email),
    UNIQUE (SSN)
);
select * from employees
--14.
UPDATE Products SET Price = NULL WHERE Price <= 0;
ALTER TABLE Products
ADD Price DECIMAL(10,2);
--15.
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
--16.
UPDATE Products
SET Price = ISNULL(Price, 0);

SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

ALTER TABLE Products
ALTER COLUMN Price DECIMAL(10,2) NOT NULL;


select * from Products
--17.
CREATE TABLE ChildTable (
    Column1 INT,
    ForeignKeyColumn INT,
    CONSTRAINT FK_Name FOREIGN KEY (ForeignKeyColumn)
    REFERENCES ParentTable(ParentKeyColumn)
);
ALTER TABLE ChildTable
ADD CONSTRAINT FK_Name FOREIGN KEY (ForeignKeyColumn)
REFERENCES ParentTable(ParentKeyColumn);
--18.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Email VARCHAR(100) UNIQUE,
    CONSTRAINT CHK_Age CHECK (Age >= 18)
);
--19.
CREATE TABLE Orders (
    OrderID INT IDENTITY(100,10) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerName VARCHAR(100) NOT NULL
);
--20.
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);
--21.
SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;
UPDATE Products
SET Price = ISNULL(Price, 0);
SELECT ProductID, COALESCE(ProductName, 'Unknown Product') AS ProductName
FROM Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) UNIQUE,
    Price DECIMAL(10,2),
    Stock INT NOT NULL DEFAULT 0,
    CategoryID INT
);
SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price, Stock, CategoryID
FROM Products;

UPDATE Products
SET CategoryID = ISNULL(CategoryID, 1);
--22.
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE NOT NULL
);
ALTER TABLE Employees
ADD CONSTRAINT UQ_Email UNIQUE (Email);
--23.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
ON DELETE CASCADE
ON UPDATE CASCADE;

SELECT CategoryID FROM Products
WHERE CategoryID IS NOT NULL
AND CategoryID NOT IN (SELECT CategoryID FROM Categories);

