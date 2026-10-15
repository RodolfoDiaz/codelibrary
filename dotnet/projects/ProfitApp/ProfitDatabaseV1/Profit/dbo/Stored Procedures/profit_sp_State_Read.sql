CREATE PROCEDURE dbo.profit_sp_State_Read
(	@pStateId int
 )
AS
	Select
		[StateId],
		[CountryId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	State
	Where [StateId] = @pStateId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_State_Read] TO [profit_role_datareader]
    AS [dbo];

