CREATE PROCEDURE dbo.profit_sp_Commission_Update
(	@pCommissionId int,
	@pCompanyId int,
	@pEmployeeId int,
	@pDocumentId int,
	@pDocDate datetime,
	@pAmount money,
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [DocDate], @ExchangeRate = [ExchangeRate] From Commission Where ([CommissionId] = @pCommissionId)

	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pDocDate)) And (@@ERROR = 0) )
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update Commission
		Set
			[CompanyId] = @pCompanyId, [EmployeeId] = @pEmployeeId, [DocumentId] = @pDocumentId, [DocDate] = @pDocDate, [Amount] = @pAmount, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
		Where
			[CommissionId] = @pCommissionId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Commission
		Where [CommissionId] = @pCommissionId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Update] TO [profit_role_fullaccess]
    AS [dbo];

