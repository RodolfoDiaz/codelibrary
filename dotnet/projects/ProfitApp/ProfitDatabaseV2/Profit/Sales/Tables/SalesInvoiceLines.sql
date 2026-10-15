CREATE TABLE [Sales].[SalesInvoiceLines] (
    [SalesInvoiceLineId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]          INT             NOT NULL,
    [SalesInvoiceId]     BIGINT          NOT NULL,
    [LineNumber]         INT             NOT NULL,
    [ProductId]          INT             NULL,
    [Description]        NVARCHAR (500)  NOT NULL,
    [Quantity]           DECIMAL (19, 6) NOT NULL,
    [UnitPrice]          DECIMAL (19, 4) NOT NULL,
    [DiscountAmount]     DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoiceLines_Discount] DEFAULT ((0)) NOT NULL,
    [TaxCodeId]          INT             NULL,
    [TaxAmount]          DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoiceLines_Tax] DEFAULT ((0)) NOT NULL,
    [LineTotal]          DECIMAL (19, 4) NOT NULL,
    [RowVersion]         ROWVERSION      NOT NULL,
    CONSTRAINT [PK_SalesInvoiceLines] PRIMARY KEY CLUSTERED ([SalesInvoiceLineId] ASC),
    CONSTRAINT [CK_SalesInvoiceLines_Discount] CHECK ([DiscountAmount]>=(0)),
    CONSTRAINT [CK_SalesInvoiceLines_Price] CHECK ([UnitPrice]>=(0)),
    CONSTRAINT [CK_SalesInvoiceLines_Qty] CHECK ([Quantity]>(0)),
    CONSTRAINT [FK_SalesInvoiceLines_Invoices] FOREIGN KEY ([CompanyId], [SalesInvoiceId]) REFERENCES [Sales].[SalesInvoices] ([CompanyId], [SalesInvoiceId]),
    CONSTRAINT [FK_SalesInvoiceLines_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_SalesInvoiceLines_TaxCodes] FOREIGN KEY ([CompanyId], [TaxCodeId]) REFERENCES [Reference].[TaxCodes] ([CompanyId], [TaxCodeId]),
    CONSTRAINT [UQ_SalesInvoiceLines_Line] UNIQUE NONCLUSTERED ([SalesInvoiceId] ASC, [LineNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SalesInvoiceLines_Product]
    ON [Sales].[SalesInvoiceLines]([CompanyId] ASC, [ProductId] ASC, [SalesInvoiceId] ASC)
    INCLUDE([Quantity], [LineTotal]);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_SalesInvoiceLines]
ON [Sales].[SalesInvoiceLines]
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
        CASE WHEN i.[SalesInvoiceLineId] IS NULL THEN 'DELETE'
             WHEN d.[SalesInvoiceLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesInvoiceLines',
        COALESCE(CONVERT(bigint, i.[SalesInvoiceLineId]), CONVERT(bigint, d.[SalesInvoiceLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesInvoiceLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesInvoiceLineId] = COALESCE(i.[SalesInvoiceLineId], d.[SalesInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesInvoiceLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesInvoiceLineId] = COALESCE(i.[SalesInvoiceLineId], d.[SalesInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesInvoiceLineId] = d.[SalesInvoiceLineId];
END;
