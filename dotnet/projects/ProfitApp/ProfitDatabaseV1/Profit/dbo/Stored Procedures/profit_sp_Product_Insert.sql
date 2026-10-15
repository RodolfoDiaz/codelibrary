CREATE PROCEDURE dbo.profit_sp_Product_Insert 
(	@pProductId int OUTPUT,
	@pCompanyId int,
	@pProductTypeId int,
	@pProviderId int,
	@pWarehouseId int,
	@pName varchar(50),
	@pUnitsInStock int,
	@pUnitPrice money
 )
AS
	Insert into Product
		([CompanyId], [ProductTypeId], [ProviderId], [WarehouseId], [Name], [UnitsInStock], [UnitPrice], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pProductTypeId, @pProviderId, @pWarehouseId, @pName, @pUnitsInStock, @pUnitPrice, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProductId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Product_Insert] TO [profit_role_fullaccess]
    AS [dbo];

