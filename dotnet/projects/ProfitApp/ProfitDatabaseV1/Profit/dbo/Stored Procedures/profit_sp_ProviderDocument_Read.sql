CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Read
(	@pDocumentId int
 )
AS
	Select
		[DocumentId], 
		[CompanyId],
		[DocTypeId], 
		[DocumentStatusId],
		[ProviderId], 
		[PaymentTypeId], 
		[DocDate], 
		[DocConsecutive],
		[OtherCost], 
		[Discount], 
		[Tax], 
		[Amount], 
		[Remarks], 
		[ExchangeRate],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderDocument
	Where [DocumentId] = @pDocumentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocument_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocument_Read] TO [profit_role_datareader]
    AS [dbo];

