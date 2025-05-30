create database homework6
use homework6
--1.
CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);

INSERT INTO InputTbl (col1, col2) VALUES
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');
SELECT DISTINCT GREATEST(col1, col2) AS col1, LEAST(col1, col2) AS col2
FROM InputTbl;

SELECT DISTINCT 
    CASE WHEN col1 <= col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 <= col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;

SELECT 
    MIN(col1) AS col1,
    MAX(col2) AS col2
FROM InputTbl
GROUP BY 
    CASE WHEN col1 <= col2 THEN col1 ELSE col2 END,
    CASE WHEN col1 <= col2 THEN col2 ELSE col1 END;
--2.
	CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero (A, B, C, D) VALUES
(0, 0, 0, 1),
(0, 0, 1, 0),
(0, 1, 0, 0),
(1, 0, 0, 0),
(0, 0, 0, 0),
(1, 1, 1, 0);

SELECT A, B, C, D
FROM TestMultipleZero
WHERE A != 0 OR B != 0 OR C != 0 OR D != 0;

SELECT A, B, C, D
FROM TestMultipleZero
WHERE A + B + C + D != 0;
--3.
CREATE TABLE section1 (
    id INT,
    nomi VARCHAR(20)
);

INSERT INTO section1 (id, nomi) VALUES
(1, 'bo''lgan'),
(2, 'Roma'),
(3, 'Steven'),
(4, 'Paulo'),
(5, 'Genryh'),
(6, 'Bruno'),
(7, 'Fred'),
(8, 'Andro');

SELECT id, nomi
FROM section1
WHERE id % 2 = 1;

SELECT id, nomi
FROM section1
WHERE id % 2 <> 0;
--4.
SELECT TOP 1 id, nomi
FROM section1
ORDER BY id ASC;

SELECT id, nomi
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);
--5.
SELECT TOP 1 id, nomi
FROM section1
ORDER BY id DESC;

SELECT id, nomi
FROM section1
WHERE id = (SELECT MAX(id) FROM section1);
--6.
SELECT id, nomi
FROM section1
WHERE nomi LIKE 'B%';

SELECT id, nomi
FROM section1
WHERE UPPER(nomi) LIKE 'B%';

SELECT id, nomi
FROM section1
WHERE LOWER(nomi) LIKE 'b%';
--7.
CREATE TABLE MahsulotKodlari (
    Kod VARCHAR(20)
);

INSERT INTO MahsulotKodlari (Kod) VALUES
('X-123'),
('X_456'),
('X # 789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

SELECT Kod
FROM MahsulotKodlari
WHERE Kod LIKE '%[_]%';

SELECT Kod
FROM MahsulotKodlari
WHERE CHARINDEX('_', Kod) > 0;
