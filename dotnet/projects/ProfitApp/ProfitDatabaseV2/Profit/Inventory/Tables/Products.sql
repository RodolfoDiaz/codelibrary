CREATE TABLE [Inventory].[Products] (
    [ProductId]         INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT             NOT NULL,
    [ProductCategoryId] INT             NULL,
    [PreferredVendorId] INT             NULL,
    [SKU]               NVARCHAR (80)   NOT NULL,
    [Name]              NVARCHAR (200)  NOT NULL,
    [Description]       NVARCHAR (1000) NULL,
    [UnitOfMeasure]     NVARCHAR (20)   CONSTRAINT [DF_Products_UOM] DEFAULT (N'EA') NOT NULL,
    [UnitPrice]         DECIMAL (19, 4) CONSTRAINT [DF_Products_UnitPrice] DEFAULT ((0)) NOT NULL,
    [StandardCost]      DECIMAL (19, 4) NULL,
    [TaxCodeId]         INT             NULL,
    [IsStockItem]       BIT             CONSTRAINT [DF_Products_IsStockItem] DEFAULT ((1)) NOT NULL,
    [IsActive]          BIT             CONSTRAINT [DF_Products_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]        ROWVERSION      NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductId] ASC),
    CONSTRAINT [CK_Products_StandardCost] CHECK ([StandardCost] IS NULL OR [StandardCost]>=(0)),
    CONSTRAINT [CK_Products_UnitPrice] CHECK ([UnitPrice]>=(0)),
    CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CompanyId], [ProductCategoryId]) REFERENCES [Inventory].[ProductCategories] ([CompanyId], [ProductCategoryId]),
    CONSTRAINT [FK_Products_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_Products_TaxCodes] FOREIGN KEY ([CompanyId], [TaxCodeId]) REFERENCES [Reference].[TaxCodes] ([CompanyId], [TaxCodeId]),
    CONSTRAINT [FK_Products_Vendors] FOREIGN KEY ([CompanyId], [PreferredVendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId]),
    CONSTRAINT [UQ_Products_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [ProductId] ASC),
    CONSTRAINT [UQ_Products_Company_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [ProductId] ASC),
    CONSTRAINT [UQ_Products_SKU] UNIQUE NONCLUSTERED ([CompanyId] ASC, [SKU] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Products_Company_Name]
    ON [Inventory].[Products]([CompanyId] ASC, [Name] ASC)
    INCLUDE([SKU], [UnitPrice], [IsActive]);


GO
CREATE NONCLUSTERED INDEX [IX_Products_Company_Category]
    ON [Inventory].[Products]([CompanyId] ASC, [ProductCategoryId] ASC)
    INCLUDE([SKU], [Name], [IsActive]);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_Products]
ON [Inventory].[Products]
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
        CASE WHEN i.[ProductId] IS NULL THEN 'DELETE'
             WHEN d.[ProductId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'Products',
        COALESCE(CONVERT(bigint, i.[ProductId]), CONVERT(bigint, d.[ProductId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ProductId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ProductId] = COALESCE(i.[ProductId], d.[ProductId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ProductId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ProductId] = COALESCE(i.[ProductId], d.[ProductId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ProductId] = d.[ProductId];
END;
