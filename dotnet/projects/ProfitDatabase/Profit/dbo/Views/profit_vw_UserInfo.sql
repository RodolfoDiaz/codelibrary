CREATE VIEW dbo.profit_vw_UserInfo
AS
SELECT     dbo.UserInfo.UserInfoId, dbo.UserInfo.CompanyId, dbo.Company.Name AS Company, dbo.UserInfo.FirstName, dbo.UserInfo.LastName, 
                      dbo.UserInfo.SidName, dbo.UserInfo.Culture, dbo.UserInfo.Role, USER_NAME(dbo.UserInfo.InsertUser) AS InsertUser, dbo.UserInfo.InsertDate, 
                      USER_NAME(dbo.UserInfo.LastUpdateUser) AS LastUpdateUser, dbo.UserInfo.LastUpdateDate, dbo.UserInfo.RowInfo
FROM         dbo.UserInfo INNER JOIN
                      dbo.Company ON dbo.UserInfo.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_UserInfo] TO [profit_role_datareader]
    AS [dbo];

