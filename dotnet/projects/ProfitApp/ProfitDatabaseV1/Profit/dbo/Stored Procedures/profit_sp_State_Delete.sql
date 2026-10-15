CREATE PROCEDURE dbo.profit_sp_State_Delete 
(	@pStateId int
 )
AS
	Delete State
	Where
		[StateId] = @pStateId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Delete] TO [profit_role_fullaccess]
    AS [dbo];

