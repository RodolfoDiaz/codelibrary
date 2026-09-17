CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Update
(	@pDocumentId int,
	@pProductId int,
	@pCompanyId int,
	@pQuantity int,
	@pTax money, 
	@pDiscount money,
	@pUnitPrice money,
	@pRowInfo timestamp
 )
AS
	Update ClientDocDetail
	Set
		[CompanyId] = @pCompanyId, [Quantity]  = @pQuantity, [Tax] = @pTax, [Discount] = @pDiscount, [UnitPrice] = @pUnitPrice
	Where
		[DocumentId]  = @pDocumentId AND [ProductId] = @pProductId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientDocDetail
		Where [DocumentId]  = @pDocumentId AND [ProductId] = @pProductId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Update] TO [profit_role_dataupdate]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientDocDetail_Update] TO [profit_role_fullaccess]
    AS [dbo];

