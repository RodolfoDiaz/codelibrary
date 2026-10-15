CREATE VIEW dbo.profit_vw_Department
AS
SELECT     dbo.Department.CompanyId, dbo.Department.DepartmentId, dbo.Company.Name AS Company, dbo.Department.Name, 
                      dbo.Department.Location, USER_NAME(dbo.Department.InsertUser) AS InsertUser, dbo.Department.InsertDate, 
                      USER_NAME(dbo.Department.LastUpdateUser) AS LastUpdateUser, dbo.Department.LastUpdateDate, dbo.Department.RowInfo
FROM         dbo.Department INNER JOIN
                      dbo.Company ON dbo.Department.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Department] TO [profit_role_datareader]
    AS [dbo];

