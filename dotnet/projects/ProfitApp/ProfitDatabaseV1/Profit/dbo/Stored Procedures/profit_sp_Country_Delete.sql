CREATE PROCEDURE dbo.profit_sp_Country_Delete 
(	@pCountryId int 
 )
AS
	Delete Country
	Where
		[CountryId] = @pCountryId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Country_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Country_Delete] TO [profit_role_fullaccess]
    AS [dbo];

