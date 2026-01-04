SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Recompile everything after all patches have run
EXEC sys.sp_msforeachtable 'PRINT ''Checking ?'';';

-- Refresh (recompile) all views/procs/functions
DECLARE @sql nvarchar(max) = N'';

SELECT @sql = @sql + N'
BEGIN TRY
  EXEC sys.sp_refreshsqlmodule N''' + QUOTENAME(SCHEMA_NAME(o.schema_id)) + N'.' + QUOTENAME(o.name) + N''';
END TRY
BEGIN CATCH
  PRINT ''FAILED: ' + QUOTENAME(SCHEMA_NAME(o.schema_id)) + N'.' + QUOTENAME(o.name) + N' -> '' + ERROR_MESSAGE();
END CATCH;'
FROM sys.objects o
WHERE o.type IN ('V','P','FN','IF','TF');  -- views, procs, functions

EXEC sys.sp_executesql @sql;

-- Hard fail if anything is still invalid
;WITH broken AS (
  SELECT SCHEMA_NAME(o.schema_id) AS schema_name, o.name, o.type_desc
  FROM sys.objects o
  WHERE o.type IN ('V','P','FN','IF','TF')
    AND OBJECTPROPERTYEX(o.object_id, 'IsSchemaBound') IS NOT NULL -- harmless filter
    AND OBJECTPROPERTY(o.object_id, 'IsValid') = 0
)
SELECT * FROM broken;

IF EXISTS (
  SELECT 1
  FROM sys.objects o
  WHERE o.type IN ('V','P','FN','IF','TF')
    AND OBJECTPROPERTY(o.object_id, 'IsValid') = 0
)
BEGIN
  THROW 51000, 'One or more views/procs/functions are still invalid after patches. See result set above.', 1;
END
