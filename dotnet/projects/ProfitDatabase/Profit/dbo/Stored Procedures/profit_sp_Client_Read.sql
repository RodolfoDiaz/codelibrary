CREATE PROCEDURE dbo.profit_sp_Client_Read
(	@pClientId int
 )
AS
	Select
		[ClientId], 
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
	From	Client
	Where [ClientId] = @pClientId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Read] TO [profit_role_datareader]
    AS [dbo];

