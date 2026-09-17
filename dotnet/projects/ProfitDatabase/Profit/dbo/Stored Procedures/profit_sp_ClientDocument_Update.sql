CREATE PROCEDURE dbo.profit_sp_ClientDocument_Update
(	@pDocumentId int,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pClientId int, 
	@pEmployeeId int,
	@pPaymentTypeId int,
	@pCommission money,
	@pCommissionPaid bit,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [DocDate], @ExchangeRate = [ExchangeRate] From ClientDocument Where ([DocumentId] = @pDocumentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pDocDate)) And (@@ERROR = 0) )
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ClientDocument 
		Set
			[CompanyId] = @pCompanyId, [DocTypeId] = @pDocTypeId, [DocumentStatusId] = @pDocumentStatusId, [ClientId] = @pClientId, [EmployeeId] = @pEmployeeId, [PaymentTypeId] = @pPaymentTypeId, [Commission] = @pCommission, [CommissionPaid] = @pCommissionPaid, [DocDate] = @pDocDate, [DocConsecutive] = @pDocConsecutive, [OtherCost] = @pOtherCost, [Discount] = @pDiscount, [Tax] = @pTax, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
		Where
			[DocumentId] = @pDocumentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientDocument
		Where [DocumentId] = @pDocumentId

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
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Update] TO [profit_role_fullaccess]
    AS [dbo];

