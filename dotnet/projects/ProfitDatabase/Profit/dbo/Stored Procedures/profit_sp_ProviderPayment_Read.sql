CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Read
(	@pProviderPaymentId int
 )
AS
	Select 
		[ProviderPaymentId],
		[CompanyId],
		[ProviderId], 
		[DebitDocumentId], 
		[CreditDocumentId], 
		[MoneyTypeId],
		[PaymentDate],
		[Amount], 
		[Remarks],
		[ExchangeRate],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderPayment
	Where [ProviderPaymentId] = @pProviderPaymentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Read] TO [profit_role_datareader]
    AS [dbo];

