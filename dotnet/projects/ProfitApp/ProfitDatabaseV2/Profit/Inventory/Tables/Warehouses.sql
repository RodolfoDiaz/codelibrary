CREATE TABLE [Inventory].[Warehouses] (
    [WarehouseId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]   INT            NOT NULL,
    [Code]        NVARCHAR (30)  NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Address]     NVARCHAR (300) NULL,
    [City]        NVARCHAR (100) NULL,
    [StateId]     INT            NULL,
    [CountryId]   INT            NULL,
    [IsActive]    BIT            CONSTRAINT [DF_Warehouses_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]  ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Warehouses] PRIMARY KEY CLUSTERED ([WarehouseId] ASC),
    CONSTRAINT [FK_Warehouses_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_Warehouses_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_Warehouses_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_Warehouses] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_Warehouses_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [WarehouseId] ASC)
);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_Warehouses]
ON [Inventory].[Warehouses]
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
        CASE WHEN i.[WarehouseId] IS NULL THEN 'DELETE'
             WHEN d.[WarehouseId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'Warehouses',
        COALESCE(CONVERT(bigint, i.[WarehouseId]), CONVERT(bigint, d.[WarehouseId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[WarehouseId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[WarehouseId] = COALESCE(i.[WarehouseId], d.[WarehouseId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[WarehouseId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[WarehouseId] = COALESCE(i.[WarehouseId], d.[WarehouseId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[WarehouseId] = d.[WarehouseId];
END;
