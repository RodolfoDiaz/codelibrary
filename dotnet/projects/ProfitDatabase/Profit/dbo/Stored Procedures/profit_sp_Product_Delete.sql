CREATE PROCEDURE dbo.profit_sp_Product_Delete 
(	@pProductId int
 )
AS
	Delete Product
	Where
		([ProductId] = @pProductId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Delete] TO [profit_role_fullaccess]
    AS [dbo];

