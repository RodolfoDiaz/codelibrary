CREATE VIEW dbo.profit_vw_Commission
AS
SELECT     dbo.Commission.CommissionId, dbo.Commission.CompanyId, dbo.Company.Name AS Company, dbo.Commission.EmployeeId, 
                      dbo.Employee.LastName AS EmployeeLN, dbo.Employee.FirstName AS EmployeeFN, dbo.Commission.DocumentId, dbo.ClientDocument.Amount AS DocAmount, 
                      dbo.Commission.DocDate, dbo.Commission.Amount, dbo.Commission.ExchangeRate, USER_NAME(dbo.Commission.InsertUser) AS InsertUser, 
                      dbo.Commission.InsertDate, USER_NAME(dbo.Commission.LastUpdateUser) AS LastUpdateUser, dbo.Commission.LastUpdateDate,
                      dbo.Commission.RowInfo
FROM         dbo.Commission INNER JOIN
                      dbo.Company ON dbo.Commission.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Employee ON dbo.Commission.EmployeeId = dbo.Employee.EmployeeId AND dbo.Company.CompanyId = dbo.Employee.CompanyId INNER JOIN
                      dbo.ClientDocument ON dbo.Commission.DocumentId = dbo.ClientDocument.DocumentId AND 
                      dbo.Company.CompanyId = dbo.ClientDocument.CompanyId AND dbo.Employee.EmployeeId = dbo.ClientDocument.EmployeeId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Commission] TO [profit_role_datareader]
    AS [dbo];

