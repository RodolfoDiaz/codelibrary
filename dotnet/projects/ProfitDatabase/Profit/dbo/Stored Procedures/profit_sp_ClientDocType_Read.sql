CREATE PROCEDURE dbo.profit_sp_ClientDocType_Read
(	@pDocTypeId int
 )
AS
	Select
		[DocTypeId],
		[CompanyId], 
		[Name],
		[IsDebit],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	ClientDocType
	Where
		[DocTypeId] = @pDocTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocType_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocType_Read] TO [profit_role_datareader]
    AS [dbo];

