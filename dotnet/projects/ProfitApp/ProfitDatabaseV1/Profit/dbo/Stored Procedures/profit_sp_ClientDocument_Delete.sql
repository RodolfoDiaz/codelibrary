CREATE PROCEDURE dbo.profit_sp_ClientDocument_Delete 
(	@pDocumentId int 
 )
AS
	Delete ClientDocument 
	Where
		([DocumentId] = @pDocumentId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocument_Delete] TO [profit_role_fullaccess]
    AS [dbo];

