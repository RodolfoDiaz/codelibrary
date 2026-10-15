CREATE TABLE [Inventory].[ProductCategories] (
    [ProductCategoryId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT            NOT NULL,
    [Code]              NVARCHAR (30)  NOT NULL,
    [Name]              NVARCHAR (100) NOT NULL,
    [IsActive]          BIT            CONSTRAINT [DF_ProductCategories_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_ProductCategories] PRIMARY KEY CLUSTERED ([ProductCategoryId] ASC),
    CONSTRAINT [FK_ProductCategories_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_ProductCategories] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_ProductCategories_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [ProductCategoryId] ASC)
);


GO

CREATE   TRIGGER [Inventory].[tr_Audit_Inventory_ProductCategories]
ON [Inventory].[ProductCategories]
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
        CASE WHEN i.[ProductCategoryId] IS NULL THEN 'DELETE'
             WHEN d.[ProductCategoryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'ProductCategories',
        COALESCE(CONVERT(bigint, i.[ProductCategoryId]), CONVERT(bigint, d.[ProductCategoryId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ProductCategoryId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ProductCategoryId] = COALESCE(i.[ProductCategoryId], d.[ProductCategoryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ProductCategoryId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ProductCategoryId] = COALESCE(i.[ProductCategoryId], d.[ProductCategoryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ProductCategoryId] = d.[ProductCategoryId];
END;
