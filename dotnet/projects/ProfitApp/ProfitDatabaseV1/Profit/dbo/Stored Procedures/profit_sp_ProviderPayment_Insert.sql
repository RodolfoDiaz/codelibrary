CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Insert 
(	@pProviderPaymentId int OUTPUT,
	@pCompanyId int,
	@pProviderId int  ,
	@pDebitDocumentId int,
	@pCreditDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT 

	if @@ERROR = 0 
		Insert into ProviderPayment
			([CompanyId], [ProviderId], [CreditDocumentId], [DebitDocumentId], [MoneyTypeId] , [PaymentDate], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pProviderId, @pCreditDocumentId, @pDebitDocumentId, @pMoneyTypeId, @pPaymentDate, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProviderPaymentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Insert] TO [profit_role_fullaccess]
    AS [dbo];

