CREATE VIEW dbo.profit_vw_Client
AS
SELECT     dbo.Client.ClientId, dbo.Client.CompanyId, dbo.Company.Name AS Company, dbo.Client.Name, dbo.Client.Address, dbo.Client.City, 
                      dbo.Client.StateId, dbo.Client.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Client.PrimaryContactId, dbo.Client.PostalCode, 
                      dbo.Client.Phone, dbo.Client.Fax, dbo.Client.Website, dbo.Client.EmailAddress, dbo.Client.CreditLimit, dbo.Client.Balance, dbo.Client.IsActive, 
                      USER_NAME(dbo.Client.InsertUser) AS InsertUser, dbo.Client.InsertDate, USER_NAME(dbo.Client.LastUpdateUser) AS LastUpdateUser, dbo.Client.LastUpdateDate, 
                      dbo.Client.RowInfo
FROM         dbo.Client INNER JOIN
                      dbo.Company ON dbo.Client.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.Client.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Client.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Client] TO [profit_role_datareader]
    AS [dbo];

