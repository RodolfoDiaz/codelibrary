CREATE PROCEDURE dbo.profit_sp_MoneyType_Delete 
(	@pMoneyTypeId int
 )
AS
	Delete MoneyType
	Where	[MoneyTypeId] = @pMoneyTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Delete] TO [profit_role_fullaccess]
    AS [dbo];

