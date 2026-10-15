CREATE PROCEDURE dbo.profit_sp_ClientContact_Read
(	@pContactId int
 )
AS
	Select
		[ContactId],
		[ClientId],
		[CompanyId], 
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber],
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
	From	ClientContact
	Where  [ContactId] = @pContactId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientContact_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientContact_Read] TO [profit_role_datareader]
    AS [dbo];

