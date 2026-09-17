CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Read
(	@pDocumentStatusId int
 )
AS
	Select
		[DocumentStatusId],
		[CompanyId], 
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	DocumentStatus
	Where [DocumentStatusId] = @pDocumentStatusId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_DocumentStatus_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_DocumentStatus_Read] TO [profit_role_datareader]
    AS [dbo];

