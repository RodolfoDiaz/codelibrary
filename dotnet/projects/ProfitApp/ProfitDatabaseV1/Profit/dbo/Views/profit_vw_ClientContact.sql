CREATE VIEW dbo.profit_vw_ClientContact
AS
SELECT     dbo.ClientContact.ContactId, dbo.ClientContact.ClientId, dbo.ClientContact.CompanyId, dbo.Company.Name AS Company, dbo.ClientContact.FirstName, 
                      dbo.ClientContact.LastName, dbo.ClientContact.Title, dbo.ClientContact.IdNumber, dbo.ClientContact.Address, dbo.ClientContact.City, 
                      dbo.ClientContact.StateId, dbo.ClientContact.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.ClientContact.Gender, 
                      dbo.ClientContact.PostalCode, dbo.ClientContact.Phone, dbo.ClientContact.Fax, dbo.ClientContact.MobilePhone, dbo.ClientContact.EmailAddress, 
                      dbo.ClientContact.Birthday, dbo.ClientContact.IsActive, USER_NAME(dbo.ClientContact.InsertUser) AS InsertUser, dbo.ClientContact.InsertDate, 
                      USER_NAME(dbo.ClientContact.LastUpdateUser) AS LastUpdateUser, dbo.ClientContact.LastUpdateDate, dbo.ClientContact.RowInfo
FROM         dbo.ClientContact INNER JOIN
                      dbo.Company ON dbo.ClientContact.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.ClientContact.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.ClientContact.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ClientContact] TO [profit_role_datareader]
    AS [dbo];

