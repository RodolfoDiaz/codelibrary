CREATE TABLE [Inventory].[InventoryTransactions] (
    [InventoryTransactionId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]              INT             NOT NULL,
    [ProductId]              INT             NOT NULL,
    [WarehouseId]            INT             NOT NULL,
    [TransactionDate]        DATETIME2 (3)   CONSTRAINT [DF_InventoryTransactions_Date] DEFAULT (sysutcdatetime()) NOT NULL,
    [TransactionType]        NVARCHAR (40)   NOT NULL,
    [Quantity]               DECIMAL (19, 6) NOT NULL,
    [UnitCost]               DECIMAL (19, 8) NULL,
    [ReferenceType]          NVARCHAR (50)   NULL,
    [ReferenceId]            BIGINT          NULL,
    [Remarks]                NVARCHAR (1000) NULL,
    [RowVersion]             ROWVERSION      NOT NULL,
    CONSTRAINT [PK_InventoryTransactions] PRIMARY KEY CLUSTERED ([InventoryTransactionId] ASC),
    CONSTRAINT [CK_InventoryTransactions_Cost] CHECK ([UnitCost] IS NULL OR [UnitCost]>=(0)),
    CONSTRAINT [CK_InventoryTransactions_Qty] CHECK ([Quantity]<>(0)),
    CONSTRAINT [FK_InventoryTransactions_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_InventoryTransactions_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_InventoryTransactions_Warehouses] FOREIGN KEY ([CompanyId], [WarehouseId]) REFERENCES [Inventory].[Warehouses] ([CompanyId], [WarehouseId])
);


GO
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_Product_Warehouse_Date]
    ON [Inventory].[InventoryTransactions]([CompanyId] ASC, [ProductId] ASC, [WarehouseId] ASC, [TransactionDate] DESC)
    INCLUDE([Quantity], [UnitCost], [TransactionType], [ReferenceType], [ReferenceId]);


GO
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_Reference]
    ON [Inventory].[InventoryTransactions]([CompanyId] ASC, [ReferenceType] ASC, [ReferenceId] ASC);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransactions]
ON [Inventory].[InventoryTransactions]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[InventoryTransactionId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransactionId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransactions',
        COALESCE(CONVERT(bigint, i.[InventoryTransactionId]), CONVERT(bigint, d.[InventoryTransactionId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransactionId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransactionId] = COALESCE(i.[InventoryTransactionId], d.[InventoryTransactionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransactionId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransactionId] = COALESCE(i.[InventoryTransactionId], d.[InventoryTransactionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransactionId] = d.[InventoryTransactionId];
END;
