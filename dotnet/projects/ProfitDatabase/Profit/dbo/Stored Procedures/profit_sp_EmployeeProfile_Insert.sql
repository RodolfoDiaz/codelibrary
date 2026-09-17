CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Insert 
(	@pEmployeeProfileId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pCommission money
 )
AS
	Insert into EmployeeProfile
		([CompanyId], [Name], [Commission], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pCommission, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pEmployeeProfileId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Insert] TO [profit_role_fullaccess]
    AS [dbo];

