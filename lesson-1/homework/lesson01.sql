-- data is a collection of different things like facts, information and statistics that can be in various forms 
-- database is an orginized collection of data that is stored and managed electronically
-- rational database is a type of database that  organizes data into rows and columns
-- table is a structured collection of data organized into rows and columns
-- key features of SQL are High Performance, Security, Advanced Analytics, High Availability, Cloud and Hybrid Deployment
-- different authentication modes are windows authentication, sql server authentication, microsoft entra passwords, MFA and others 
 create database SchoolDB
create table Students ( StudentID INT PRIMARY KEY, Name VARCHAR(50),Age INT);
-- sql server is a database managment system created by Microsodft
-- SSMS is SQL server management Studio and is an application used to interact with SQL Server 
-- SQL is the language used to interact with databases.
-- DQL is data query language that is used to retrievedata from a database. for example, select *from Students; 
-- DML is data manipulation language taht it commands modify data within tables and these commands insert, update, and delete records.
-- DDl is Data Definition Language that commands define and modify database structures and uses create, alter and delete and others 
-- DCL is data control language that commands manage user permissions like using like this: GRANT SELECT ON Students TO User1; REVOKE SELECT ON Students FROM User1;
-- TCL is transaction control language that commands handle transactions in databases and uses  start, commit or rollback and other commands.
insert into Students (StudentID, Name, Age) Values
(1, 'Bekjan', 21), (2, 'Nodir', 18), (3, 'Bekzod', 35);
-- search google or edge "Avantureworks database"and then enter first one named microsoft learn. download AdventureWorksDW2022.bak from there. After having downloaded, I uploaded here: Program files->Microsoft SQL Server->MSSQL16.MSSQLSERVER-> MSSQL -> backup.
