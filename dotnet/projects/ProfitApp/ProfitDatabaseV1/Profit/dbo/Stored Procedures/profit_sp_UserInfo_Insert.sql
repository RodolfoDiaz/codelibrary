CREATE PROCEDURE dbo.profit_sp_UserInfo_Insert
(	@pUserInfoId int OUTPUT,
	@pCompanyId int,
	@pFirstName varchar (50),
	@pLastName varchar(50),
	@pCulture varchar(5),
	@pRole smallint
 )
AS
	Insert into UserInfo
		([CompanyId], [FirstName], [LastName], [SidName], [Culture], [Role], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pFirstName, @pLastName, suser_sname(), @pCulture, @pRole, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pUserInfoId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_UserInfo_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_UserInfo_Insert] TO [profit_role_fullaccess]
    AS [dbo];

