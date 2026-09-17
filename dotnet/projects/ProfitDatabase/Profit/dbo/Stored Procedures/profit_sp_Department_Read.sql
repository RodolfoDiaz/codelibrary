CREATE PROCEDURE dbo.profit_sp_Department_Read
(	@pDepartmentId int
 )
AS
	Select
		[DepartmentId],
		[CompanyId],
		[Name],
		[Location],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Department
	Where [DepartmentId] = @pDepartmentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Read] TO [profit_role_datareader]
    AS [dbo];

