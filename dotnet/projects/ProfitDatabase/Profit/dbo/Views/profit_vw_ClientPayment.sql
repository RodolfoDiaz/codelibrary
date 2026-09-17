CREATE VIEW dbo.profit_vw_ClientPayment
AS
SELECT     dbo.ClientPayment.ClientPaymentId, dbo.ClientPayment.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientPayment.ClientId, dbo.Client.Name AS Client, dbo.ClientPayment.CreditDocumentId, dbo.ClientPayment.DebitDocumentId, 
                      dbo.ClientPayment.MoneyTypeId, dbo.MoneyType.Name AS MoneyType, dbo.ClientPayment.PaymentDate, dbo.ClientPayment.Amount, 
                      dbo.ClientPayment.Remarks, dbo.ClientPayment.ExchangeRate, USER_NAME(dbo.ClientPayment.InsertUser) AS InsertUser, 
                      dbo.ClientPayment.InsertDate, USER_NAME(dbo.ClientPayment.LastUpdateUser) AS LastUpdateUser, dbo.ClientPayment.LastUpdateDate,
                      dbo.ClientPayment.RowInfo
FROM         dbo.ClientPayment INNER JOIN
                      dbo.Company ON dbo.ClientPayment.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Client ON dbo.ClientPayment.ClientId = dbo.Client.ClientId AND dbo.Company.CompanyId = dbo.Client.CompanyId INNER JOIN
                      dbo.MoneyType ON dbo.ClientPayment.MoneyTypeId = dbo.MoneyType.MoneyTypeId AND 
                      dbo.Company.CompanyId = dbo.MoneyType.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ClientPayment] TO [profit_role_datareader]
    AS [dbo];

