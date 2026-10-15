CREATE PROCEDURE dbo.profit_sp_ProductType_Read
(	@pProductTypeId int
 )
AS
	Select
		[ProductTypeId],
		[CompanyId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	ProductType
	Where [ProductTypeId] = @pProductTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProductType_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProductType_Read] TO [profit_role_datareader]
    AS [dbo];

