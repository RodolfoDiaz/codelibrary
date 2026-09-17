CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Delete 
(	@pDocumentStatusId int
 )
AS
	Delete DocumentStatus
	Where	[DocumentStatusId] = @pDocumentStatusId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_DocumentStatus_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_DocumentStatus_Delete] TO [profit_role_fullaccess]
    AS [dbo];

