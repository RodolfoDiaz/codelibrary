CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Update
(	@pEmployeeProfileId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pCommission money,
	@pRowInfo timestamp
 )
AS
	Update EmployeeProfile
	Set
		[CompanyId] = @pCompanyId, [Name] = @pName, [Commission] = @pCommission, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
	Where 
		[EmployeeProfileId] = @pEmployeeProfileId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From EmployeeProfile
		Where [EmployeeProfileId] = @pEmployeeProfileId

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
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_EmployeeProfile_Update] TO [profit_role_fullaccess]
    AS [dbo];

