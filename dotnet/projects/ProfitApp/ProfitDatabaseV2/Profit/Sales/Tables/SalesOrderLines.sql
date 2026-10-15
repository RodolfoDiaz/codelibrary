CREATE TABLE [Sales].[SalesOrderLines] (
    [SalesOrderLineId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT             NOT NULL,
    [SalesOrderId]     BIGINT          NOT NULL,
    [LineNumber]       INT             NOT NULL,
    [ProductId]        INT             NULL,
    [Description]      NVARCHAR (500)  NOT NULL,
    [Quantity]         DECIMAL (19, 6) NOT NULL,
    [UnitPrice]        DECIMAL (19, 4) NOT NULL,
    [DiscountAmount]   DECIMAL (19, 4) CONSTRAINT [DF_SalesOrderLines_Discount] DEFAULT ((0)) NOT NULL,
    [TaxCodeId]        INT             NULL,
    [TaxAmount]        DECIMAL (19, 4) CONSTRAINT [DF_SalesOrderLines_Tax] DEFAULT ((0)) NOT NULL,
    [LineTotal]        DECIMAL (19, 4) NOT NULL,
    [RowVersion]       ROWVERSION      NOT NULL,
    CONSTRAINT [PK_SalesOrderLines] PRIMARY KEY CLUSTERED ([SalesOrderLineId] ASC),
    CONSTRAINT [CK_SalesOrderLines_Discount] CHECK ([DiscountAmount]>=(0)),
    CONSTRAINT [CK_SalesOrderLines_Price] CHECK ([UnitPrice]>=(0)),
    CONSTRAINT [CK_SalesOrderLines_Qty] CHECK ([Quantity]>(0)),
    CONSTRAINT [FK_SalesOrderLines_Orders] FOREIGN KEY ([CompanyId], [SalesOrderId]) REFERENCES [Sales].[SalesOrders] ([CompanyId], [SalesOrderId]),
    CONSTRAINT [FK_SalesOrderLines_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_SalesOrderLines_TaxCodes] FOREIGN KEY ([CompanyId], [TaxCodeId]) REFERENCES [Reference].[TaxCodes] ([CompanyId], [TaxCodeId]),
    CONSTRAINT [UQ_SalesOrderLines_Line] UNIQUE NONCLUSTERED ([SalesOrderId] ASC, [LineNumber] ASC)
);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_SalesOrderLines]
ON [Sales].[SalesOrderLines]
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
        CASE WHEN i.[SalesOrderLineId] IS NULL THEN 'DELETE'
             WHEN d.[SalesOrderLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesOrderLines',
        COALESCE(CONVERT(bigint, i.[SalesOrderLineId]), CONVERT(bigint, d.[SalesOrderLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesOrderLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesOrderLineId] = COALESCE(i.[SalesOrderLineId], d.[SalesOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesOrderLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesOrderLineId] = COALESCE(i.[SalesOrderLineId], d.[SalesOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesOrderLineId] = d.[SalesOrderLineId];
END;
