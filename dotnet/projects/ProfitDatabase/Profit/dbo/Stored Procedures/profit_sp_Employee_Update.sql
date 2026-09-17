CREATE PROCEDURE dbo.profit_sp_Employee_Update
(	@pEmployeeId int,
	@pCompanyId int,
	@pDepartmentId int,
	@pEmployeeProfileId int,
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
	@pBirthday datetime,
	@pIsActive bit,
	@pMaritalStatus varchar(1),
	@pDateHired datetime, 
	@pDeductions money,
	@pSalary money,
	@pContactName varchar(50),
	@pContactPhone varchar(25),
	@pRowInfo timestamp
 )
AS
	Update Employee
	Set
		[CompanyId] = @pCompanyId, [DepartmentId] = @pDepartmentId, [EmployeeProfileId] = @pEmployeeProfileId, [FirstName] = @pFirstName, [LastName] = @pLastName, [Title] = @pTitle, [IdNumber] = @pIdNumber, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [Gender] = @pGender, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [MobilePhone] = @pMobilePhone, [EmailAddress] = @pEmailAddress, [Birthday] = @pBirthday, [IsActive] = @pIsActive, [MaritalStatus] = @pMaritalStatus, [DateHired] = @pDateHired, [Deductions] = @pDeductions, [Salary] = @pSalary, [ContactName] = @pContactName, [ContactPhone] = @pContactPhone, [LastUpdateUser] = user_id(), [LastUpdateDate]  = getdate()
	Where
		[EmployeeId] = @pEmployeeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Employee
		Where [EmployeeId] = @pEmployeeId

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
    ON OBJECT::[dbo].[profit_sp_Employee_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Employee_Update] TO [profit_role_fullaccess]
    AS [dbo];

