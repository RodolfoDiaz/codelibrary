CREATE PROCEDURE dbo.profit_sp_ProviderContact_Insert 
(	@pContactId int OUTPUT,
	@pProviderId int, 
	@pCompanyId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime
 )
AS
	Insert into ProviderContact
		([ProviderId], [CompanyId], [FirstName], [LastName], [Title], [IdNumber], [Address], [City], [StateId], [CountryId], [Gender], [PostalCode], [Phone], [Fax], [MobilePhone], [EmailAddress], [Birthday], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pProviderId, @pCompanyId, @pFirstName, @pLastName, @pTitle, @pIdNumber, @pAddress, @pCity, @pStateId, @pCountryId, @pGender, @pPostalCode, @pPhone, @pFax, @pMobilePhone, @pEmailAddress, @pBirthday, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pContactId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderContact_Insert] TO [profit_role_fullaccess]
    AS [dbo];

