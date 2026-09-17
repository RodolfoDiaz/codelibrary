CREATE VIEW dbo.profit_vw_Company
AS
SELECT     dbo.Company.CompanyId, dbo.Company.Name, dbo.Company.Address, dbo.Company.City, dbo.Company.StateId, 
                      dbo.Company.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Company.PostalCode, dbo.Company.Phone, dbo.Company.Fax, 
                      dbo.Company.Website, dbo.Company.EmailAddress, dbo.Company.Tax, dbo.Company.Discount, dbo.Company.MultipleCurrency, 
                      dbo.Company.Culture, dbo.Company.LocalSign, dbo.Company.ForeignSign, dbo.Company.LocalName, dbo.Company.ForeignName, 
                      USER_NAME(dbo.Company.InsertUser) AS InsertUser, dbo.Company.InsertDate, USER_NAME(dbo.Company.LastUpdateUser) AS LastUpdateUser, 
                      dbo.Company.LastUpdateDate, dbo.Company.RowInfo
FROM         dbo.Company INNER JOIN
                      dbo.Country ON dbo.Company.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Company.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Company] TO [profit_role_datareader]
    AS [dbo];

