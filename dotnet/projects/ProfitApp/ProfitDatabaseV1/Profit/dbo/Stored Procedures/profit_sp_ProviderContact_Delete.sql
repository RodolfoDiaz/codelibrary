CREATE PROCEDURE dbo.profit_sp_ProviderContact_Delete 
(	@pContactId int
 )
AS
	Delete ProviderContact
	Where
		[ContactId]=@pContactId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Delete] TO [profit_role_fullaccess]
    AS [dbo];

