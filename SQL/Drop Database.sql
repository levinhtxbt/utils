

USE master

DECLARE @databasename varchar(50) = 'M1CX_Identity'

IF EXISTS(select * from sys.databases where name = @databasename)
BEGIN 
    EXEC KillAllDatabaseProcesses @DatabaseName = @databasename, @LiveRun = 1
    DROP DATABASE M1CX_Identity
END

CREATE DATABASE M1CX_Identity
--COLLATE Latin1_General_CI_AS;  
