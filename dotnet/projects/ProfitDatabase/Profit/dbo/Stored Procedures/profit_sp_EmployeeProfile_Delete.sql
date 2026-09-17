CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Delete 
(	@pEmployeeProfileId int 
)
AS
	Delete EmployeeProfile
	Where 
		([EmployeeProfileId] = @pEmployeeProfileId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Delete] TO [profit_role_fullaccess]
    AS [dbo];

