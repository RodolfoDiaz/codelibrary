CREATE PROCEDURE dbo.profit_sp_Company_Insert 
(	@pCompanyId int OUTPUT,
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
	@pTax money,
	@pDiscount money,
	@pMultipleCurrency bit,
	@pCulture varchar(5),
	@pLocalSign varchar(1),
	@pForeignSign varchar(1),
	@pLocalName varchar(25),
	@pForeignName varchar(25)
 )
AS
	Insert into Company
		([Name], [Address], [City], [StateId], [CountryId], [PostalCode], [Phone], [Fax], [Website], [EmailAddress], [Tax], [Discount], [MultipleCurrency], [Culture], [LocalSign], [ForeignSign], [LocalName], [ForeignName], [InsertUser], [InsertDate])
	Values
		(@pName, @pAddress, @pCity, @pStateId, @pCountryId, @pPostalCode, @pPhone, @pFax, @pWebsite, @pEmailAddress, @pTax, @pDiscount, @pMultipleCurrency, @pCulture, @pLocalSign, @pForeignSign, @pLocalName, @pForeignName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pCompanyId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Insert] TO [profit_role_fullaccess]
    AS [dbo];

