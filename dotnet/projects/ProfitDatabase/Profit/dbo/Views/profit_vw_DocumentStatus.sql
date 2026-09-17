CREATE VIEW dbo.profit_vw_DocumentStatus
AS
SELECT     dbo.DocumentStatus.DocumentStatusId, dbo.DocumentStatus.CompanyId, dbo.Company.Name AS Company, 
                      dbo.DocumentStatus.Name, USER_NAME(dbo.DocumentStatus.InsertUser) AS InsertUser, dbo.DocumentStatus.InsertDate, 
                      USER_NAME(dbo.DocumentStatus.LastUpdateUser) AS LastUpdateUser, dbo.DocumentStatus.LastUpdateDate, dbo.DocumentStatus.RowInfo
FROM         dbo.DocumentStatus INNER JOIN
                      dbo.Company ON dbo.DocumentStatus.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_DocumentStatus] TO [profit_role_datareader]
    AS [dbo];

