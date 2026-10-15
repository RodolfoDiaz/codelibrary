CREATE VIEW dbo.profit_vw_Country
AS
SELECT     CountryId, Name, USER_NAME(InsertUser) AS InsertUser, InsertDate, USER_NAME(LastUpdateUser) AS LastUpdateUser, LastUpdateDate, 
                      RowInfo
FROM         dbo.Country

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_Country] TO [profit_role_datareader]
    AS [dbo];

