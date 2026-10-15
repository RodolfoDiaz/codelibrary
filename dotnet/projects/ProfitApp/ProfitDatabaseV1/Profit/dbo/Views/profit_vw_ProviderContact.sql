CREATE VIEW dbo.profit_vw_ProviderContact
AS
SELECT     dbo.ProviderContact.ContactId, dbo.ProviderContact.ProviderId, dbo.ProviderContact.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderContact.FirstName, dbo.ProviderContact.LastName, dbo.ProviderContact.Title, dbo.ProviderContact.IdNumber, dbo.ProviderContact.Address, 
                      dbo.ProviderContact.City, dbo.ProviderContact.StateId, dbo.ProviderContact.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, 
                      dbo.ProviderContact.Gender, dbo.ProviderContact.PostalCode, dbo.ProviderContact.Phone, dbo.ProviderContact.Fax, 
                      dbo.ProviderContact.MobilePhone, dbo.ProviderContact.EmailAddress, dbo.ProviderContact.Birthday, dbo.ProviderContact.IsActive, 
                      USER_NAME(dbo.ProviderContact.InsertUser) AS InsertUser, dbo.ProviderContact.InsertDate, USER_NAME(dbo.ProviderContact.LastUpdateUser) 
                      AS LastUpdateUser, dbo.ProviderContact.LastUpdateDate, dbo.ProviderContact.RowInfo
FROM         dbo.ProviderContact INNER JOIN
                      dbo.Company ON dbo.ProviderContact.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.ProviderContact.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.ProviderContact.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_ProviderContact] TO [profit_role_datareader]
    AS [dbo];

