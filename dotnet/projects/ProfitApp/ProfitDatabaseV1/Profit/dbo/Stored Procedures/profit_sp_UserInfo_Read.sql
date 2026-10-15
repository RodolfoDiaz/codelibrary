CREATE PROCEDURE dbo.profit_sp_UserInfo_Read 
(	@pUserInfoId int,
	@pSidName varchar(25)
 )
AS
if Not(@pUserInfoId IS Null)
	Select
		[UserInfoId],
		[CompanyId],
		[FirstName],
		[LastName],
		[SidName],
		[Culture],
		[Role],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	UserInfo
	Where [UserInfoId] = @pUserInfoId
else
	Select
		[UserInfoId],
		[CompanyId],
		[FirstName],
		[LastName],
		[SidName],
		[Culture],
		[Role],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	UserInfo
	Where [SidName] = @pSidName

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_UserInfo_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_UserInfo_Read] TO [profit_role_datareader]
    AS [dbo];

