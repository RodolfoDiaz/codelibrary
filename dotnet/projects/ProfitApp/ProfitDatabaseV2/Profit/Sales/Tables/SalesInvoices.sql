CREATE TABLE [Sales].[SalesInvoices] (
    [SalesInvoiceId]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [CustomerId]      INT             NOT NULL,
    [SalesOrderId]    BIGINT          NULL,
    [EmployeeId]      INT             NULL,
    [CurrencyId]      INT             NOT NULL,
    [PaymentMethodId] INT             NULL,
    [InvoiceNumber]   NVARCHAR (80)   NOT NULL,
    [InvoiceDate]     DATE            NOT NULL,
    [DueDate]         DATE            NULL,
    [StatusCode]      NVARCHAR (30)   NOT NULL,
    [Subtotal]        DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoices_Subtotal] DEFAULT ((0)) NOT NULL,
    [DiscountAmount]  DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoices_Discount] DEFAULT ((0)) NOT NULL,
    [TaxAmount]       DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoices_Tax] DEFAULT ((0)) NOT NULL,
    [OtherCharges]    DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoices_OtherCharges] DEFAULT ((0)) NOT NULL,
    [TotalAmount]     DECIMAL (19, 4) CONSTRAINT [DF_SalesInvoices_Total] DEFAULT ((0)) NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_SalesInvoices_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [Remarks]         NVARCHAR (1000) NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_SalesInvoices] PRIMARY KEY CLUSTERED ([SalesInvoiceId] ASC),
    CONSTRAINT [CK_SalesInvoices_Amounts] CHECK ([Subtotal]>=(0) AND [DiscountAmount]>=(0) AND [TaxAmount]>=(0) AND [OtherCharges]>=(0) AND [TotalAmount]>=(0)),
    CONSTRAINT [CK_SalesInvoices_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_SalesInvoices_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_SalesInvoices_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_SalesInvoices_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_SalesInvoices_Employees] FOREIGN KEY ([CompanyId], [EmployeeId]) REFERENCES [HR].[Employees] ([CompanyId], [EmployeeId]),
    CONSTRAINT [FK_SalesInvoices_Orders] FOREIGN KEY ([CompanyId], [SalesOrderId]) REFERENCES [Sales].[SalesOrders] ([CompanyId], [SalesOrderId]),
    CONSTRAINT [FK_SalesInvoices_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId]),
    CONSTRAINT [UQ_SalesInvoices_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [SalesInvoiceId] ASC),
    CONSTRAINT [UQ_SalesInvoices_Company_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [InvoiceNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SalesInvoices_Customer_Date]
    ON [Sales].[SalesInvoices]([CompanyId] ASC, [CustomerId] ASC, [InvoiceDate] DESC)
    INCLUDE([InvoiceNumber], [StatusCode], [TotalAmount], [DueDate]);


GO
CREATE NONCLUSTERED INDEX [IX_SalesInvoices_Status_Date]
    ON [Sales].[SalesInvoices]([CompanyId] ASC, [StatusCode] ASC, [InvoiceDate] DESC)
    INCLUDE([CustomerId], [TotalAmount]);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_SalesInvoices]
ON [Sales].[SalesInvoices]
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
        CASE WHEN i.[SalesInvoiceId] IS NULL THEN 'DELETE'
             WHEN d.[SalesInvoiceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesInvoices',
        COALESCE(CONVERT(bigint, i.[SalesInvoiceId]), CONVERT(bigint, d.[SalesInvoiceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesInvoiceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesInvoiceId] = COALESCE(i.[SalesInvoiceId], d.[SalesInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesInvoiceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesInvoiceId] = COALESCE(i.[SalesInvoiceId], d.[SalesInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesInvoiceId] = d.[SalesInvoiceId];
END;
