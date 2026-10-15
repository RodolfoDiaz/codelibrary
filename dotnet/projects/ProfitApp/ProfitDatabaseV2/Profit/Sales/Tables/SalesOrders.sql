CREATE TABLE [Sales].[SalesOrders] (
    [SalesOrderId]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [CustomerId]      INT             NOT NULL,
    [EmployeeId]      INT             NULL,
    [CurrencyId]      INT             NOT NULL,
    [PaymentMethodId] INT             NULL,
    [OrderNumber]     NVARCHAR (50)   NOT NULL,
    [OrderDate]       DATE            NOT NULL,
    [StatusCode]      NVARCHAR (30)   NOT NULL,
    [RequestedDate]   DATE            NULL,
    [Subtotal]        DECIMAL (19, 4) CONSTRAINT [DF_SalesOrders_Subtotal] DEFAULT ((0)) NOT NULL,
    [DiscountAmount]  DECIMAL (19, 4) CONSTRAINT [DF_SalesOrders_Discount] DEFAULT ((0)) NOT NULL,
    [TaxAmount]       DECIMAL (19, 4) CONSTRAINT [DF_SalesOrders_Tax] DEFAULT ((0)) NOT NULL,
    [OtherCharges]    DECIMAL (19, 4) CONSTRAINT [DF_SalesOrders_OtherCharges] DEFAULT ((0)) NOT NULL,
    [TotalAmount]     DECIMAL (19, 4) CONSTRAINT [DF_SalesOrders_Total] DEFAULT ((0)) NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_SalesOrders_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [Remarks]         NVARCHAR (1000) NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_SalesOrders] PRIMARY KEY CLUSTERED ([SalesOrderId] ASC),
    CONSTRAINT [CK_SalesOrders_Amounts] CHECK ([Subtotal]>=(0) AND [DiscountAmount]>=(0) AND [TaxAmount]>=(0) AND [OtherCharges]>=(0) AND [TotalAmount]>=(0)),
    CONSTRAINT [CK_SalesOrders_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_SalesOrders_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_SalesOrders_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_SalesOrders_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_SalesOrders_Employees] FOREIGN KEY ([CompanyId], [EmployeeId]) REFERENCES [HR].[Employees] ([CompanyId], [EmployeeId]),
    CONSTRAINT [FK_SalesOrders_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId]),
    CONSTRAINT [UQ_SalesOrders_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [SalesOrderId] ASC),
    CONSTRAINT [UQ_SalesOrders_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [OrderNumber] ASC)
);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_SalesOrders]
ON [Sales].[SalesOrders]
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
        CASE WHEN i.[SalesOrderId] IS NULL THEN 'DELETE'
             WHEN d.[SalesOrderId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesOrders',
        COALESCE(CONVERT(bigint, i.[SalesOrderId]), CONVERT(bigint, d.[SalesOrderId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesOrderId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesOrderId] = COALESCE(i.[SalesOrderId], d.[SalesOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesOrderId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesOrderId] = COALESCE(i.[SalesOrderId], d.[SalesOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesOrderId] = d.[SalesOrderId];
END;
