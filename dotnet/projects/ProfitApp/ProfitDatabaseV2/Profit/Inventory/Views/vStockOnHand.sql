
CREATE   VIEW [Inventory].[vStockOnHand]
AS
SELECT
    B.CompanyId,
    B.ProductId,
    P.SKU,
    P.Name AS ProductName,
    B.WarehouseId,
    W.Code AS WarehouseCode,
    W.Name AS WarehouseName,
    B.QuantityOnHand,
    B.QuantityReserved,
    B.QuantityOnHand - B.QuantityReserved AS QuantityAvailable,
    B.AverageCost
FROM [Inventory].[InventoryBalances] B
INNER JOIN [Inventory].[Products] P
    ON P.CompanyId = B.CompanyId AND P.ProductId = B.ProductId
INNER JOIN [Inventory].[Warehouses] W
    ON W.CompanyId = B.CompanyId AND W.WarehouseId = B.WarehouseId;

GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_ReadOnly]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_Sales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_Procurement]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_Inventory]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_Finance]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Inventory].[vStockOnHand] TO [ERP_Auditor]
    AS [dbo];

