CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Read
(	@pDocumentId int,
	@pProductId int
 )
AS
	Select
		DocumentId,
		ProductId,
		CompanyId,
		Quantity,
		Tax,
		Discount,
		UnitPrice,
		[RowInfo]
	From	ClientDocDetail
	Where
		[DocumentId] = @pDocumentId And [ProductId] = @pProductId
	Order By [DocumentId], [ProductId]

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Read] TO [profit_role_datareader]
    AS [dbo];

