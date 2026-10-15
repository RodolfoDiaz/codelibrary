
CREATE   PROCEDURE [Security].[GrantApplicationRole]
    @UserName sysname,
    @RoleName sysname
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=@UserName AND type IN ('S','U','E','X'))
        THROW 51005, 'Database principal does not exist.', 1;
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=@RoleName AND type='R')
        THROW 51006, 'Database role does not exist.', 1;
    DECLARE @sql nvarchar(500) =
        N'ALTER ROLE ' + QUOTENAME(@RoleName) + N' ADD MEMBER ' + QUOTENAME(@UserName) + N';';
    EXEC sys.sp_executesql @sql;
END;

GO
GRANT EXECUTE
    ON OBJECT::[Security].[GrantApplicationRole] TO [ERP_Admin]
    AS [dbo];

