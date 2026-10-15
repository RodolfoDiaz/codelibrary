CREATE TABLE [Procurement].[VendorInvoiceLines] (
    [VendorInvoiceLineId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]           INT             NOT NULL,
    [VendorInvoiceId]     BIGINT          NOT NULL,
    [LineNumber]          INT             NOT NULL,
    [ProductId]           INT             NULL,
    [Description]         NVARCHAR (500)  NOT NULL,
    [Quantity]            DECIMAL (19, 6) NOT NULL,
    [UnitPrice]           DECIMAL (19, 4) NOT NULL,
    [DiscountAmount]      DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoiceLines_Discount] DEFAULT ((0)) NOT NULL,
    [TaxCodeId]           INT             NULL,
    [TaxAmount]           DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoiceLines_Tax] DEFAULT ((0)) NOT NULL,
    [LineTotal]           DECIMAL (19, 4) NOT NULL,
    [RowVersion]          ROWVERSION      NOT NULL,
    CONSTRAINT [PK_VendorInvoiceLines] PRIMARY KEY CLUSTERED ([VendorInvoiceLineId] ASC),
    CONSTRAINT [CK_VendorInvoiceLines_Discount] CHECK ([DiscountAmount]>=(0)),
    CONSTRAINT [CK_VendorInvoiceLines_Price] CHECK ([UnitPrice]>=(0)),
    CONSTRAINT [CK_VendorInvoiceLines_Qty] CHECK ([Quantity]>(0)),
    CONSTRAINT [FK_VendorInvoiceLines_Invoices] FOREIGN KEY ([CompanyId], [VendorInvoiceId]) REFERENCES [Procurement].[VendorInvoices] ([CompanyId], [VendorInvoiceId]),
    CONSTRAINT [FK_VendorInvoiceLines_Products] FOREIGN KEY ([CompanyId], [ProductId]) REFERENCES [Inventory].[Products] ([CompanyId], [ProductId]),
    CONSTRAINT [FK_VendorInvoiceLines_TaxCodes] FOREIGN KEY ([CompanyId], [TaxCodeId]) REFERENCES [Reference].[TaxCodes] ([CompanyId], [TaxCodeId]),
    CONSTRAINT [UQ_VendorInvoiceLines_Line] UNIQUE NONCLUSTERED ([VendorInvoiceId] ASC, [LineNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VendorInvoiceLines_Product]
    ON [Procurement].[VendorInvoiceLines]([CompanyId] ASC, [ProductId] ASC, [VendorInvoiceId] ASC)
    INCLUDE([Quantity], [LineTotal]);


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_VendorInvoiceLines]
ON [Procurement].[VendorInvoiceLines]
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
        CASE WHEN i.[VendorInvoiceLineId] IS NULL THEN 'DELETE'
             WHEN d.[VendorInvoiceLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorInvoiceLines',
        COALESCE(CONVERT(bigint, i.[VendorInvoiceLineId]), CONVERT(bigint, d.[VendorInvoiceLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorInvoiceLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorInvoiceLineId] = COALESCE(i.[VendorInvoiceLineId], d.[VendorInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorInvoiceLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorInvoiceLineId] = COALESCE(i.[VendorInvoiceLineId], d.[VendorInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorInvoiceLineId] = d.[VendorInvoiceLineId];
END;
