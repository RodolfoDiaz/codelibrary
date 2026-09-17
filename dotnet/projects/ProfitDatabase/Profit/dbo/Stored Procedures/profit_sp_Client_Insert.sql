CREATE PROCEDURE dbo.profit_sp_Client_Insert 
(	@pClientId int OUTPUT,
	@pCompanyId int ,  
	@pPrimaryContactId int,
	@pName varchar(50),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,	
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pCreditLimit money
 )
AS
	Insert into Client
		([CompanyId], [PrimaryContactId], [Name], [Address], [City], [StateId], [CountryId], [PostalCode], [Phone], [Fax], [Website], [EmailAddress], [CreditLimit], [Balance], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pPrimaryContactId, @pName, @pAddress, @pCity, @pStateId, @pCountryId, @pPostalCode, @pPhone, @pFax, @pWebsite, @pEmailAddress, @pCreditLimit, 0, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pClientId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Client_Insert] TO [profit_role_fullaccess]
    AS [dbo];

