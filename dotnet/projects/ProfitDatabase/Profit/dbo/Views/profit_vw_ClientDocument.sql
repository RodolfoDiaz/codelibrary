CREATE VIEW dbo.profit_vw_ClientDocument
AS
SELECT     dbo.ClientDocument.DocumentId, dbo.ClientDocument.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientDocument.DocTypeId, dbo.ClientDocument.DocumentStatusId, dbo.ClientDocument.ClientId, dbo.ClientDocument.EmployeeId, 
                      dbo.ClientDocument.PaymentTypeId, dbo.ClientDocType.Name AS DocType, dbo.DocumentStatus.Name AS Status, dbo.Client.Name AS Client, 
                      dbo.PaymentType.Name AS PaymentType, dbo.Employee.LastName + ', ' + dbo.Employee.FirstName AS Employee, dbo.ClientDocument.Commission, 
                      dbo.ClientDocument.CommissionPaid, dbo.ClientDocument.DocConsecutive, dbo.ClientDocument.DocDate, dbo.ClientDocument.OtherCost, 
                      dbo.ClientDocument.Discount, dbo.ClientDocument.Tax, dbo.ClientDocument.Amount, dbo.ClientDocument.Remarks, 
                      dbo.ClientDocument.ExchangeRate, USER_NAME(dbo.ClientDocument.InsertUser) AS InsertUser, dbo.ClientDocument.InsertDate, 
                      USER_NAME(dbo.ClientDocument.LastUpdateUser) AS LastUpdateUser, dbo.ClientDocument.LastUpdateDate, dbo.ClientDocument.RowInfo
FROM         dbo.ClientDocument INNER JOIN
                      dbo.ClientDocType ON dbo.ClientDocument.DocTypeId = dbo.ClientDocType.DocTypeId INNER JOIN
                      dbo.DocumentStatus ON dbo.ClientDocument.DocumentStatusId = dbo.DocumentStatus.DocumentStatusId INNER JOIN
                      dbo.Client ON dbo.ClientDocument.ClientId = dbo.Client.ClientId INNER JOIN
                      dbo.PaymentType ON dbo.ClientDocument.PaymentTypeId = dbo.PaymentType.PaymentTypeId INNER JOIN
                      dbo.Employee ON dbo.ClientDocument.EmployeeId = dbo.Employee.EmployeeId INNER JOIN
                      dbo.Company ON dbo.ClientDocument.CompanyId = dbo.Company.CompanyId AND dbo.ClientDocType.CompanyId = dbo.Company.CompanyId AND 
                      dbo.Client.CompanyId = dbo.Company.CompanyId AND dbo.DocumentStatus.CompanyId = dbo.Company.CompanyId AND 
                      dbo.Employee.CompanyId = dbo.Company.CompanyId AND dbo.PaymentType.CompanyId = dbo.Company.CompanyId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ClientDocument] TO [profit_role_datareader]
    AS [dbo];

