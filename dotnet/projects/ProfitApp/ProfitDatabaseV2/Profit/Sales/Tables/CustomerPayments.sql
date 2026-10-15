CREATE TABLE [Sales].[CustomerPayments] (
    [CustomerPaymentId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT             NOT NULL,
    [CustomerId]        INT             NOT NULL,
    [CurrencyId]        INT             NOT NULL,
    [PaymentMethodId]   INT             NOT NULL,
    [PaymentDate]       DATETIME2 (3)   NOT NULL,
    [Amount]            DECIMAL (19, 4) NOT NULL,
    [ExchangeRate]      DECIMAL (19, 8) CONSTRAINT [DF_CustomerPayments_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [ReferenceNumber]   NVARCHAR (100)  NULL,
    [Remarks]           NVARCHAR (1000) NULL,
    [RowVersion]        ROWVERSION      NOT NULL,
    CONSTRAINT [PK_CustomerPayments] PRIMARY KEY CLUSTERED ([CustomerPaymentId] ASC),
    CONSTRAINT [CK_CustomerPayments_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_CustomerPayments_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_CustomerPayments_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_CustomerPayments_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_CustomerPayments_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_CustomerPayments_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId])
);


GO
CREATE NONCLUSTERED INDEX [IX_CustomerPayments_Customer_Date]
    ON [Sales].[CustomerPayments]([CompanyId] ASC, [CustomerId] ASC, [PaymentDate] DESC)
    INCLUDE([Amount], [CurrencyId], [ReferenceNumber]);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_CustomerPayments]
ON [Sales].[CustomerPayments]
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
        CASE WHEN i.[CustomerPaymentId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerPaymentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'CustomerPayments',
        COALESCE(CONVERT(bigint, i.[CustomerPaymentId]), CONVERT(bigint, d.[CustomerPaymentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerPaymentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerPaymentId] = COALESCE(i.[CustomerPaymentId], d.[CustomerPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerPaymentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerPaymentId] = COALESCE(i.[CustomerPaymentId], d.[CustomerPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerPaymentId] = d.[CustomerPaymentId];
END;
