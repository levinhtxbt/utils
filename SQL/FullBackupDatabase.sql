use [master]
GO
-- =============================================
-- Author: Vinh Le
-- Name: FullBackupDatabase
-- Description:	
-- Usage: Restore full backup file for specific database
-- Notes:	
-- History:
-- Date			Author		Description
-- 2021-03-21	ZinL		Intial
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[FullBackupDatabase] 
	@databaseName VARCHAR(50),-- database name 
	@path VARCHAR(256) = null,-- path for backup files , default folder
	@fileName VARCHAR(256) = null -- filename for backup  
AS
BEGIN
	DECLARE @fileDate VARCHAR(20)
	-- specify database backup directory
	IF @path is null 
	BEGIN
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\';
	END

	-- specify filename format
	SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
 
	DECLARE db_cursor CURSOR READ_ONLY FOR  
	SELECT name 
	FROM master.sys.databases 
	WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
	AND state = 0 -- database is online
	AND is_in_standby = 0 -- database is not read only for log shipping
	AND (name = @databaseName or @databaseName is null)

	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @databaseName   
	
	IF @fileName is null
	BEGIN
		SET @fileName =  @databaseName + '_' + @fileDate + '.BAK'
	END
 
	WHILE @@FETCH_STATUS = 0   
	BEGIN   
	   SET @fileName = @path + @fileName + ISNULL((select '.BAK' where @fileName not like '%.BAK'), '');  
	   BACKUP DATABASE @databaseName TO DISK = @fileName  
 
	   FETCH NEXT FROM db_cursor INTO @databaseName   
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor

END

GO