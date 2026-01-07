/* 
===========================
Create Database and Schemas
===========================

Script purpse:
	This script creates a new database named 'DataWareHouse' after checking if it alredy exists.
	if it exists, it will be dropped and recreated.
	Also the script creates three schemas 'bronez', 'silver', 'gold'.

WARNING:
	If you already have a database named DataWareHouse, please ensure to backup it
	because this script will drop and recreate it
*/

USE master;
GO

--Drop and recreate
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
	ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWareHouse;
END;
GO

CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO

--Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
