CREATE PROCEDURE dbo.profit_sp_State_Insert 
(	@pStateId int OUTPUT,
	@pCountryId int,
	@pName varchar (50) 
 )
AS
	Insert into State
		([CountryId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCountryId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pStateId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Insert] TO [profit_role_fullaccess]
    AS [dbo];

