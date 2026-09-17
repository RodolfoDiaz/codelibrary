
CREATE PROCEDURE dbo.profit_sp_Company_Delete 
(	@pCompanyId int
 )
AS
	Delete Company
	Where
		[CompanyId] = @pCompanyId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Delete] TO [profit_role_fullaccess]
    AS [dbo];

