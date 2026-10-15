CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Insert 
(	@pDocumentId int OUTPUT,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pProviderId int, 
	@pPaymentTypeId int,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT 

	if @@ERROR = 0 
		Insert into ProviderDocument 
			([CompanyId], [DocTypeId], [DocumentStatusId], [ProviderId], [PaymentTypeId], [DocDate], [DocConsecutive], [OtherCost], [Discount], [Tax], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pDocTypeId, @pDocumentStatusId, @pProviderId, @pPaymentTypeId, @pDocDate, @pDocConsecutive, @pOtherCost, @pDiscount, @pTax, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocumentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocument_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocument_Insert] TO [profit_role_fullaccess]
    AS [dbo];

