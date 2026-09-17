CREATE VIEW dbo.profit_vw_Warehouse
AS
SELECT     dbo.Warehouse.WarehouseId, dbo.Warehouse.CompanyId, dbo.Company.Name AS Company, dbo.Warehouse.Name, 
                      dbo.Warehouse.Location, USER_NAME(dbo.Warehouse.InsertUser) AS InsertUser, dbo.Warehouse.InsertDate, 
                      USER_NAME(dbo.Warehouse.LastUpdateUser) AS LastUpdateUser, dbo.Warehouse.LastUpdateDate, dbo.Warehouse.RowInfo
FROM         dbo.Warehouse INNER JOIN
                      dbo.Company ON dbo.Warehouse.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Warehouse] TO [profit_role_datareader]
    AS [dbo];

