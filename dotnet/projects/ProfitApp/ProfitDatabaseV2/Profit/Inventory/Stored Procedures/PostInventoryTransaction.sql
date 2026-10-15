
/* ---------------------------------------------------------------------------
   Inventory movement procedure
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Inventory].[PostInventoryTransaction]
    @CompanyId int,
    @ProductId int,
    @WarehouseId int,
    @Quantity decimal(19,6),
    @TransactionType nvarchar(40),
    @UnitCost decimal(19,8) = NULL,
    @ReferenceType nvarchar(50) = NULL,
    @ReferenceId bigint = NULL,
    @Remarks nvarchar(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Quantity = 0
        THROW 51040, 'Inventory quantity cannot be zero.', 1;

    BEGIN TRANSACTION;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Inventory].[InventoryBalances] WITH (UPDLOCK, HOLDLOCK)
        WHERE CompanyId = @CompanyId
          AND ProductId = @ProductId
          AND WarehouseId = @WarehouseId
    )
    BEGIN
        INSERT [Inventory].[InventoryBalances]
            (CompanyId, ProductId, WarehouseId)
        VALUES
            (@CompanyId, @ProductId, @WarehouseId);
    END;

    INSERT [Inventory].[InventoryTransactions]
        (CompanyId, ProductId, WarehouseId, Quantity, UnitCost,
         TransactionType, ReferenceType, ReferenceId, Remarks)
    VALUES
        (@CompanyId, @ProductId, @WarehouseId, @Quantity, @UnitCost,
         @TransactionType, @ReferenceType, @ReferenceId, @Remarks);

    UPDATE B
       SET QuantityOnHand = QuantityOnHand + @Quantity,
           AverageCost =
             CASE
               WHEN @UnitCost IS NULL THEN AverageCost
               WHEN QuantityOnHand + @Quantity <= 0 THEN @UnitCost
               ELSE ((QuantityOnHand * AverageCost) + (@Quantity * @UnitCost))
                    / NULLIF(QuantityOnHand + @Quantity, 0)
             END
    FROM [Inventory].[InventoryBalances] B
    WHERE CompanyId = @CompanyId
      AND ProductId = @ProductId
      AND WarehouseId = @WarehouseId;

    COMMIT;
END;
