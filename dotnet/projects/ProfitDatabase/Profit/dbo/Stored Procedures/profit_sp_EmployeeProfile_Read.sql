CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Read
(	@pEmployeeProfileId int
 )
AS
	Select
		[EmployeeProfileId], 
		[CompanyId], 
		[Name], 
		[Commission], 
		user_name([InsertUser]) AS InsertUser,
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From
		 EmployeeProfile
	Where [EmployeeProfileId] = @pEmployeeProfileId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Read] TO [profit_role_datareader]
    AS [dbo];

