CREATE TABLE [Procurement].[VendorInvoices] (
    [VendorInvoiceId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [VendorId]        INT             NOT NULL,
    [PurchaseOrderId] BIGINT          NULL,
    [CurrencyId]      INT             NOT NULL,
    [PaymentMethodId] INT             NULL,
    [InvoiceNumber]   NVARCHAR (80)   NOT NULL,
    [InvoiceDate]     DATE            NOT NULL,
    [DueDate]         DATE            NULL,
    [StatusCode]      NVARCHAR (30)   NOT NULL,
    [Subtotal]        DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoices_Subtotal] DEFAULT ((0)) NOT NULL,
    [DiscountAmount]  DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoices_Discount] DEFAULT ((0)) NOT NULL,
    [TaxAmount]       DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoices_Tax] DEFAULT ((0)) NOT NULL,
    [OtherCharges]    DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoices_OtherCharges] DEFAULT ((0)) NOT NULL,
    [TotalAmount]     DECIMAL (19, 4) CONSTRAINT [DF_VendorInvoices_Total] DEFAULT ((0)) NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_VendorInvoices_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [Remarks]         NVARCHAR (1000) NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_VendorInvoices] PRIMARY KEY CLUSTERED ([VendorInvoiceId] ASC),
    CONSTRAINT [CK_VendorInvoices_Amounts] CHECK ([Subtotal]>=(0) AND [DiscountAmount]>=(0) AND [TaxAmount]>=(0) AND [OtherCharges]>=(0) AND [TotalAmount]>=(0)),
    CONSTRAINT [CK_VendorInvoices_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_VendorInvoices_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_VendorInvoices_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_VendorInvoices_Orders] FOREIGN KEY ([CompanyId], [PurchaseOrderId]) REFERENCES [Procurement].[PurchaseOrders] ([CompanyId], [PurchaseOrderId]),
    CONSTRAINT [FK_VendorInvoices_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId]),
    CONSTRAINT [FK_VendorInvoices_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId]),
    CONSTRAINT [UQ_VendorInvoices_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorInvoiceId] ASC),
    CONSTRAINT [UQ_VendorInvoices_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorInvoiceId] ASC),
    CONSTRAINT [UQ_VendorInvoices_VendorNumber] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorId] ASC, [InvoiceNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VendorInvoices_Vendor_Date]
    ON [Procurement].[VendorInvoices]([CompanyId] ASC, [VendorId] ASC, [InvoiceDate] DESC)
    INCLUDE([InvoiceNumber], [StatusCode], [TotalAmount], [DueDate]);


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_VendorInvoices]
ON [Procurement].[VendorInvoices]
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
        CASE WHEN i.[VendorInvoiceId] IS NULL THEN 'DELETE'
             WHEN d.[VendorInvoiceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorInvoices',
        COALESCE(CONVERT(bigint, i.[VendorInvoiceId]), CONVERT(bigint, d.[VendorInvoiceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorInvoiceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorInvoiceId] = COALESCE(i.[VendorInvoiceId], d.[VendorInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorInvoiceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorInvoiceId] = COALESCE(i.[VendorInvoiceId], d.[VendorInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorInvoiceId] = d.[VendorInvoiceId];
END;
