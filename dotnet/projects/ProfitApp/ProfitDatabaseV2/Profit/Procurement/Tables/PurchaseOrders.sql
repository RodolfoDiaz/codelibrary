CREATE TABLE [Procurement].[PurchaseOrders] (
    [PurchaseOrderId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [VendorId]        INT             NOT NULL,
    [EmployeeId]      INT             NULL,
    [CurrencyId]      INT             NOT NULL,
    [PaymentMethodId] INT             NULL,
    [OrderNumber]     NVARCHAR (50)   NOT NULL,
    [OrderDate]       DATE            NOT NULL,
    [StatusCode]      NVARCHAR (30)   NOT NULL,
    [ExpectedDate]    DATE            NULL,
    [Subtotal]        DECIMAL (19, 4) CONSTRAINT [DF_PurchaseOrders_Subtotal] DEFAULT ((0)) NOT NULL,
    [DiscountAmount]  DECIMAL (19, 4) CONSTRAINT [DF_PurchaseOrders_Discount] DEFAULT ((0)) NOT NULL,
    [TaxAmount]       DECIMAL (19, 4) CONSTRAINT [DF_PurchaseOrders_Tax] DEFAULT ((0)) NOT NULL,
    [OtherCharges]    DECIMAL (19, 4) CONSTRAINT [DF_PurchaseOrders_OtherCharges] DEFAULT ((0)) NOT NULL,
    [TotalAmount]     DECIMAL (19, 4) CONSTRAINT [DF_PurchaseOrders_Total] DEFAULT ((0)) NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_PurchaseOrders_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [Remarks]         NVARCHAR (1000) NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY CLUSTERED ([PurchaseOrderId] ASC),
    CONSTRAINT [CK_PurchaseOrders_Amounts] CHECK ([Subtotal]>=(0) AND [DiscountAmount]>=(0) AND [TaxAmount]>=(0) AND [OtherCharges]>=(0) AND [TotalAmount]>=(0)),
    CONSTRAINT [CK_PurchaseOrders_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_PurchaseOrders_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_PurchaseOrders_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_PurchaseOrders_Employees] FOREIGN KEY ([CompanyId], [EmployeeId]) REFERENCES [HR].[Employees] ([CompanyId], [EmployeeId]),
    CONSTRAINT [FK_PurchaseOrders_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId]),
    CONSTRAINT [FK_PurchaseOrders_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId]),
    CONSTRAINT [UQ_PurchaseOrders_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [PurchaseOrderId] ASC),
    CONSTRAINT [UQ_PurchaseOrders_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [OrderNumber] ASC)
);


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_PurchaseOrders]
ON [Procurement].[PurchaseOrders]
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
        CASE WHEN i.[PurchaseOrderId] IS NULL THEN 'DELETE'
             WHEN d.[PurchaseOrderId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'PurchaseOrders',
        COALESCE(CONVERT(bigint, i.[PurchaseOrderId]), CONVERT(bigint, d.[PurchaseOrderId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[PurchaseOrderId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[PurchaseOrderId] = COALESCE(i.[PurchaseOrderId], d.[PurchaseOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[PurchaseOrderId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[PurchaseOrderId] = COALESCE(i.[PurchaseOrderId], d.[PurchaseOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[PurchaseOrderId] = d.[PurchaseOrderId];
END;
