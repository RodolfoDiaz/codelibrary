CREATE VIEW dbo.profit_vw_MoneyType
AS
SELECT     dbo.MoneyType.MoneyTypeId, dbo.MoneyType.CompanyId, dbo.Company.Name AS Company, dbo.MoneyType.Name, 
                      USER_NAME(dbo.MoneyType.InsertUser) AS InsertUser, dbo.MoneyType.InsertDate, USER_NAME(dbo.MoneyType.LastUpdateUser) AS LastUpdateUser, 
                      dbo.MoneyType.LastUpdateDate, dbo.MoneyType.RowInfo
FROM         dbo.MoneyType INNER JOIN
                      dbo.Company ON dbo.MoneyType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_MoneyType] TO [profit_role_datareader]
    AS [dbo];

