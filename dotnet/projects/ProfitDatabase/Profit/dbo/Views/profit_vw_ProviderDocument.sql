CREATE VIEW dbo.profit_vw_ProviderDocument
AS
SELECT     dbo.ProviderDocument.DocumentId, dbo.ProviderDocument.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderDocument.DocTypeId, dbo.ProviderDocument.DocumentStatusId, dbo.ProviderDocument.ProviderId, 
                      dbo.ProviderDocument.PaymentTypeId, dbo.ProviderDocType.Name AS DocType, dbo.DocumentStatus.Name AS Status, 
                      dbo.Provider.Name AS Provider, dbo.PaymentType.Name AS PaymentType, dbo.ProviderDocument.DocDate, dbo.ProviderDocument.DocConsecutive, 
                      dbo.ProviderDocument.OtherCost, dbo.ProviderDocument.Discount, dbo.ProviderDocument.Tax, dbo.ProviderDocument.Amount, 
                      dbo.ProviderDocument.Remarks, dbo.ProviderDocument.ExchangeRate, USER_NAME(dbo.ProviderDocument.InsertUser) AS InsertUser, 
                      dbo.ProviderDocument.InsertDate, USER_NAME(dbo.ProviderDocument.LastUpdateUser) AS LastUpdateUser, dbo.ProviderDocument.LastUpdateDate, 
                      dbo.ProviderDocument.RowInfo
FROM         dbo.ProviderDocument INNER JOIN
                      dbo.Company ON dbo.ProviderDocument.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.ProviderDocType ON dbo.ProviderDocument.DocTypeId = dbo.ProviderDocType.DocTypeId AND 
                      dbo.Company.CompanyId = dbo.ProviderDocType.CompanyId INNER JOIN
                      dbo.DocumentStatus ON dbo.ProviderDocument.DocumentStatusId = dbo.DocumentStatus.DocumentStatusId AND 
                      dbo.Company.CompanyId = dbo.DocumentStatus.CompanyId INNER JOIN
                      dbo.PaymentType ON dbo.ProviderDocument.PaymentTypeId = dbo.PaymentType.PaymentTypeId AND 
                      dbo.Company.CompanyId = dbo.PaymentType.CompanyId INNER JOIN
                      dbo.Provider ON dbo.ProviderDocument.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ProviderDocument] TO [profit_role_datareader]
    AS [dbo];

