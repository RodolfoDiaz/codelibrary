CREATE PROCEDURE dbo.profit_sp_Provider_Read
(	@pProviderId int
 )
AS
	Select
		[ProviderId], 
		[CompanyId], 
		[PrimaryContactId], 
		[Name], 
		[Address], 
		[City],
		[StateId], 
		[CountryId], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[Website], 
		[EmailAddress], 
		[CreditLimit], 
		[Balance], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	Provider
	Where [ProviderId] = @pProviderId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Provider_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Provider_Read] TO [profit_role_datareader]
    AS [dbo];

