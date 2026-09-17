CREATE VIEW dbo.profit_vw_ClientDocDetail
AS
SELECT     dbo.ClientDocDetail.DocumentId, dbo.ClientDocDetail.ProductId, dbo.ClientDocDetail.CompanyId, 
                      dbo.Company.Name AS Company, dbo.Product.Name AS Product, dbo.ClientDocDetail.Quantity, dbo.ClientDocDetail.Tax, 
                      dbo.ClientDocDetail.Discount, dbo.ClientDocDetail.UnitPrice, dbo.ClientDocDetail.RowInfo
FROM         dbo.ClientDocDetail INNER JOIN
                      dbo.Company ON dbo.ClientDocDetail.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Product ON dbo.ClientDocDetail.ProductId = dbo.Product.ProductId AND dbo.Company.CompanyId = dbo.Product.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ClientDocDetail] TO [profit_role_datareader]
    AS [dbo];

