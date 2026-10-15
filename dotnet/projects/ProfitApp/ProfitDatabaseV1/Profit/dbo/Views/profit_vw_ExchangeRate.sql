CREATE VIEW dbo.profit_vw_ExchangeRate
AS
SELECT     dbo.ExchangeRate.ExchangeRateId, dbo.ExchangeRate.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ExchangeRate.RefreshDate, dbo.ExchangeRate.Amount, USER_NAME(dbo.ExchangeRate.InsertUser) AS InsertUser, 
                      dbo.ExchangeRate.InsertDate, USER_NAME(dbo.ExchangeRate.LastUpdateUser) AS LastUpdateUser, dbo.ExchangeRate.LastUpdateDate, 
                      dbo.ExchangeRate.RowInfo
FROM         dbo.ExchangeRate INNER JOIN
                      dbo.Company ON dbo.ExchangeRate.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ExchangeRate] TO [profit_role_datareader]
    AS [dbo];

