CREATE PROCEDURE dbo.profit_sp_Department_Insert 
(	@pDepartmentId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pLocation varchar (200) 
 )
AS
	Insert into Department
		([CompanyId], [Name], [Location], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pLocation, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDepartmentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Insert] TO [profit_role_fullaccess]
    AS [dbo];

