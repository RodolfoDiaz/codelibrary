CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Insert 
(	@pExchangeRateId int OUTPUT,
	@pCompanyId int,
	@pAmount money   
 )
AS
	Insert into ExchangeRate
		([CompanyId], [RefreshDate], [Amount], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, getdate(), @pAmount, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pExchangeRateId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ExchangeRate_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ExchangeRate_Insert] TO [profit_role_fullaccess]
    AS [dbo];

