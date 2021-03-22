use [master]
go

-- =============================================
-- Author: Vinh Le
-- Name:  RestoreDatabaseFile
-- Description:	 
-- Usage: 
-- Notes:	
-- History:
-- Date				Author			Description
-- 2021-03-21		Vinh Le			Intial
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[RestoreDatabaseFile] 
	@databaseName varchar(50),
	@fileName VARCHAR(256),
	@path VARCHAR(256) = null
AS
BEGIN
	
	IF @path is null 
	BEGIN
		-- Default path
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\';
	END

	SET @fileName = @path + @fileName + ISNULL((select '.BAK' where @fileName not like '%.BAK'), '');  
	
	exec [KillAllDatabaseProcesses] @DatabaseName = @databaseName, @LiveRun = 1

	--To Restore an Entire Database from a Full database backup (a Complete Restore):
	RESTORE DATABASE @databaseName
		FROM DISK = @fileName
		WITH REPLACE;

END


/*------- TESTING ------------------

 exec [RestoreDatabaseFile] @databaseName = 'M1Tenant-Template', 
							@fileName = 'M1Tenant-Template_20210321.BAK',
							@path = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\'

------------------------------------*/