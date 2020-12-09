-- Create a new database called 'Puff'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'Puff'
)
CREATE DATABASE Puff
GO


-- Tables are described by separate scripts
-- Puff
-- Puff_Interval
-- Puff_Staging
-- Puff_Usage
-- Puff_Usage_Staging
