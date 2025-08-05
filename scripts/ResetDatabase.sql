-- Connect to the master database to manage other databases
USE master;
GO

-- Safely drop the existing database if it exists
IF DB_ID('ThreeDModelsTrackerDB') IS NOT NULL
BEGIN
    ALTER DATABASE ThreeDModelsTrackerDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ThreeDModelsTrackerDB;
END
GO

-- Create a new, clean database
CREATE DATABASE ThreeDModelsTrackerDB;
GO

PRINT 'Database reset complete.';