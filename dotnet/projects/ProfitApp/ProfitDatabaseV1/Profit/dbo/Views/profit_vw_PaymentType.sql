CREATE VIEW dbo.profit_vw_PaymentType
AS
SELECT     dbo.PaymentType.PaymentTypeId, dbo.PaymentType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.PaymentType.Name, dbo.PaymentType.Period, USER_NAME(dbo.PaymentType.InsertUser) AS InsertUser, dbo.PaymentType.InsertDate, 
                      USER_NAME(dbo.PaymentType.LastUpdateUser) AS LastUpdateUser, dbo.PaymentType.LastUpdateDate, dbo.PaymentType.RowInfo
FROM         dbo.PaymentType INNER JOIN
                      dbo.Company ON dbo.PaymentType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_PaymentType] TO [profit_role_datareader]
    AS [dbo];

