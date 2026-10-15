CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Read
(	@pExchangeRateId int
 )
AS
	Select
		[ExchangeRateId], 
		[CompanyId],
		[RefreshDate], 
		[Amount], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From ExchangeRate
	Where [ExchangeRateId] = @pExchangeRateId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ExchangeRate_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ExchangeRate_Read] TO [profit_role_datareader]
    AS [dbo];

