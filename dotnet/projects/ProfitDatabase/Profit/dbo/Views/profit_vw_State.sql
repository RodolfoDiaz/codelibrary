CREATE VIEW dbo.profit_vw_State
AS
SELECT     dbo.State.StateId, dbo.State.CountryId, dbo.Country.Name AS Country, dbo.State.Name, USER_NAME(dbo.State.InsertUser) 
                      AS InsertUser, dbo.State.InsertDate, USER_NAME(dbo.State.LastUpdateUser) AS LastUpdateUser, dbo.State.LastUpdateDate, dbo.State.RowInfo
FROM         dbo.State INNER JOIN
                      dbo.Country ON dbo.State.CountryId = dbo.Country.CountryId

GO
GRANT SELECT
    ON OBJECT::[dbo].[profit_vw_State] TO [profit_role_datareader]
    AS [dbo];

