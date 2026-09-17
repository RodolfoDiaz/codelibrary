CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Delete 
(	@pDocTypeId int
 )
AS
	Delete ProviderDocType
	Where
		[DocTypeId] = @pDocTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocType_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderDocType_Delete] TO [profit_role_fullaccess]
    AS [dbo];

