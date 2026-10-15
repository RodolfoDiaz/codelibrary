CREATE PROCEDURE dbo.profit_sp_Warehouse_Delete 
(	@pWarehouseId int 
 )
AS
	Delete Warehouse
	Where
		[WarehouseId] = @pWarehouseId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Warehouse_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Warehouse_Delete] TO [profit_role_fullaccess]
    AS [dbo];

