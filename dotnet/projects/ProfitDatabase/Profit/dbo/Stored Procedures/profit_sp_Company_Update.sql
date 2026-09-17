CREATE PROCEDURE dbo.profit_sp_Company_Update
(	@pCompanyId int,
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
	@pForeignName varchar(25),
	@pRowInfo timestamp
 )
AS
	Update Company
	Set
		[Name] = @pName, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [Website] = @pWebsite, [EmailAddress] = @pEmailAddress, [Tax] = @pTax, [Discount] = @pDiscount, [MultipleCurrency] = @pMultipleCurrency, [Culture] = @pCulture, [LocalSign] = @pLocalSign, [ForeignSign] = @pForeignSign, [LocalName] = @pLocalName, [ForeignName] = @pForeignName, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
	Where
		[CompanyId] = @pCompanyId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Company
		Where [CompanyId] = @pCompanyId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Company_Update] TO [profit_role_fullaccess]
    AS [dbo];

