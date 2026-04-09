USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Sandeep')
BEGIN
    CREATE LOGIN Sandeep WITH PASSWORD = 'Sandeep@123';
END
GO

ALTER SERVER ROLE sysadmin ADD MEMBER Sandeep;
GO

-- Create Databases
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_IdentityDB')
    CREATE DATABASE Airline_IdentityDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_FlightDB')
    CREATE DATABASE Airline_FlightDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_BookingDB')
    CREATE DATABASE Airline_BookingDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_PaymentDB')
    CREATE DATABASE Airline_PaymentDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_RewardDB')
    CREATE DATABASE Airline_RewardDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_AgentDB')
    CREATE DATABASE Airline_AgentDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_CheckInDB')
    CREATE DATABASE Airline_CheckInDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_BaggageDB')
    CREATE DATABASE Airline_BaggageDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_NotificationDB')
    CREATE DATABASE Airline_NotificationDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Airline_AdminDB')
    CREATE DATABASE Airline_AdminDB;
GO
