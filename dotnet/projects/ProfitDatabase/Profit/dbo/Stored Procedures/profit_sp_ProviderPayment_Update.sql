CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Update
(	@pProviderPaymentId int,
	@pCompanyId int,
	@pProviderId int  ,
	@pDebitDocumentId int,
	@pCreditDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [PaymentDate], @ExchangeRate = [ExchangeRate] From ProviderPayment Where ([ProviderPaymentId] = @pProviderPaymentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pPaymentDate)) And (@@ERROR = 0))
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ProviderPayment
		Set
			[CompanyId] = @pCompanyId, [ProviderId] = @pProviderId, [CreditDocumentId] = @pCreditDocumentId, [DebitDocumentId] = @pDebitDocumentId, [MoneyTypeId] = @pMoneyTypeId, [PaymentDate] = @pPaymentDate, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] =  user_id(), [LastUpdateDate] = getdate()
		Where
			[ProviderPaymentId] = @pProviderPaymentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProviderPayment
		Where [ProviderPaymentId] = @pProviderPaymentId

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
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Update] TO [profit_role_fullaccess]
    AS [dbo];

