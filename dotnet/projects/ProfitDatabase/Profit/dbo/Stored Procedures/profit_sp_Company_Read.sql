CREATE PROCEDURE dbo.profit_sp_Company_Read
(	@pCompanyId int
 )
AS
	Select 
		[CompanyId], 
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
		[Tax], 
		[Discount], 
		[MultipleCurrency],
		[Culture],
		[LocalSign], 
		[ForeignSign], 
		[LocalName], 
		[ForeignName],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Company
	Where [CompanyId] = @pCompanyId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Read] TO [profit_role_datareader]
    AS [dbo];

