CREATE VIEW dbo.profit_vw_Product
AS
SELECT     dbo.Product.ProductId, dbo.Product.CompanyId, dbo.Company.Name AS Company, dbo.Product.ProductTypeId, 
                      dbo.Product.ProviderId, dbo.Product.WarehouseId, dbo.ProductType.Name AS ProductType, dbo.Provider.Name AS Provider, 
                      dbo.Warehouse.Name AS Warehouse, dbo.Product.Name, dbo.Product.UnitsInStock, dbo.Product.UnitPrice, dbo.Product.IsActive, 
                      USER_NAME(dbo.Product.InsertUser) AS InsertUser, dbo.Product.InsertDate, USER_NAME(dbo.Product.LastUpdateUser) AS LastUpdateUser, 
                      dbo.Product.LastUpdateDate, dbo.Product.RowInfo
FROM         dbo.Product INNER JOIN
                      dbo.Company ON dbo.Product.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.ProductType ON dbo.Product.ProductTypeId = dbo.ProductType.ProductTypeId AND 
                      dbo.Company.CompanyId = dbo.ProductType.CompanyId INNER JOIN
                      dbo.Provider ON dbo.Product.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId INNER JOIN
                      dbo.Warehouse ON dbo.Product.WarehouseId = dbo.Warehouse.WarehouseId AND dbo.Company.CompanyId = dbo.Warehouse.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Product] TO [profit_role_datareader]
    AS [dbo];

