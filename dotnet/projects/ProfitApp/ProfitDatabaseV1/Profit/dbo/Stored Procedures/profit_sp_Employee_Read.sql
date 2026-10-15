CREATE PROCEDURE dbo.profit_sp_Employee_Read
(	@pEmployeeId int
 )
AS
	Select 
		[EmployeeId], 
		[CompanyId], 
		[DepartmentId], 
		[EmployeeProfileId], 
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber], 
		[Address], 
		[City],
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
		[MaritalStatus], 
		[DateHired], 
		[Deductions], 
		[Salary], 
		[ContactName], 
		[ContactPhone], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Employee
	Where [EmployeeId] = @pEmployeeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Employee_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Employee_Read] TO [profit_role_datareader]
    AS [dbo];

