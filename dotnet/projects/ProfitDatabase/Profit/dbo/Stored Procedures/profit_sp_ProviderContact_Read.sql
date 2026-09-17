CREATE PROCEDURE dbo.profit_sp_ProviderContact_Read 
(	@pContactId int
 )
AS
	Select
		[ContactId],
		[ProviderId],
		[CompanyId],
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber],
		[City],
		[Address], 
		[StateId], 
		[CountryId], 
		[Gender], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[MobilePhone], 
		[EmailAddress], 
		[Birthday], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderContact
	Where [ContactId] = @pContactId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Read] TO [profit_role_datareader]
    AS [dbo];

