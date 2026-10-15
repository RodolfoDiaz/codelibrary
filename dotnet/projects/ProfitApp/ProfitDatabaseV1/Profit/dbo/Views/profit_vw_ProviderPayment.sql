CREATE VIEW dbo.profit_vw_ProviderPayment
AS
SELECT     dbo.ProviderPayment.ProviderPaymentId, dbo.ProviderPayment.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderPayment.ProviderId, dbo.Provider.Name AS Provider, dbo.ProviderPayment.DebitDocumentId, dbo.ProviderPayment.CreditDocumentId, 
                      dbo.ProviderPayment.MoneyTypeId, dbo.MoneyType.Name AS MoneyType, dbo.ProviderPayment.PaymentDate, dbo.ProviderPayment.Amount, 
                      dbo.ProviderPayment.Remarks, dbo.ProviderPayment.ExchangeRate, USER_NAME(dbo.ProviderPayment.InsertUser) AS InsertUser, 
                      dbo.ProviderPayment.InsertDate, USER_NAME(dbo.ProviderPayment.LastUpdateUser) AS LastUpdateUser, dbo.ProviderPayment.LastUpdateDate,
                      dbo.ProviderPayment.RowInfo
FROM         dbo.ProviderPayment INNER JOIN
                      dbo.Company ON dbo.ProviderPayment.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Provider ON dbo.ProviderPayment.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId INNER JOIN
                      dbo.MoneyType ON dbo.ProviderPayment.MoneyTypeId = dbo.MoneyType.MoneyTypeId AND 
                      dbo.Company.CompanyId = dbo.MoneyType.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ProviderPayment] TO [profit_role_datareader]
    AS [dbo];

