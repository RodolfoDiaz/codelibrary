CREATE PROCEDURE dbo.profit_sp_ProductType_Delete 
(	@pProductTypeId int
 )
AS
	Delete ProductType
	Where	[ProductTypeId] = @pProductTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProductType_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProductType_Delete] TO [profit_role_fullaccess]
    AS [dbo];

