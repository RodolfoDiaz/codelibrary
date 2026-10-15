
CREATE PROCEDURE dbo.profit_sp_Product_Read
(	@pProductId int
 )
AS
	Select 
		[ProductId], 
		[CompanyId], 
		[ProductTypeId], 
		[ProviderId], 
		[WarehouseId], 
		[Name], 
		[UnitsInStock], 
		[UnitPrice], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Product
	Where [ProductId] = @pProductId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Read] TO [profit_role_datareader]
    AS [dbo];

