CREATE TABLE [Inventory].[InventoryTransferLines] (
    [InventoryTransferLineId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT             NOT NULL,
    [InventoryTransferId]     BIGINT          NOT NULL,
    [LineNumber]              INT             NOT NULL,
    [ProductId]               INT             NOT NULL,
    [Quantity]                DECIMAL (19, 6) NOT NULL,
    [RowVersion]              ROWVERSION      NOT NULL,
    CONSTRAINT [PK_InventoryTransferLines] PRIMARY KEY CLUSTERED ([InventoryTransferLineId] ASC),
    CONSTRAINT [CK_InventoryTransferLines_Qty] CHECK ([Quantity]>(0)),
    CONSTRAINT [FK_InventoryTransferLines_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_InventoryTransferLines_Transfers] FOREIGN KEY ([CompanyId], [InventoryTransferId]) REFERENCES [Inventory].[InventoryTransfers] ([CompanyId], [InventoryTransferId]),
    CONSTRAINT [UQ_InventoryTransferLines_Line] UNIQUE NONCLUSTERED ([InventoryTransferId] ASC, [LineNumber] ASC)
);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransferLines]
ON [Inventory].[InventoryTransferLines]
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
        CASE WHEN i.[InventoryTransferLineId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransferLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransferLines',
        COALESCE(CONVERT(bigint, i.[InventoryTransferLineId]), CONVERT(bigint, d.[InventoryTransferLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransferLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransferLineId] = COALESCE(i.[InventoryTransferLineId], d.[InventoryTransferLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransferLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransferLineId] = COALESCE(i.[InventoryTransferLineId], d.[InventoryTransferLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransferLineId] = d.[InventoryTransferLineId];
END;
