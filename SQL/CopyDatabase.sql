
use master
go

DECLARE @databaseName varchar(255) = 'M1CX_Tenant'
DECLARE @newDatabaseName varchar(255) = 'M1CX_Tenant_CityMazda'
DECLARE @dumpDevice varchar(255) = @databaseName + '_dump_' + CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE @path varchar(max)
DECLARE @dumpPath varchar(max) 
IF @path is null 
	BEGIN
		-- Default path
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\';
	END

SET @dumpPath = @path + @dumpDevice +'.bak';

if exists (select top 1 1 from sys.backup_devices where name = @dumpDevice)
	EXEC sp_dropdevice @dumpDevice

-- create new backup device
EXEC sp_addumpdevice 'disk', @dumpDevice, @dumpPath;

-- backup database to backup device
BACKUP DATABASE @databaseName
    TO @dumpDevice ;

-- list file in backup device
RESTORE FILELISTONLY
    FROM @dumpDevice ;

DECLARE @newDatabasePath varchar(255) = @path + @newDatabaseName+'.mdf';
DECLARE @newDatabaseLogPath varchar(255) = @path + @newDatabaseName + '.ldf'
DECLARE @newDatabaseLogName varchar(255) = concat(@databaseName,'_log');
RESTORE DATABASE @newDatabaseName
    FROM @dumpDevice
    WITH MOVE @databaseName TO @newDatabasePath,
    MOVE @newDatabaseLogName TO @newDatabaseLogPath;


EXEC sp_dropdevice @dumpDevice


