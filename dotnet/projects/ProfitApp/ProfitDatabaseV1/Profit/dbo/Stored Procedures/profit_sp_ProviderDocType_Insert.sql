CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Insert 
(	@pDocTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50),
	@pIsDebit bit 
 )
AS
	Insert into ProviderDocType
		([CompanyId], [Name], [IsDebit], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pIsDebit, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocType_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocType_Insert] TO [profit_role_fullaccess]
    AS [dbo];

