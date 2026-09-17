CREATE PROCEDURE dbo.profit_sp_ClientPayment_Read
(	@pClientPaymentId int
 )
AS
	Select 
		[ClientPaymentId],
		[CompanyId],
		[ClientId], 
		[CreditDocumentId], 
		[DebitDocumentId], 
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
	From	ClientPayment
	Where [ClientPaymentId] = @pClientPaymentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientPayment_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientPayment_Read] TO [profit_role_datareader]
    AS [dbo];

