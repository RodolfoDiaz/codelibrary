CREATE VIEW dbo.profit_vw_ProviderDocType
AS
SELECT     dbo.ProviderDocType.DocTypeId, dbo.ProviderDocType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderDocType.Name, dbo.ProviderDocType.IsDebit, USER_NAME(dbo.ProviderDocType.InsertUser) AS InsertUser, 
                      dbo.ProviderDocType.InsertDate, USER_NAME(dbo.ProviderDocType.LastUpdateUser) AS LastUpdateUser, dbo.ProviderDocType.LastUpdateDate,
                      dbo.ProviderDocType.RowInfo
FROM         dbo.ProviderDocType INNER JOIN
                      dbo.Company ON dbo.ProviderDocType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ProviderDocType] TO [profit_role_datareader]
    AS [dbo];

