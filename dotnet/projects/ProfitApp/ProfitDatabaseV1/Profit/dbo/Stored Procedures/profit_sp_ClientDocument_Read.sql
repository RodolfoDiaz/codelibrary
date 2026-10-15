CREATE PROCEDURE dbo.profit_sp_ClientDocument_Read
(	@pDocumentId int
 )
AS
	Select
		[DocumentId], 
		[CompanyId],
		[DocTypeId], 
		[DocumentStatusId],
		[ClientId], 
		[EmployeeId], 
		[PaymentTypeId],
		[Commission], 
		[CommissionPaid],
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
	From	ClientDocument
	Where [DocumentId] = @pDocumentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Read] TO [profit_role_datareader]
    AS [dbo];

