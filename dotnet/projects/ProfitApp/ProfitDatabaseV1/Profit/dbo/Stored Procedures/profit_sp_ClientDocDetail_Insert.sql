CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Insert 
(	@pDocumentId int,
	@pProductId int,
	@pCompanyId int,
	@pQuantity int,
	@pTax money, 
	@pDiscount money,
	@pUnitPrice money
 )
AS
	Insert into ClientDocDetail
		([DocumentId] , [ProductId] , [CompanyId], [Quantity] , [Tax] , [Discount] , [UnitPrice] )
	Values
		(@pDocumentId, @pProductId, @pCompanyId, @pQuantity, @pTax, @pDiscount, @pUnitPrice)

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
		RAISERROR ('PDE#50003',16,1)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Insert] TO [profit_role_datainsert]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Insert] TO [profit_role_fullaccess]
    AS [dbo];

