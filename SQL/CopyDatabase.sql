

DECLARE @vSQL nvarchar(MAX) = ''


select @vSQL += CHAR(13)+CHAR(10) + FORMATMESSAGE('exec [FullCopyDatabaseAndLog] @databaseName = ''M1CX_Tenant'', @newDatabaseName = ''%s'' ', t.DatabaseName) 
from [M1CX_Master].[dbo].[Tenant] t
	 left join  sys.databases db on db.name = t.DatabaseName
where 
	t.DatabaseName like 'M1CX_Tenant%' 
	and db.name is null
	and t.IsLive = 1


select @vSQL
exec sp_executesql @vSQL
