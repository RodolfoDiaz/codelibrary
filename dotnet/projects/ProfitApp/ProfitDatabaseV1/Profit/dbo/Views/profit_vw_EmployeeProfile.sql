CREATE VIEW dbo.profit_vw_EmployeeProfile
AS
SELECT     dbo.EmployeeProfile.EmployeeProfileId, dbo.EmployeeProfile.CompanyId, dbo.Company.Name AS Company, 
                      dbo.EmployeeProfile.Name, dbo.EmployeeProfile.Commission, USER_NAME(dbo.EmployeeProfile.InsertUser) AS InsertUser, 
                      dbo.EmployeeProfile.InsertDate, USER_NAME(dbo.EmployeeProfile.LastUpdateUser) AS LastUpdateUser, dbo.EmployeeProfile.LastUpdateDate, 
                      dbo.EmployeeProfile.RowInfo
FROM         dbo.EmployeeProfile INNER JOIN
                      dbo.Company ON dbo.EmployeeProfile.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_EmployeeProfile] TO [profit_role_datareader]
    AS [dbo];

