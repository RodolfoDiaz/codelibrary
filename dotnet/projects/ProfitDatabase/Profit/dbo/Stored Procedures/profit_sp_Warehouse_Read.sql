
CREATE PROCEDURE dbo.profit_sp_Warehouse_Read 
(	@pWarehouseId int
 )
AS
	Select
		[WarehouseId],
		[CompanyId],
		[Name],
		[Location]  ,
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Warehouse
	Where [WarehouseId] = @pWarehouseId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Warehouse_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Warehouse_Read] TO [profit_role_datareader]
    AS [dbo];

