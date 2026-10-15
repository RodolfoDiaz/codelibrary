CREATE PROCEDURE dbo.profit_sp_Commission_Delete 
(	@pCommissionId int
 )
AS
	Delete Commission
	Where
		[CommissionId] = @pCommissionId


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Delete] TO [profit_role_fullaccess]
    AS [dbo];

