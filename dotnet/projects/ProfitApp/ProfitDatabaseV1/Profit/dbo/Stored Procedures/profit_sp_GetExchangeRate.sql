
CREATE PROCEDURE dbo.profit_sp_GetExchangeRate(
	@pCompanyId int,
	@pDocDate datetime,
	@pExchangeRate money Output) 
AS
	Declare @MultipleCurrency bit, @MaxExchangeRate int, @sqlError int
	Set @MultipleCurrency = 0
	Set @pExchangeRate = 1
	
	Select @MultipleCurrency = [MultipleCurrency] From Company Where CompanyId = @pCompanyId
	
	if (@@ERROR = 0) And (@MultipleCurrency = 1)
	Begin
		SELECT     @pExchangeRate = Amount
		FROM         dbo.ExchangeRate
		WHERE     (CompanyId = @pCompanyId) AND (RefreshDate =
		                          (SELECT     MAX(RefreshDate)
		                            FROM          dbo.ExchangeRate
		                            WHERE      ( CONVERT(Char(10), RefreshDate,101) <= CONVERT(Char(10), @pDocDate,101)) )
			      )
	End
	
	If (@pExchangeRate <= 0.00) Or (@pExchangeRate Is Null)
		Set @pExchangeRate = 1

	Return @@ERROR

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_GetExchangeRate] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_GetExchangeRate] TO [profit_role_datareader]
    AS [dbo];

