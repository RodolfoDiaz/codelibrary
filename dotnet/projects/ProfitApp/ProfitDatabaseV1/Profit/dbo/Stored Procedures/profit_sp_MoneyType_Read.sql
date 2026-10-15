CREATE PROCEDURE dbo.profit_sp_MoneyType_Read
(	@pMoneyTypeId int
 )
AS
	Select
		[MoneyTypeId],
		[CompanyId], 
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	MoneyType
	Where [MoneyTypeId] = @pMoneyTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_MoneyType_Read] TO [profit_role_datareader]
    AS [dbo];

