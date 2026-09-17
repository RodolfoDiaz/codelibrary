CREATE PROCEDURE dbo.profit_sp_Provider_Delete 
(	@pProviderId int 
 )
AS
	Delete Provider
	Where
		([ProviderId] = @pProviderId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Provider_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Provider_Delete] TO [profit_role_fullaccess]
    AS [dbo];

