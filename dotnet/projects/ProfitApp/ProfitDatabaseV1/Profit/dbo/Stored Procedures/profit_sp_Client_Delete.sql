CREATE PROCEDURE dbo.profit_sp_Client_Delete 
(	@pClientId int
 )
AS
	Delete Client
	Where
		([ClientId] = @pClientId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Delete] TO [profit_role_fullaccess]
    AS [dbo];

