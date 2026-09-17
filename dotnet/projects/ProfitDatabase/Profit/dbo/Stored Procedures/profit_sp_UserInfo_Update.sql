CREATE PROCEDURE dbo.profit_sp_UserInfo_Update
(	@pUserInfoId int,
	@pCompanyId int,
	@pFirstName varchar (50),
	@pLastName varchar(50),
	@pCulture varchar(5),
	@pRole smallint,
	@pRowInfo timestamp
 )
AS
	Update UserInfo
	Set
		[CompanyId] = @pCompanyId,
		[FirstName] = @pFirstName, 
		[LastName] = @pLastName,
		[Culture] = @pCulture,
		[Role] = @pRole,
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[UserInfoId] = @pUserInfoId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From UserInfo
		Where [UserInfoId] = @pUserInfoId

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
    ON OBJECT::[dbo].[profit_sp_UserInfo_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_UserInfo_Update] TO [profit_role_fullaccess]
    AS [dbo];

