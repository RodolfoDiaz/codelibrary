CREATE PROCEDURE dbo.profit_sp_Commission_Insert 
(	@pCommissionId int OUTPUT,
	@pCompanyId int,
	@pEmployeeId int,
	@pDocumentId int,
	@pDocDate datetime,
	@pAmount money
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Insert into Commission
			([CompanyId], [EmployeeId], [DocumentId], [DocDate], [Amount], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pEmployeeId, @pDocumentId, @pDocDate, @pAmount, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pCommissionId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Insert] TO [profit_role_fullaccess]
    AS [dbo];

