CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Delete 
(	@pDocumentId int,
	@pProductId int
 )
AS
if Not(@pProductId Is Null)
	Delete ClientDocDetail
	Where
		[DocumentId]  = @pDocumentId  AND [ProductId]  = @pProductId
else
	Delete ClientDocDetail
	Where
		[DocumentId]  = @pDocumentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Delete] TO [profit_role_fullaccess]
    AS [dbo];

