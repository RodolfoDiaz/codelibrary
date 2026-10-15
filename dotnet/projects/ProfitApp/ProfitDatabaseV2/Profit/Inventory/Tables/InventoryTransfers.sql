CREATE TABLE [Inventory].[InventoryTransfers] (
    [InventoryTransferId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]           INT             NOT NULL,
    [TransferNumber]      NVARCHAR (50)   NOT NULL,
    [FromWarehouseId]     INT             NOT NULL,
    [ToWarehouseId]       INT             NOT NULL,
    [TransferDate]        DATE            NOT NULL,
    [StatusCode]          NVARCHAR (30)   NOT NULL,
    [Remarks]             NVARCHAR (1000) NULL,
    [RowVersion]          ROWVERSION      NOT NULL,
    CONSTRAINT [PK_InventoryTransfers] PRIMARY KEY CLUSTERED ([InventoryTransferId] ASC),
    CONSTRAINT [CK_InventoryTransfers_Warehouses] CHECK ([FromWarehouseId]<>[ToWarehouseId]),
    CONSTRAINT [FK_InventoryTransfers_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_InventoryTransfers_FromWarehouse] FOREIGN KEY ([CompanyId], [FromWarehouseId]) REFERENCES [Inventory].[Warehouses] ([CompanyId], [WarehouseId]),
    CONSTRAINT [FK_InventoryTransfers_ToWarehouse] FOREIGN KEY ([CompanyId], [ToWarehouseId]) REFERENCES [Inventory].[Warehouses] ([CompanyId], [WarehouseId]),
    CONSTRAINT [UQ_InventoryTransfers_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [InventoryTransferId] ASC),
    CONSTRAINT [UQ_InventoryTransfers_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [TransferNumber] ASC)
);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransfers]
ON [Inventory].[InventoryTransfers]
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
        CASE WHEN i.[InventoryTransferId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransferId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransfers',
        COALESCE(CONVERT(bigint, i.[InventoryTransferId]), CONVERT(bigint, d.[InventoryTransferId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransferId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransferId] = COALESCE(i.[InventoryTransferId], d.[InventoryTransferId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransferId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransferId] = COALESCE(i.[InventoryTransferId], d.[InventoryTransferId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransferId] = d.[InventoryTransferId];
END;
