CREATE VIEW dbo.profit_vw_Provider
AS
SELECT     dbo.Provider.ProviderId, dbo.Provider.CompanyId, dbo.Company.Name AS Company, dbo.Provider.Name, dbo.Provider.Address, 
                      dbo.Provider.City, dbo.Provider.StateId, dbo.Provider.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, 
                      dbo.Provider.PrimaryContactId, dbo.Provider.PostalCode, dbo.Provider.Phone, dbo.Provider.Fax, dbo.Provider.Website, dbo.Provider.EmailAddress, 
                      dbo.Provider.CreditLimit, dbo.Provider.Balance, dbo.Provider.IsActive, USER_NAME(dbo.Provider.InsertUser) AS InsertUser, dbo.Provider.InsertDate, 
                      USER_NAME(dbo.Provider.LastUpdateUser) AS LastUpdateUser, dbo.Provider.LastUpdateDate, dbo.Provider.RowInfo
FROM         dbo.Provider INNER JOIN
                      dbo.Company ON dbo.Provider.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.Provider.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Provider.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Provider] TO [profit_role_datareader]
    AS [dbo];

