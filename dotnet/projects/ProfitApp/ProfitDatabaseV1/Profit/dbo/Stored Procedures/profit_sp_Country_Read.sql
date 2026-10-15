CREATE PROCEDURE dbo.profit_sp_Country_Read
(	@pCountryId int
 )
AS
	Select
		[CountryId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Country
	Where [CountryId] = @pCountryId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Country_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Country_Read] TO [profit_role_datareader]
    AS [dbo];

