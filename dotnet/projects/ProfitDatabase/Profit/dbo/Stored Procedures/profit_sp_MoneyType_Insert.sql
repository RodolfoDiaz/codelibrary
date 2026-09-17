CREATE PROCEDURE dbo.profit_sp_MoneyType_Insert 
(	@pMoneyTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) 
 )
AS
	Insert into MoneyType
		([CompanyId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pMoneyTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Insert] TO [profit_role_fullaccess]
    AS [dbo];

