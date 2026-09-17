CREATE VIEW dbo.profit_vw_Employee
AS
SELECT     dbo.Employee.EmployeeId, dbo.Employee.CompanyId, dbo.Employee.DepartmentId, dbo.Employee.EmployeeProfileId, 
                      dbo.Company.Name AS Company, dbo.Department.Name AS Department, dbo.EmployeeProfile.Name AS EmployeeProfile, dbo.Employee.FirstName, 
                      dbo.Employee.LastName, dbo.Employee.Title, dbo.Employee.IdNumber, dbo.Employee.Address, dbo.Employee.City, dbo.Employee.StateId, 
                      dbo.Employee.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Employee.Gender, dbo.Employee.PostalCode, 
                      dbo.Employee.Phone, dbo.Employee.Fax, dbo.Employee.MobilePhone, dbo.Employee.EmailAddress, dbo.Employee.Birthday, dbo.Employee.IsActive, 
                      dbo.Employee.MaritalStatus, dbo.Employee.DateHired, dbo.Employee.Deductions, dbo.Employee.Salary, dbo.Employee.ContactName, 
                      dbo.Employee.ContactPhone, USER_NAME(dbo.Employee.InsertUser) AS InsertUser, dbo.Employee.InsertDate, 
                      USER_NAME(dbo.Employee.LastUpdateUser) AS LastUpdateUser, dbo.Employee.LastUpdateDate, dbo.Employee.RowInfo
FROM         dbo.Employee INNER JOIN
                      dbo.Company ON dbo.Employee.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Department ON dbo.Employee.DepartmentId = dbo.Department.DepartmentId AND 
                      dbo.Company.CompanyId = dbo.Department.CompanyId INNER JOIN
                      dbo.EmployeeProfile ON dbo.Employee.EmployeeProfileId = dbo.EmployeeProfile.EmployeeProfileId AND 
                      dbo.Company.CompanyId = dbo.EmployeeProfile.CompanyId INNER JOIN
                      dbo.State ON dbo.Employee.StateId = dbo.State.StateId INNER JOIN
                      dbo.Country ON dbo.Employee.CountryId = dbo.Country.CountryId AND dbo.State.CountryId = dbo.Country.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Employee] TO [profit_role_datareader]
    AS [dbo];

