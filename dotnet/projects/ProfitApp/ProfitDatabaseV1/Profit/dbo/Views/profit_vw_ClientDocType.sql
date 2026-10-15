
CREATE VIEW dbo.profit_vw_ClientDocType
AS
SELECT     dbo.ClientDocType.DocTypeId, dbo.ClientDocType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientDocType.Name, dbo.ClientDocType.IsDebit, USER_NAME(dbo.ClientDocType.InsertUser) AS InsertUser, 
                      dbo.ClientDocType.InsertDate, USER_NAME(dbo.ClientDocType.LastUpdateUser) AS LastUpdateUser, dbo.ClientDocType.LastUpdateDate, 
                      dbo.ClientDocType.RowInfo
FROM         dbo.ClientDocType INNER JOIN
                      dbo.Company ON dbo.ClientDocType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ClientDocType] TO [profit_role_datareader]
    AS [dbo];

