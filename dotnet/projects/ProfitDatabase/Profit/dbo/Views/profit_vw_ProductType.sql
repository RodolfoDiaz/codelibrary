CREATE VIEW dbo.profit_vw_ProductType
AS
SELECT     dbo.ProductType.ProductTypeId, dbo.ProductType.CompanyId, dbo.Company.Name AS Company, dbo.ProductType.Name, 
                      USER_NAME(dbo.ProductType.InsertUser) AS InsertUser, dbo.ProductType.InsertDate, USER_NAME(dbo.ProductType.LastUpdateUser) AS LastUpdateUser, 
                      dbo.ProductType.LastUpdateDate, dbo.ProductType.RowInfo
FROM         dbo.ProductType INNER JOIN
                      dbo.Company ON dbo.ProductType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ProductType] TO [profit_role_datareader]
    AS [dbo];

