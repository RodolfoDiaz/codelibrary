CREATE TABLE [Inventory].[InventoryBalances] (
    [InventoryBalanceId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]          INT             NOT NULL,
    [ProductId]          INT             NOT NULL,
    [WarehouseId]        INT             NOT NULL,
    [QuantityOnHand]     DECIMAL (19, 6) CONSTRAINT [DF_InventoryBalances_OnHand] DEFAULT ((0)) NOT NULL,
    [QuantityReserved]   DECIMAL (19, 6) CONSTRAINT [DF_InventoryBalances_Reserved] DEFAULT ((0)) NOT NULL,
    [AverageCost]        DECIMAL (19, 8) CONSTRAINT [DF_InventoryBalances_AverageCost] DEFAULT ((0)) NOT NULL,
    [RowVersion]         ROWVERSION      NOT NULL,
    CONSTRAINT [PK_InventoryBalances] PRIMARY KEY CLUSTERED ([InventoryBalanceId] ASC),
    CONSTRAINT [CK_InventoryBalances_AverageCost] CHECK ([AverageCost]>=(0)),
    CONSTRAINT [CK_InventoryBalances_Reserved] CHECK ([QuantityReserved]>=(0)),
    CONSTRAINT [FK_InventoryBalances_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_InventoryBalances_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_InventoryBalances_Warehouses] FOREIGN KEY ([CompanyId], [WarehouseId]) REFERENCES [Inventory].[Warehouses] ([CompanyId], [WarehouseId]),
    CONSTRAINT [UQ_InventoryBalances] UNIQUE NONCLUSTERED ([CompanyId] ASC, [ProductId] ASC, [WarehouseId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InventoryBalances_Product]
    ON [Inventory].[InventoryBalances]([CompanyId] ASC, [ProductId] ASC)
    INCLUDE([WarehouseId], [QuantityOnHand], [QuantityReserved], [AverageCost]);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_InventoryBalances]
ON [Inventory].[InventoryBalances]
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
        CASE WHEN i.[InventoryBalanceId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryBalanceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryBalances',
        COALESCE(CONVERT(bigint, i.[InventoryBalanceId]), CONVERT(bigint, d.[InventoryBalanceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryBalanceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryBalanceId] = COALESCE(i.[InventoryBalanceId], d.[InventoryBalanceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryBalanceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryBalanceId] = COALESCE(i.[InventoryBalanceId], d.[InventoryBalanceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryBalanceId] = d.[InventoryBalanceId];
END;
